$TestParameters = [PSCustomObject]@{
    Constant  = 'SeBatchLogonRight'
    Principal = 'BUILTIN\Power Users'
}

configuration cUserRight_Present
{
    Import-DscResource -ModuleName cUserRightsAssignment

    node localhost
    {
        cUserRight UserRight
        {
            Ensure    = 'Present'
            Constant  = $TestParameters.Constant
            Principal = $TestParameters.Principal
        }
    }
}

configuration cUserRight_Absent
{
    Import-DscResource -ModuleName cUserRightsAssignment

    node localhost
    {
        cUserRight UserRight
        {
            Ensure    = 'Absent'
            Constant  = $TestParameters.Constant
            Principal = $TestParameters.Principal
        }
    }
}
