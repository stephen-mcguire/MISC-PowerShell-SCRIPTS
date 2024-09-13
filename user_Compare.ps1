<#
This script compares the group memberships of two AD users (newUser and existingUser) 
and outputs the groups that are different between them, sorted alphabetically by group name.
#>
import-module activedirectory
#Get the user you are wanting to compare access
$newUser = Read-Host 'What is the name of the user you want to compare?'
$existingUser = Read-Host 'What is the name of the existing user you are wanting to compare?'
Compare-Object -ReferenceObject (Get-AdPrincipalGroupMembership $newUser | select name | sort-object -Property name) -DifferenceObject (Get-AdPrincipalGroupMembership $existingUser | select name | sort-object -Property name) -property name -passthru