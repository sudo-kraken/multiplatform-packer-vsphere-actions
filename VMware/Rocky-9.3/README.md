# Packer vSphere Rocky 9.3 CI Template Generator

## Overview

This Packer Deployment simplifies the creation of a Rocky Linux 9.3 virtual machine template in a vSphere environment. It automates various base setup tasks, including resource provisioning, network configuration, and software installation. Tailored for Rocky Linux 9.3.

## Prerequisites
- GitHub Secrets have been set for the following values
   - `VSPHERE_PASSWORD` the password for your vCenter user
   - `SSH_PASSWORD` the password to use to SSH into the machine (set in ks.cfg default is `Pa55w0rd!`)
- GitHub self-hosted runner, provisioned with access to the vCenter appliance (in this case tagged with **devops**)
-  Edit `http/ks.cfg` 
    -  Encrypted passwords on lines **20** for **root** and **28** for **admin** (e.g. `openssl passwd -6 passwordhere`)
    -  Edit line **17** to add a static boot ip that has internet access replace all **3** instances of `x.x.x.x` with valid information for gateway, ip and subnet mask
- Edit `scripts/cleanup.sh` 
    - Lines **13** and **14** with a SSH public key if you want to use keys for access 
- Edit `rocky.pkr.hcl` 
    - Line **270** needs a static IP address for packer the runner to initially connect to it, replace only this portion of the string `ip=x.x.x.x::x.x.x.x:x.x.x.x:` with `ip=ipaddress::gateway::netmask:` i.e. `ip=192.168.1.10::192.168.1.1:255.255.255.0:` 
- Finally edit `variables.pkrvars.hcl` variable values for your environment specifically:
    - `vcenter_username`    
    - `vcenter_server`  
    - `vcenter_datacenter`
    - `vcenter_host`  
    - `vcenter_datastore`  
    - `vcenter_network`  
    - `vcenter_folder`  
    - `vcenter_cluster`  
    - `iso_path`  

> [!NOTE]  
> The IP address you use in `ks.cfg` and `rocky.pkr.hcl` can be the same, it is only required to have internet access to setup and provision all of the packages needed, once this is done it will remove the IP from the machine ready for when terraform picks up the packer template later.

## Module Details

In detail, the module performs the following tasks:

- Retrieves essential information about the vSphere environment using data sources.
- Sets up ISO details like checksum and paths.
- Provisions a Rocky Linux 9.3 virtual machine with specified configurations.
- Installs multiple software packages, updates, handles local ansible playbook execution and other configurations.
- Cleans up the VM post-installation via scripts.
- Provides flexibility for customisations based on your infrastructure requirements.

## Usage

### Execute Packer vSphere Rocky 9.3 CI Template Generator

To use this deployment, follow these steps:

1. Trigger the `Packer vSphere Rocky 9.3 CI Template Generator` workflow manually from the "Actions" tab in your GitHub repository.

2. The workflow will execute the following steps:

   - **Checkout**: This step checks out the repository to the GitHub Actions runner.
   - **Packer Setup**: Sets up the Packer CLI on the runner.
   - **Packer Init**: Initialises your Packer working directory.
   - **Packer Validate**: Ensures that the HCL and Var files are valid and can be executed.
   - **Packer Build**: Applies the changes needed to achieve the desired template output using Packer.

## License

This Packer deployment is open-source and available under the MIT License.

## Authors

[Joe Harrison]

## Support

For questions, issues, or contributions, please open an issue in this repository.

## Disclaimer

This deployment is intended to simplify the provisioning of a Rocky Linux 9.3 VM template in a vSphere environment, to be used in conjunction with Terraform. It should be used with care, considering the resources it creates and their associated costs. Review and adjust the configurations to match your specific requirements and security considerations.
