<#
.SYNOPSIS
    Granularly assign user rights.
.DESCRIPTION
    This example shows how to use the cUserRight DSC resource to granularly assign user rights.
#>

Configuration Sample_cUserRight
{
    Import-DscResource -ModuleName cUserRightsAssignment

    # Ensure the 'Log on as a service' user right is assigned to the local 'Power Users' group.
    cUserRight GrantServiceLogonRight
    {
        Ensure = 'Present'
        Constant = 'SeServiceLogonRight'
        Principal = 'BUILTIN\Power Users'
    }

    # Ensure the 'Log on as a batch job' user right is not assigned to the local 'Power Users' group.
    cUserRight RevokeBatchLogonRight
    {
        Ensure = 'Absent'
        Constant = 'SeBatchLogonRight'
        Principal = 'BUILTIN\Power Users'
    }
}

Sample_cUserRight -OutputPath "$Env:SystemDrive\Sample_cUserRight"

Start-DscConfiguration -Path "$Env:SystemDrive\Sample_cUserRight" -Force -Verbose -Wait

Get-DscConfiguration
