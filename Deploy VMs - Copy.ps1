# Before running this, you must install PowerCLI
# https://www.powershellgallery.com/packages/VMware.PowerCLI/12.0.0.15947286
​
###Script Parameters###
param(
        [int]$Count = 1,
		[string]$Folder
    )
	
###Script Setup###
$ErrorActionPreference = "Stop" #stop on first error rather than continuing
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
​
###Script Variables###
$vServer 					= "VM SERVER NAME/HOST NAME"
​
$vmTemplateName 			= "TemplateName"
$vmOSCustomizationSpecName 	= "OSCustomizationSpecName"
$vmClusterName 				= "ClusterName"
$vmDatastoreClusterName 	= "DatastoreClusterName"
$vmFolderName 				= "FolderName"
​
###Script Functions###
function Get-NextVMName() {
    #Get the next available VM name. Find all VMs with a name like VXXXX where XXXX is some number, sort them, and grab the last one (the highest value).
	#Split the V off the name, increment the number, add the V back.
	$recentName = (Get-VM -Location * | Where-Object { $_.Name -like "V[0-9]*" } | Sort-Object -Property Name | Select-Object -Last 1).Name
	$nameResult = "V" + (([int]$recentName.SubString(1)) + 1)
    
    return $nameResult
}
​
function New-VMCreate() {
    param(
        [string]$newName,
        [string]$newTemplateName,
        [string]$newOSCustomizationSpecName,
        [string]$newClusterName,
        [string]$newDatastoreClusterName,
        [string]$newFolderName
    )
​
    #Get necessary objects to pass to New-VM
    $vmTemplate 			= Get-Template -Name $newTemplateName
    $vmOSCustomizationSpec 	= Get-OSCustomizationSpec -Name $newOSCustomizationSpecName
    $vmCluster				= Get-Cluster -Name $newClusterName								#Get the cluster
    $vmDatastoreCluster		= Get-DatastoreCluster -Name $newDatastoreClusterName
    $vmFolder				= Get-Folder -Name $newFolderName
​
    $newVM = New-VM -Name $vmName -Template $vmTemplate -OSCustomizationSpec $vmOSCustomizationSpec -ResourcePool $vmCluster -DataStore $vmDatastoreCluster -Location $vmFolder -Confirm:$true -WhatIf:$false
​
    return $newVM
}
​
###Script Body###
​
if($Folder) {
    $vmFolderName = $Folder
}
​
#connect to vCenter
Write-Host "Connecting to VDI vCenter..."
$connect = Connect-VIServer $vServer
if(!$connect) {
	Write-Host "Failed to connect to VDI vCenter..." -ForegroundColor Red
	Exit
}
Write-Host "Connected to VDI vCenter." -ForeGroundColor Green
​
$confirm = Read-Host "Create $Count new Virtual Machines?[yes/no]"
​
if("no" -match $confirm) {
    Write-Host "Operation cancelled."
    Exit
}
​
for($n = 1; $n -le $Count; $n++) {
    Write-Host "Creating VM $n of $Count..."
​
    #Get the VM name
    Write-Host "Determining new VM name..."
    $vmName = Get-NextVMName
    Write-Host "New VM Name: $vmName." -ForegroundColor Green 
​
    #Create the VM
    Write-Host "Creating new VM with the name $vmName..."
    $newVM = New-VMCreate -newName $vmName -newTemplateName $vmTemplateName -newOSCustomizationSpecName $vmOSCustomizationSpecName -newClusterName $vmClusterName -newDatastoreClusterName $vmDatastoreClusterName -newFolderName $vmFolderName
    Write-Host "Successfully created $vmName. " -ForegroundColor Green
​
    #Power on the VM
    Write-Host "Powering on $vmName..."
    $poweredVM = Start-VM -VM $newVM
    Write-Host "Successfully powered on $vmName." -ForegroundColor Green
}
​
#Disconnect from VDI vCenter
Disconnect-VIServer -Confirm:$false