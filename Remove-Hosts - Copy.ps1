$connect = Connect-VIServer "SERVERNAME_HERE"
$hostEntries = "10.10.10.10[\s+](domain.here.for.reference|another.domain.here.for.reference|proxy.here.for.reference|email.server.for.reference)"
$hostsPath = "\c$\Windows\System32\drivers\etc\hosts"
$vms = Get-VM -Location * | Where-Object { $_.ExtensionData.Guest.GuestFullName -match "Windows 7" -and $_.Name -like "V[0-9]*" } #For the real thing
#$vms = Get-VM -Name "VM_NAME_HERE" #For testing

foreach($vm in $vms) {
    $hostFile = "\\" + $vm.Name + $hostsPath
    Copy-Item -Path $hostFile -Destination "$hostFile.backup" #back up host file just in case
    Write-Host $hostFile
    (Get-Content -Path $hostFile) -replace $hostEntries,"" | Out-File -FilePath $hostFile -Encoding UTF8
}
Disconnect-VIServer -Confirm:$false
