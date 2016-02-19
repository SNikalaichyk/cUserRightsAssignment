<#
.SYNOPSIS
    Assign logon rights.
.DESCRIPTION
    This example shows how to use the cUserRight DSC resource to assign logon rights.
#>

Configuration Sample_cUserRight
{
    Import-DscResource -ModuleName cUserRightsAssignment

    # Ensure the 'Log on as a service' logon right is assigned to the local 'Power Users' group.
    cUserRight GrantServiceLogonRight
    {
        Ensure = 'Present'
        Constant = 'SeServiceLogonRight'
        Principal = 'BUILTIN\Power Users'
    }

    # Ensure the 'Log on as a batch job' logon right is not assigned to the local 'Power Users' group.
    cUserRight RevokeBatchLogonRight
    {
        Ensure = 'Absent'
        Constant = 'SeBatchLogonRight'
        Principal = 'BUILTIN\Power Users'
    }
}

$OutputPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'Sample_cUserRight'
Sample_cUserRight -OutputPath $OutputPath
Start-DscConfiguration -Path $OutputPath -Force -Verbose -Wait
