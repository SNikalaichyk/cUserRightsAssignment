[![Build status](https://ci.appveyor.com/api/projects/status/wd1lvxj75hrvbfp7?svg=true)](https://ci.appveyor.com/project/SNikalaichyk/cuserrightsassignment)

# cUserRightsAssignment
The **cUserRightsAssignment** module contains the **cUserRight** DSC resource that provides a mechanism to manage user rights: logon rights and privileges.

You can also download this module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/cUserRightsAssignment).

## Resources

###cUserRight

The **cUserRight** DSC resource provides a mechanism to manage user rights: logon rights and privileges.

* **Ensure**: Indicates if the user right is assigned. Set this property to `Absent` to ensure that the user right is not assigned.
    Setting it to `Present` (the default value) ensures that the user right is assigned.
* **Constant**: Indicates the constant name that is associated with a user right.
    For the list of available constants, see [User Rights Assignment](https://technet.microsoft.com/en-us/library/dn221963.aspx).
* **Principal**: Indicates the identity of the principal. Valid formats are:
    * [Down-Level Logon Name](https://msdn.microsoft.com/en-us/library/windows/desktop/aa380525%28v=vs.85%29.aspx#down_level_logon_name)
    * [Security Accounts Manager (SAM) Account Name (sAMAccountName)](https://msdn.microsoft.com/en-us/library/windows/desktop/ms679635%28v=vs.85%29.aspx)
    * [User Principal Name (UPN)](https://msdn.microsoft.com/en-us/library/windows/desktop/aa380525%28v=vs.85%29.aspx#user_principal_name)

## Versions

### 1.0.2 (February 19, 2016)

* General improvements.

### 1.0.1 (February 2, 2016)

* General improvements.

### 1.0.0 (January 18, 2016)

* Initial release with the following DSC resources:
    * **cUserRight**

## Examples

### Assign logon rights

This example shows how to use the **cUserRight** DSC resource to assign logon rights.

```powershell

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

```
