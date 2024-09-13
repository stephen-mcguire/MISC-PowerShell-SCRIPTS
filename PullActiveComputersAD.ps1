# Import the Active Directory module
Import-Module ActiveDirectory

# Define the search bases for each OU
$searchBases = @(
    "OU=Computers,OU=NEED INFO,OU=NEED INFO,DC=NEED INFO,DC=NEED INFO",
    "OU=Computers,OU=NEED INFO,OU=NEED INFO,DC=NEED INFO,DC=NEED INFO",
    "OU=Computers,OU=NEED INFO,OU=NEED INFO,DC=NEED INFO,DC=NEED INFO"
)

# Initialize an array to hold all computer objects
$allComputers = @()

# Loop through each search base and retrieve computer objects
foreach ($searchBase in $searchBases) {
    $computers = Get-ADComputer -Filter * -SearchBase $searchBase -Properties Name
    $allComputers += $computers
}

# Get the total count of computers
$totalComputers = $allComputers.Count

# Create a custom object to hold the count
$output = @()
$output += [PSCustomObject]@{
    TotalCount = $totalComputers
    ComputerName = "Total Computers"
}

# Append each computer's name to the output
$output += $allComputers | Select-Object @{Name='TotalCount'; Expression={$null}}, @{Name='ComputerName'; Expression={$_.Name}}

# Define the path to save the CSV file
$csvPath = "C:\Users\USERNAME\Desktop\FilteredComputerList.csv"

# Export the output to a CSV file at the specified location
$output | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "The total number of computers and their names have been saved to $csvPath"