# Import the Active Directory module (requires RSAT)
Import-Module ActiveDirectory
Install-Module -Name ImportExcel

# Define the OUs to search in
$OUs = @(
    "OU=EndUsers,OU=Users,OU=NEED INFO,OU=NEED INFO,DC=NEED INFO,DC=NEED INFO",
    "OU=EndUsers,OU=Users,OU=NEED INFO,OU=NEED INFO,DC=NEED INFO,DC=NEED INFO",
    "OU=EndUsers,OU=Users,OU=NEED INFO,OU=NEED INFO,DC=NEED INFO,DC=NEED INFO",
    "OU=EndUsers,OU=Users,OU=NEED INFO,OU=NEED INFO,DC=NEED INFO,DC=NEED INFO"
)

# Initialize an empty array to store results
$results = @()

# Iterate over each OU and get users with a login script
foreach ($ou in $OUs) {
    $users = Get-ADUser -Filter * -SearchBase $ou -Property SamAccountName, ScriptPath | Where-Object { $_.ScriptPath -ne $null }
    foreach ($user in $users) {
        $results += [PSCustomObject]@{
            ScriptName = $user.ScriptPath
            UserName   = $user.SamAccountName
            OU         = $ou
        }
    }
}

# Group the results by ScriptPath
$groupedResults = $results | Group-Object -Property ScriptName | ForEach-Object {
    [PSCustomObject]@{
        ScriptName   = $_.Name
        UserCount    = $_.Count
        Users        = ($_.Group | Select-Object -ExpandProperty UserName) -join ", "
    }
}

# Get the current user's desktop path
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$excelPath = Join-Path -Path $desktopPath -ChildPath "loginScriptCompare.xlsx"

# Export the results to Excel
$groupedResults | Export-Excel -Path $excelPath -AutoSize -Title "Login Script Comparison" -WorksheetName "Scripts"

Write-Output "Results exported to $excelPath"
