$ouPath = "DC=wd,DC=clarkinc,DC=io"  # replace with the distinguished name of the OU you want to remove Silverlight from
$uninstallCommand = "msiexec.exe /x {89F4137D-6C26-4A84-BDB8-2E5A4BB71E00} /qn"
$computers = Get-ADComputer -Filter * -SearchBase $ouPath

foreach ($computer in $computers) {
#this makes winrm work with kerberos
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value '*' -Force
    $computerName = $computer.Name
    Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value '*' -Force
    Write-Host "Uninstalling Microsoft Silverlight from $computerName"
    $credential = New-Object System.Management.Automation.PSCredential($username, $password)
    #$session = New-PSSession -ComputerName $computerName -Authentication Negotiate -Credential $credential
    $session = New-PSSession -ComputerName $computerName -UseSSL
    $silverlightInstalled = Invoke-Command -Session $session -ScriptBlock {
        # Check if the Silverlight product is installed in the registry
        $installed = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
            Where-Object {$_.DisplayName -eq $args[0]}
        return [bool]$installed
    } -ArgumentList $silverlightProduct
    if ($silverlightInstalled) {
        Write-Host "Silverlight is installed on $computerName"
    } else {
        Write-Host "Silverlight is not installed on $computerName"
    }
    Remove-PSSession $session
}
