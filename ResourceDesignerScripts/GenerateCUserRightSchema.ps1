#requires -Version 4.0 -Modules xDSCResourceDesigner

$DSCModuleName   = 'cUserRightsAssignment'
$DSCResourceName = 'cUserRight'

$DSCResourceProperties =  @(
    (New-xDscResourceProperty -Type String -Attribute Write -Name Ensure -ValidateSet 'Absent', 'Present' -Description 'Indicates if the user right is assigned.')
    (New-xDscResourceProperty -Type String -Attribute Key -Name Constant -Description 'Indicates the constant name that is associated with a user right.' `
        -ValidateSet @(
            'SeAssignPrimaryTokenPrivilege',
            'SeAuditPrivilege',
            'SeBackupPrivilege',
            'SeBatchLogonRight',
            'SeChangeNotifyPrivilege',
            'SeCreateGlobalPrivilege',
            'SeCreatePagefilePrivilege',
            'SeCreatePermanentPrivilege',
            'SeCreateSymbolicLinkPrivilege',
            'SeCreateTokenPrivilege',
            'SeDebugPrivilege',
            'SeDenyBatchLogonRight',
            'SeDenyInteractiveLogonRight',
            'SeDenyNetworkLogonRight',
            'SeDenyRemoteInteractiveLogonRight',
            'SeDenyServiceLogonRight',
            'SeEnableDelegationPrivilege',
            'SeImpersonatePrivilege',
            'SeIncreaseBasePriorityPrivilege',
            'SeIncreaseQuotaPrivilege',
            'SeIncreaseWorkingSetPrivilege',
            'SeInteractiveLogonRight',
            'SeLoadDriverPrivilege',
            'SeLockMemoryPrivilege',
            'SeMachineAccountPrivilege',
            'SeManageVolumePrivilege',
            'SeNetworkLogonRight',
            'SeProfileSingleProcessPrivilege',
            'SeRelabelPrivilege',
            'SeRemoteInteractiveLogonRight',
            'SeRemoteShutdownPrivilege',
            'SeRestorePrivilege',
            'SeSecurityPrivilege',
            'SeServiceLogonRight',
            'SeShutdownPrivilege',
            'SeSyncAgentPrivilege',
            'SeSystemEnvironmentPrivilege',
            'SeSystemProfilePrivilege',
            'SeSystemTimePrivilege',
            'SeTakeOwnershipPrivilege',
            'SeTcbPrivilege',
            'SeTimeZonePrivilege',
            'SeTrustedCredManAccessPrivilege',
            'SeUndockPrivilege'
        )
    ),
    (New-xDscResourceProperty -Type String -Attribute Key -Name Principal -Description 'Indicates the identity of the principal.')
)

New-xDscResource -Name $DSCResourceName -ModuleName $DSCModuleName -Property $DSCResourceProperties -Verbose
