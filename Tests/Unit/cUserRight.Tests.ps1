#requires -Version 4.0 -Modules Pester

$Global:DSCModuleName = 'cUserRightsAssignment'
$Global:DSCResourceName = 'cUserRight'

#region Header

$ModuleRoot = Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent | Split-Path -Parent | Split-Path -Parent

if (
    (-not (Test-Path -Path (Join-Path -Path $ModuleRoot -ChildPath 'DSCResource.Tests') -PathType Container)) -or
    (-not (Test-Path -Path (Join-Path -Path $ModuleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -PathType Leaf))
)
{
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git', (Join-Path -Path $ModuleRoot -ChildPath 'DSCResource.Tests'))
}
else
{
    & git @('-C', (Join-Path -Path $ModuleRoot -ChildPath 'DSCResource.Tests'), 'pull')
}

Import-Module -Name (Join-Path -Path $ModuleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force

$TestEnvironment = Initialize-TestEnvironment -DSCModuleName $Global:DSCModuleName -DSCResourceName $Global:DSCResourceName -TestType Unit

#endregion

# Begin Testing
try
{
    #region Unit Tests

    InModuleScope $Global:DSCResourceName {

        $TestParameters = [PSCustomObject]@{
            Constant = 'SeBatchLogonRight'
            Principal = 'CONTOSO\John_Doe'
        }

        Describe "$Global:DSCResourceName\Get-TargetResource" {

            Context 'User right is granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $TestParameters.Principal
                        UserRights = [String[]]@($TestParameters.Constant)
                    }
                }

                $Result = Get-TargetResource -Constant $TestParameters.Constant -Principal $TestParameters.Principal

                It 'Should call the Get-UserRight helper function once' {
                    Assert-MockCalled -CommandName Get-UserRight -Exactly 1
                }

                It 'Should return Ensure set to Present' {
                    $Result.Ensure | Should Be 'Present'
                }

                It 'Should return Constant' {
                    $Result.Constant | Should Be $TestParameters.Constant
                }

                It 'Should return Principal' {
                    $Result.Principal | Should Be $TestParameters.Principal
                }

            }

            Context 'User right is not granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $TestParameters.Principal
                        UserRights = [String[]]@()
                    }
                }

                $Result = Get-TargetResource -Constant $TestParameters.Constant -Principal $TestParameters.Principal

                It 'Should call the Get-UserRight helper function once' {
                    Assert-MockCalled -CommandName Get-UserRight -Exactly 1
                }

                It 'Should return Ensure set to Absent' {
                    $Result.Ensure | Should Be 'Absent'
                }

                It 'Should return Constant' {
                    $Result.Constant | Should Be $TestParameters.Constant
                }

                It 'Should return Principal' {
                    $Result.Principal | Should Be $TestParameters.Principal
                }

            }

        }

        Describe "$Global:DSCResourceName\Test-TargetResource" {

            Context 'Ensure is set to Absent and user right is granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $TestParameters.Principal
                        UserRights = [String[]]@($TestParameters.Constant)
                    }
                }

                $Result = Test-TargetResource -Ensure 'Absent' -Constant $TestParameters.Constant -Principal $TestParameters.Principal

                It 'Should return False' {
                    $Result | Should Be $false
                }

            }

            Context 'Ensure is set to Absent and user right is not granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $TestParameters.Principal
                        UserRights = [String[]]@()
                    }
                }

                $Result = Test-TargetResource -Ensure 'Absent' -Constant $TestParameters.Constant -Principal $TestParameters.Principal

                It 'Should return True' {
                    $Result | Should Be $true
                }

            }

            Context 'Ensure is set to Present and user right is granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $TestParameters.Principal
                        UserRights = [String[]]@($TestParameters.Constant)
                    }
                }

                $Result = Test-TargetResource -Ensure 'Present' -Constant $TestParameters.Constant -Principal $TestParameters.Principal

                It 'Should return True' {
                    $Result | Should Be $true
                }

            }

            Context 'Ensure is set to Present and user right is not granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $TestParameters.Principal
                        UserRights = [String[]]@()
                    }
                }

                $Result = Test-TargetResource -Ensure 'Present' -Constant $TestParameters.Constant -Principal $TestParameters.Principal

                It 'Should return False' {
                    $Result | Should Be $false
                }

            }

        }

        Describe "$Global:DSCResourceName\Set-TargetResource" {

            Context 'Ensure is set to Absent' {

                Mock -CommandName Revoke-UserRight -ParameterFilter {
                    $Principal -eq $TestParameters.Principal -and $UserRights -eq $TestParameters.Constant
                }

                Set-TargetResource -Ensure 'Absent' -Constant $TestParameters.Constant -Principal $TestParameters.Principal

                It 'Should call the Revoke-UserRight helper function once' {
                    Assert-MockCalled -CommandName Revoke-UserRight -Exactly 1
                }

            }

            Context 'Ensure is set to Present' {

                Mock -CommandName Grant-UserRight -ParameterFilter {
                    $Principal -eq $TestParameters.Principal -and $UserRights -eq $TestParameters.Constant
                }

                Set-TargetResource -Ensure 'Present' -Constant $TestParameters.Constant -Principal $TestParameters.Principal

                It 'Should call the Grant-UserRight helper function once' {
                    Assert-MockCalled -CommandName Grant-UserRight -Exactly 1
                }

            }

        }

        Describe "$Global:DSCResourceName\Initialize-CustomType" {

            It 'Should not throw' {
                {Initialize-CustomType} | Should Not Throw
            }

        }

    }

    #endregion
}
finally
{
    #region Footer

    Restore-TestEnvironment -TestEnvironment $TestEnvironment

    #endregion
}
