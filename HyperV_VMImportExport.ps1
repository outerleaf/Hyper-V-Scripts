<#
Hyper-V VM Import/Export Script
A basic script to import or export Hyper-V VMs
Note: Requires admin priviledges
Author: Ian Woytowich
#>

# Prompts the user if they would like to import or export a VM
$choice = Read-Host -Prompt 'Would you like to (1) export a VM or (2) import a VM?'

switch ($choice) {
1 {# Exports the chosen VM to the chosen destination
   $VM_name = Read-Host -Prompt 'Please enter the name of the VM you would like to export'
   $ExportPath = Read-Host -Prompt 'Please enter the full path you would like to export the VM to'
   Export-VM -Name $VM_name -Path $ExportPath
   Write-Host 'Export complete'}
2 {# Imports the chosen VM to the chosen destination
   $ImportSource = Read-Host -Prompt 'Please enter the full path to the VM you would like to import (The file ending in .vmcx)'
   $VHDPath = Read-Host -Prompt 'Please enter the full path for the imported VHD to be stored'
   $VMPath = Read-Host -Prompt 'Please enter the full path for the imported VM to be stored'
   Import-VM -Path $ImportSource -Copy -GenerateNewId -VhdDestinationPath $VHDPath -VirtualMachinePath $VMPath}
default {Write-Host 'You selected an incorrect option, exiting'}
}