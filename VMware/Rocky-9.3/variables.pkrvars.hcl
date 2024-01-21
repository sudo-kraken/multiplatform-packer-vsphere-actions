// Credentials

vcenter_username  = "user@domain"

// vSphere Objects

vcenter_insecure_connection  = true
vcenter_server               = "x.x.x.x"
vcenter_datacenter           = "DATACENTER_HERE"
vcenter_host                 = "NODE_HOSTNAME_HERE"
vcenter_datastore            = "DATASTORE_NAME"
vcenter_network              = "PortGroup-NAME"
vcenter_folder               = "PATH/TO/FOLDER"
vcenter_cluster              = "CLUSTER_NAME"

// ISO Objects

iso_path  = "[DATASTORE_NAME] PATH/TO/ISO/Rocky-9.3-x86_64-boot.iso"
iso_file           = "Rocky-9.3-x86_64-boot.iso"
iso_checksum       = "EB096F0518E310F722D5EBD4C69F0322DF4FC152C6189F93C5C797DC25F3D2E1"
iso_checksum_type  = "sha256"

// HTTP Settings

http_directory = "http"

// Virtual Machine Settings

vm_name                  = "ROCKY-9_3-PKR-V1"
vm_guest_os_type         = "centos64Guest"
vm_version               = 18
vm_firmware              = "efi"
vm_cdrom_type            = "sata"
vm_cpu_sockets           = 4
vm_cpu_cores             = 1
vm_mem_size              = 8192
vm_disk_size             = 102400
thin_provision           = true
disk_eagerly_scrub       = false
vm_disk_controller_type  = ["pvscsi"]
vm_network_card          = "vmxnet3"
vm_boot_wait             = "5s"
ssh_username             = "admin"