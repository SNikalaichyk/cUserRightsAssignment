[![Build status](https://ci.appveyor.com/api/projects/status/gnsxkjxht31ctan1/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/xwebadministration/branch/master)

# cUserRightsAssignment
The **cUserRightsAssignment** module contains the **cUserRight** DSC resource that provides a mechanism to manage user rights: logon rights and privileges.

You can also download this module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/cUserRightsAssignment).

## Resources

###cUserRight

The **cUserRight** DSC resource provides a mechanism to manage user rights: logon rights and privileges.

* **Ensure**: Indicates if the user right is assigned.
 Set this property to `Absent` to ensure that the user right is not granted.
 Setting it to `Present` (the default value) ensures that the user right is granted.
* **Constant**: Indicates the constant name that is associated with a user right.
 For the list of available constants, see [User Rights Assignment](https://technet.microsoft.com/en-us/library/dn221963.aspx).
* **Principal**: Indicates the identity of the principal.
 Valid name formats:
 [User Principal Name](https://msdn.microsoft.com/en-us/library/windows/desktop/aa380525%28v=vs.85%29.aspx#user_principal_name);
 [Down-Level Logon Name](https://msdn.microsoft.com/en-us/library/windows/desktop/aa380525%28v=vs.85%29.aspx#down_level_logon_name);
 [SAM Account Name (sAMAccountName)](https://msdn.microsoft.com/en-us/library/windows/desktop/ms679635%28v=vs.85%29.aspx).

## Versions

### 1.0.0.0 (January 18, 2016)

* Initial release with the following resources:
    * **cUserRight**

## Examples

### Grant logon rights

This configuration will ensure that the "**BUILTIN\Power Users**" group is granted the following logon rights:
* *Log on as a batch job*
* *Log on as a service*

```powershell

configuration Sample_cUserRight
{
    param
    (
        [String[]]$ComputerName = 'localhost'
    )

    Import-DscResource -ModuleName cUserRightsAssignment

    node $ComputerName
    {
        cUserRight BatchLogonRight
        {
            Ensure    = 'Present'
            Constant  = 'SeBatchLogonRight'
            Principal = 'BUILTIN\Power Users'
        }

        cUserRight ServiceLogonRight
        {
            Ensure    = 'Present'
            Constant  = 'SeServiceLogonRight'
            Principal = 'BUILTIN\Power Users'
        }
    }
}

Sample_cUserRight -OutputPath "$Env:SystemDrive\Sample_cUserRight"

Start-DscConfiguration -Path "$Env:SystemDrive\Sample_cUserRight" -Force -Verbose -Wait

Get-DscConfiguration

```
