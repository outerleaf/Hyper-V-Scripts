<#
Hyper-V VM Creation Script
A basic script to create a given amount of Hyper-V VMs
Note: Requires admin priviledges
Author: Ian Woytowich
#>

# Gets the number of VMs that need created
$VM_amount = Read-Host -Prompt 'Please enter the number of VMs you would like to create'
$id = 0

# Cycles until every VM has been created
while ($id -lt $VM_amount) {
    # Prompts the user for VM information
    $VM_name = Read-Host -Prompt "What would you like to name VM $id"
    $StartupMemory = Read-Host -Prompt 'How much memory would you like to assign to this VM?'
    $VHD_path = Read-Host -Prompt 'Please enter the full path where you would like to store the VMs VHD'
    $VHD_size = Read-Host -Prompt 'Please enter the size of the VMs VHD'

    # Creates a new VM with the specified information
    New-VM -Name $VM_name -MemoryStartupBytes ([uint64] ($StartupMemory / 1)) -NewVHDPath ($VHD_path + $VM_name + '.vhdx') -NewVHDSizeBytes ([uint64] ($VHD_size / 1))

    # Prompts the user if they would like to enable dynamic memory on the VM and enables it if they wish
    $choice = Read-Host -Prompt 'Would you like to enable dynamic memory on this VM? (y or n)'
    switch ($choice){
    y {$MaxMemory = Read-Host -Prompt 'Please enter the maximum memory in for this VM'
       Set-VMMemory $VM_name -DynamicMemoryEnabled $true -MaximumBytes ([uint64] ($MaxMemory / 1))}
    n {Write-Host 'You have selected not to enable dynamic memory on this VM'}
    default {Write-Host 'You have selected an incorrect option, dynamic memory will not be enabled on this VM'}
    }

    # Prompts the user if they would like set the CPU core count on the VM and sets it to their liking
    $choice = Read-Host -Prompt 'Would you like to set the CPU core count on this VM, by default it is only one core (y or n)'
    switch ($choice){
    y {$CPU_CoreAmount = Read-Host -Prompt 'Please enter the number of CPU cores for this VM'
       Set-VMProcessor $VM_name -Count $CPU_CoreAmount}
    n {Write-Host 'You have selected not to change the CPU core count on this VM'}
    default {Write-Host 'You have selected an incorrect option, CPU core counts are unchanged on this VM'}
    }

    # Prompts the user for an ISO file to load into the VM
    $ISO_path = Read-Host -Prompt 'Please enter the full path to the ISO file you would like to load on this VM'
    # Loads the DVD drive with ISO
    Set-VMDvdDrive $VM_name -Path $ISO_path

    # Prompts the user if they would like to start the VM
    $choice = Read-Host -Prompt 'Would you like to start this VM? (y or n)'
    switch ($choice){
    y {Start-VM -Name $VM_name}
    n {Get-VM -Name $VM_name
       Write-Host "You have chosen not to start the VM. This is the current information of VM $id $VM_name"}
    default {Write-Host 'You have selected an incorrect option, this VM will not be started'}
    }

    $id++
}