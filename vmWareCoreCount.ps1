# Set PowerCLI configuration to ignore invalid certificates
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

# Set security protocols
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'

# Create credential store items for both servers
New-VICredentialStoreItem -Host VMWARE_HOST -User ADMIN_USER -Password "Cant Tell you ;)!"
New-VICredentialStoreItem -Host VMWARE_HOST -User ADMIN_USER -Password "Cant Tell you ;)!"

# Connect to both vSphere servers
Connect-VIServer -Server VMWARE_HOST,VMWARE_HOST

# Get the VM host information and compute cores and vCPU
Get-VMHost | 
Select Name,
    @{N="Cores"; E={$_.ExtensionData.Summary.Hardware.NumCpuCores}},
    @{N="vCPU"; E={Get-VM -Location $_ | Measure-Object -Property NumCpu -Sum | select -ExpandProperty Sum}}