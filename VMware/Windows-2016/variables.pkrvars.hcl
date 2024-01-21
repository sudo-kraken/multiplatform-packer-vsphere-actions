// vCenter server to connect to
vcenter_server = "x.x.x.x"

// Username for vCenter authentication
vcenter_user = "user@domain"

// vCenter datacenter to use
vcenter_datacenter = "DATACENTER_HERE"

// vCenter datastore to use
vcenter_datastore = "DATASTORE_HERE"

// ESX host to use
esx_host = "NODE_HOSTNAME_HERE"

// vCenter cluster to use
vcenter_cluster = "CLUSTER_NAME_HERE"

// vCenter folder to use
vcenter_folder = "PATH/TO/FOLDER/HERE"

// vCenter Port Group to use for the network
vm_network = "PORT_GROUP_NAME_HERE"

// Name to assign to the VM
vm_name = "WS16-PKR-V1"

// Notes to assign to the VM
vm_notes = "WS16-PKR-V1 Built by [ GitHub Actions - Packer ]"

// Number of cores to assign to the VM
numcores = "8"

// Size of memory to assign to the VM
memsize = "16384"

// Size of the disk to assign to the VM
disk_size = "102400"

// Checksum of the ISO image
iso_checksum = "sha256:4CAEB24B661FCEDE81CD90661AEC31AA69753BF49A5AC247253DD021BC1B5CBB"

// Wait time before booting
boot_wait = "3s"

// Command to execute on boot
boot_command = [  "<enter>"                    
               ]
               
// OS username for WinRM
os_user = "Administrator"

// OS Password for WinRM
os_password = "Passw0rd."