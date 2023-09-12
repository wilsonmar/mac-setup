
# From ListUserAndPermissions.ps1 in
# https://github.com/vinijmoura/Azure-DevOps/blob/master/PowerShell/ListUserAndPermissions/ListUserAndPermissions.ps1
# # https://vinijmoura.medium.com/how-to-list-all-users-and-group-permissions-on-azure-devops-using-azure-devops-cli-54f73a20a4c7

Param
(
    [string]$PAT,
    [string]$Organization
)

$UserGroups = @()

echo $PAT | az devops login --org $Organization

az devops configure --defaults organization=$Organization

$allUsers = az devops user list --org $Organization | ConvertFrom-Json

foreach($au in $allUsers.members)
{
    $au.user.principalName
    $au.user.descriptor
    $activeUserGroups = az devops security group membership list --id $au.user.principalName --org $Organization --relationship memberof | ConvertFrom-Json
    if ($activeUserGroups)
    {
        [array]$groups = ($activeUserGroups | Get-Member -MemberType NoteProperty).Name

        foreach ($aug in $groups)
        {
            $UserGroups += New-Object -TypeName PSObject -Property @{
                                                principalName=$au.user.principalName
                                                displayName=$au.user.displayName
                                                GroupName=$activeUserGroups.$aug.principalName
                                                }
        }
    }
}

$UserGroups | ConvertTo-Json | Out-File -FilePath "$home\desktop\UserGroups.json"