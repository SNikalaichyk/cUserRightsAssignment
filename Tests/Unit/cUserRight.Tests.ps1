$Global:DSCModuleName   = 'cUserRightsAssignment'
$Global:DSCResourceName = 'cUserRight'

#region HEADER
if ( (-not (Test-Path -Path '.\DSCResource.Tests\')) -or `
     (-not (Test-Path -Path '.\DSCResource.Tests\TestHelper.psm1')) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git')
}
else
{
    & git @('-C',(Join-Path -Path (Get-Location) -ChildPath '\DSCResource.Tests\'),'pull')
}
Import-Module .\DSCResource.Tests\TestHelper.psm1 -Force
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $Global:DSCModuleName `
    -DSCResourceName $Global:DSCResourceName `
    -TestType Unit
#endregion

# Begin Testing
try
{
    #region Pester Tests

    InModuleScope -ModuleName $Global:DSCResourceName -ScriptBlock {

        $MockParameters = [PSCustomObject]@{
            Constant  = 'SeBatchLogonRight'
            Principal = 'CONTOSO\John_Doe'
        }

        Describe "$Global:DSCResourceName\Get-TargetResource" {

            Context 'User right is granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $MockParameters.Principal
                        UserRights = [String[]]@($MockParameters.Constant)
                    }
                }

                $Result = Get-TargetResource -Constant $MockParameters.Constant -Principal $MockParameters.Principal

                It 'Should call the Get-UserRight helper function once' {
                    Assert-MockCalled -CommandName Get-UserRight -Exactly 1
                }

                It 'Should return Ensure set to Present' {
                    $Result.Ensure | Should Be 'Present'
                }

                It 'Should return Constant' {
                    $Result.Constant | Should Be $MockParameters.Constant
                }

                It 'Should return Principal' {
                    $Result.Principal | Should Be $MockParameters.Principal
                }

            }

            Context 'User right is not granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $MockParameters.Principal
                        UserRights = [String[]]@()
                    }
                }

                $Result = Get-TargetResource -Constant $MockParameters.Constant -Principal $MockParameters.Principal

                It 'Should call the Get-UserRight helper function once' {
                    Assert-MockCalled -CommandName Get-UserRight -Exactly 1
                }

                It 'Should return Ensure set to Absent' {
                    $Result.Ensure | Should Be 'Absent'
                }

                It 'Should return Constant' {
                    $Result.Constant | Should Be $MockParameters.Constant
                }

                It 'Should return Principal' {
                    $Result.Principal | Should Be $MockParameters.Principal
                }

            }

        }

        Describe "$Global:DSCResourceName\Test-TargetResource" {

            Context 'Ensure is set to Absent and user right is granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $MockParameters.Principal
                        UserRights = [String[]]@($MockParameters.Constant)
                    }
                }

                $Result = Test-TargetResource -Ensure 'Absent' -Constant $MockParameters.Constant -Principal $MockParameters.Principal

                It 'Should return False' {
                    $Result | Should Be $false
                }

            }

            Context 'Ensure is set to Absent and user right is not granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $MockParameters.Principal
                        UserRights = [String[]]@()
                    }
                }

                $Result = Test-TargetResource -Ensure 'Absent' -Constant $MockParameters.Constant -Principal $MockParameters.Principal

                It 'Should return True' {
                    $Result | Should Be $true
                }

            }

            Context 'Ensure is set to Present and user right is granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $MockParameters.Principal
                        UserRights = [String[]]@($MockParameters.Constant)
                    }
                }

                $Result = Test-TargetResource -Ensure 'Present' -Constant $MockParameters.Constant -Principal $MockParameters.Principal

                It 'Should return True' {
                    $Result | Should Be $true
                }

            }

            Context 'Ensure is set to Present and user right is not granted' {

                Mock -CommandName Get-UserRight -MockWith {
                    [PSCustomObject]@{
                        Principal = $MockParameters.Principal
                        UserRights = [String[]]@()
                    }
                }

                $Result = Test-TargetResource -Ensure 'Present' -Constant $MockParameters.Constant -Principal $MockParameters.Principal

                It 'Should return False' {
                    $Result | Should Be $false
                }

            }

        }

        Describe "$Global:DSCResourceName\Set-TargetResource" {

            Context 'Ensure is set to Absent' {

                Mock -CommandName Revoke-UserRight -ParameterFilter {
                    $Principal -eq $MockParameters.Principal -and $UserRights -eq $MockParameters.Constant
                }

                Set-TargetResource -Ensure 'Absent' -Constant $MockParameters.Constant -Principal $MockParameters.Principal

                It 'Should call the Revoke-UserRight helper function once' {
                    Assert-MockCalled -CommandName Revoke-UserRight -Exactly 1
                }

            }

            Context 'Ensure is set to Present' {

                Mock -CommandName Grant-UserRight -ParameterFilter {
                    $Principal -eq $MockParameters.Principal -and $UserRights -eq $MockParameters.Constant
                }

                Set-TargetResource -Ensure 'Present' -Constant $MockParameters.Constant -Principal $MockParameters.Principal

                It 'Should call the Grant-UserRight helper function once' {
                    Assert-MockCalled -CommandName Grant-UserRight -Exactly 1
                }

            }

        }

        Describe "$Global:DSCResourceName\Initialize-CustomType" {

            It 'Should not throw an error' {
                {Initialize-CustomType} | Should Not Throw
            }

        }

    }

    #endregion
}
catch
{
    #region FOOTER
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
    #endregion
}
