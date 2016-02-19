$TestParameters = [PSCustomObject]@{
    Constant = 'SeBatchLogonRight'
    Principal = 'BUILTIN\Power Users'
}

Configuration cUserRight_Present
{
    Import-DscResource -ModuleName cUserRightsAssignment

    Node localhost
    {
        cUserRight TestPresent
        {
            Ensure = 'Present'
            Constant = $TestParameters.Constant
            Principal = $TestParameters.Principal
        }
    }
}

Configuration cUserRight_Absent
{
    Import-DscResource -ModuleName cUserRightsAssignment

    Node localhost
    {
        cUserRight TestAbsent
        {
            Ensure = 'Absent'
            Constant = $TestParameters.Constant
            Principal = $TestParameters.Principal
        }
    }
}
