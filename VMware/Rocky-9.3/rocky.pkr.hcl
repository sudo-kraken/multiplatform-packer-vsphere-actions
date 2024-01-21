packer {
  required_version = ">= 1.10.0"
  required_plugins {
    vsphere = {
      version = ">= v1.2.1"
      source  = "github.com/hashicorp/vsphere"
    }
    ansible = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "vcenter_username" {
  type    = string
  description = "The username for authenticating to vCenter."
  default = ""
  sensitive = true
}

variable "vcenter_password" {
  type    = string
  description = "The plaintext password for authenticating to vCenter."
  default = ""
  sensitive = true
}

variable "ssh_username" {
  type    = string
  description = "The username to use to authenticate over SSH."
  default = ""
  sensitive = true
}

variable "ssh_password" {
  type    = string
  description = "The plaintext password to use to authenticate over SSH."
  default = ""
  sensitive = true
}

# vSphere Objects

variable "vcenter_insecure_connection" {
  type    = bool
  description = "If true, does not validate the vCenter server's TLS certificate."
  default = true
}

variable "vcenter_server" {
  type    = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  default = ""
}

variable "vcenter_datacenter" {
  type    = string
  description = "Required if there is more than one datacenter in vCenter."
  default = ""
}

variable "vcenter_host" {
  type = string
  description = "The ESXi host where target VM is created."
  default = ""
}

variable "vcenter_cluster" {
  type = string
  description = "The cluster where target VM is created."
  default = ""
}

variable "vcenter_datastore" {
  type    = string
  description = "Required for clusters, or if the target host has multiple datastores."
  default = ""
}

variable "vcenter_network" {
  type    = string
  description = "The network segment or port group name to which the primary virtual network adapter will be connected."
  default = ""
}

variable "vcenter_folder" {
  type    = string
  description = "The VM folder in which the VM template will be created."
  default = ""
}

# ISO Objects

variable "iso_path" {
  type    = string
  description = "The path on the source vSphere datastore for ISO images."
  default = ""
  }

variable "iso_file" {
  type = string
  description = "The file name of the guest operating system ISO image installation media."
  default = ""
}

variable "iso_checksum" {
  type    = string
  description = "The checksum of the ISO image."
  default = ""
}

variable "iso_checksum_type" {
  type    = string
  description = "The checksum type of the ISO image. Ex: sha256"
  default = ""
}

# HTTP Endpoint

variable "http_directory" {
  type    = string
  description = "Directory of config files(user-data, meta-data)."
  default = ""
}

# Virtual Machine Settings

variable "vm_name" {
  type    = string
  description = "The template vm name"
  default = ""
}

variable "vm_guest_os_type" {
  type    = string
  description = "The guest operating system type, also know as guestid."
  default = ""
}

variable "vm_version" {
  type = number
  description = "The VM virtual hardware version."
}

variable "vm_firmware" {
  type    = string
  description = "The virtual machine firmware. (e.g. 'bios' or 'efi')"
  default = ""
}

variable "vm_cdrom_type" {
  type    = string
  description = "The virtual machine CD-ROM type."
  default = ""
}

variable "vm_cpu_sockets" {
  type = number
  description = "The number of virtual CPUs sockets."
}

variable "vm_cpu_cores" {
  type = number
  description = "The number of virtual CPUs cores per socket."
}

variable "vm_mem_size" {
  type = number
  description = "The size for the virtual memory in MB."
}

variable "vm_disk_size" {
  type = number
  description = "The size for the virtual disk in MB."
}

variable "thin_provision" {
  type = bool
  description = "Thin or Thick provisioning of the disk"
}

variable "disk_eagerly_scrub" {
  type = bool
  description = "eagrly scrub zeros"
  default = false
}

variable "vm_disk_controller_type" {
  type = list(string)
  description = "The virtual disk controller types in sequence."
}

variable "vm_network_card" {
  type = string
  description = "The virtual network card type."
  default = ""
}

variable "vm_boot_wait" {
  type = string
  description = "The time to wait before boot. "
  default = ""
}

####################################################################

// Locals

locals {
  buildtime = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  vmsuffix = formatdate("YYMMDDhhmm", timestamp())
}

// Source

source "vsphere-iso" "rocky-server" {
  
  // VMware Variables
  vcenter_server = var.vcenter_server
  username = var.vcenter_username
  password = var.vcenter_password
  datacenter = var.vcenter_datacenter
  datastore = var.vcenter_datastore
  host = var.vcenter_host
  cluster = var.vcenter_cluster
  folder = var.vcenter_folder
  insecure_connection = var.vcenter_insecure_connection
  
  // VM Variables
  tools_upgrade_policy = true
  remove_cdrom = true
  convert_to_template = true
  guest_os_type = var.vm_guest_os_type
  vm_version = var.vm_version
  notes = "Built by Packer on ${local.buildtime}."
  vm_name = var.vm_name
  firmware = var.vm_firmware
  CPUs = var.vm_cpu_sockets
  cpu_cores = var.vm_cpu_cores
  CPU_hot_plug = true
  RAM = var.vm_mem_size
  RAM_hot_plug = true
  cdrom_type = var.vm_cdrom_type
  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size = var.vm_disk_size
    disk_controller_index = 0
    disk_thin_provisioned = var.thin_provision
    disk_eagerly_scrub = var.disk_eagerly_scrub
  }
  network_adapters {
    network = var.vcenter_network
    network_card = var.vm_network_card
  }
  
  // Iso Variables
  iso_paths = ["${var.iso_path}"]
  iso_checksum = "${var.iso_checksum_type}:${var.iso_checksum}"
  
  // HTTP Directory and Boot Variables
  http_directory = var.http_directory
  boot_order = "disk,cdrom"
  boot_wait = var.vm_boot_wait
  cd_files = [
        "./${var.http_directory}/ks.cfg"
  ]
  cd_label = "cidata"
  boot_command = [
    "e<down><down><end><bs><bs><bs><bs><bs>inst.text ip=x.x.x.x::x.x.x.x:x.x.x.x:hostname:ens192:none nameserver=1.1.1.1 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<leftCtrlOn>x<leftCtrlOff>"
  ]

  ip_wait_timeout = "20m"
  
  // SSH Values
  ssh_password = var.ssh_password
  ssh_username = var.ssh_username
  ssh_port = 22
  ssh_timeout = "30m"
  ssh_handshake_attempts = "100"
  
  // Shutdown Commands
  shutdown_command = "echo '${var.ssh_password}' | sudo -S sh -c '(sleep 10 && nmcli con delete ens192) & shutdown -h now'"
  shutdown_timeout = "5m"

}

// Build

build {
  // Source
  sources = [
    "source.vsphere-iso.rocky-server"
  ]
  
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    inline = [
      "dnf -y update",
      "dnf -y install python3",
      "dnf -y install python3-pip",
      "pip3 install ansible"
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "scripts/ansible.yml"
  }

  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    scripts         = ["scripts/cleanup.sh"]
  }
}
