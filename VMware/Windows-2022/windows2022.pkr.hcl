// Define the required Packer version and plugins
packer {
  required_version = ">= 1.10.0"
  required_plugins {
    vsphere = {
      version = ">= v1.2.1"
      source = "github.com/hashicorp/vsphere" // Source of the vSphere plugin
    }
  }
}

// Declare variables to use in the script
// You should set these variables either via the command line, environment variables, or variable files

// The vCenter server to connect to
variable "vcenter_server" {
  type = string
  description = "The vCenter server to connect to"
}

// The username to use for authentication with the vCenter server
variable "vcenter_user" {
  type = string
  description = "The username to use for authentication with the vCenter server"
}

// The password to use for authentication with the vCenter server
variable "vcenter_password" {
  type = string
  description = "The password to use for authentication with the vCenter server"
}

// The vCenter datacenter to use
variable "vcenter_datacenter" {
  type = string
  description = "The vCenter datacenter to use"
}

// The vCenter datastore to use
variable "vcenter_datastore" {
  type = string
  description = "The vCenter datastore to use"
}

// The ESX host to use
variable "esx_host" {
  type = string
  description = "The ESX host to use"
}

// The vCenter cluster to use
variable "vcenter_cluster" {
  type = string
  description = "The vCenter cluster to use"
}

// The vCenter folder to use
variable "vcenter_folder" {
  type = string
  description = "The vCenter folder to use"
}

// The network to assign to the VM
variable "vm_network" {
  type = string
  description = "The network to assign to the VM"
}

// The name to assign to the VM
variable "vm_name" {
  type = string
  description = "The name to assign to the VM"
}

// Notes to assign to the VM
variable "vm_notes" {
  type = string
  description = "Notes to assign to the VM"
}

// The number of cores to assign to the VM
variable "numcores" {
  type = string
  description = "The number of cores to assign to the VM"
}

// The size of memory to assign to the VM
variable "memsize" {
  type = string
  description = "The size of memory to assign to the VM"
}

// The size of the disk to assign to the VM
variable "disk_size" {
  type = string
  description = "The size of the disk to assign to the VM"
}

// The checksum of the ISO image
variable "iso_checksum" {
  type = string
  description = "The checksum of the ISO image"
}

// The wait time before booting
variable "boot_wait" {
  type = string
  description = "The wait time before booting"
}

// The command to execute on boot
variable "boot_command" {
  type = list(string)
  description = "The command to execute on boot"
}

// The OS password to use for SSH
variable "os_password" {
  type = string
  description = "The OS password to use for SSH"
}

// The OS username to use for SSH
variable "os_user" {
  type = string
  description = "The OS username to use for SSH"
}

// Source block specifies the kind of image we're going to build (in this case, vsphere-iso)
source "vsphere-iso" "ws2022" {
  
  // vCenter Connection Details
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_user
  password            = var.vcenter_password
  datacenter          = var.vcenter_datacenter
  datastore           = var.vcenter_datastore
  host                = var.esx_host
  cluster             = var.vcenter_cluster
  folder              = var.vcenter_folder
  insecure_connection = true

  // VM Details
  vm_name              = var.vm_name
  vm_version           = 18
  guest_os_type        = "windows2019srvNext_64Guest"
  notes                = var.vm_notes 
  tools_upgrade_policy = true
  firmware             = "efi"
  CPUs                 = var.numcores
  cpu_cores            = var.numcores  
  CPU_hot_plug         = false
  RAM                  = var.memsize
  RAM_hot_plug         = false  
  remove_cdrom         = true
  convert_to_template  = true
  disk_controller_type = ["pvscsi"]

  // Disk Storage details
  storage {
    disk_size             = var.disk_size
    disk_thin_provisioned = true
  }
  
  // Network adapter details
  network_adapters {
    network      = var.vm_network
    network_card = "vmxnet3"
  }

  // Iso Variables  
  iso_checksum = var.iso_checksum
  iso_paths    = [ 
      "[DATASTORE_NAME] PATH/TO/ISO/SW_DVD9_Win_Server_STD_CORE_2022_2108.15_64Bit_English_DC_STD_MLF_X23-31801.ISO" ,
      "[] /vmimages/tools-isoimages/windows.iso"
  ]

  //iso_url      = var.iso_url

  /// HTTP Directory and Boot Variables
  http_directory = "./"
  boot_wait      = var.boot_wait  
  boot_command   = var.boot_command
  cd_files = [
        "configs/autounattend.xml", 
        "scripts/install-vmware-tools-from-iso.ps1"
  ]
 
  // OS Connection Details
  communicator              = "ssh"  
  ssh_clear_authorized_keys = true
  ssh_password              = var.os_password
  ssh_timeout               = "1h"
  ssh_username              = var.os_user

  // Shutdown Commands
  shutdown_command = "powershell.exe -Command \"& {New-ItemProperty -Path 'HKLM:\\SOFTWARE\\OpenSSH' -Name DefaultShell -Value 'C:\\Program Files\\PowerShell\\7\\pwsh.exe' -PropertyType String -Force; Start-Sleep -Seconds 5; C:\\Windows\\system32\\netsh int ip reset; shutdown /s /t 5}\""
  shutdown_timeout = "60m"
}

// Build block specifies what Packer does with the source images
build {

  // Name of the build
  name = "ws2022"

  // Source to be used for the build
  sources = ["source.vsphere-iso.ws2022"]

  // Provisioners are used to install and configure the image after it is created
  provisioner "windows-restart" {
    pause_before    = "30s"
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    scripts = ["scripts/dot-net-4.8-install.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    scripts = ["scripts/install-chocolatey-1.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    scripts = ["scripts/install-chocolatey-2.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    scripts = ["scripts/cleanup.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

}
