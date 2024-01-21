# Packer vSphere Ubuntu 22.04 CI Template Generator

## Overview

This Packer Deployment simplifies the creation of a Ubuntu 22.04 virtual machine template in a vSphere environment. It automates various base setup tasks, including resource provisioning, network configuration, and software installation. Tailored for Ubuntu 22.04.

## Prerequisites
- GitHub Secrets have been set for the following values
   - `VSPHERE_PASSWORD` the password for your vCenter user
   - `SSH_PASSWORD` the password to use to SSH into the machine (set in `http/user-data`)
- GitHub self-hosted runner, provisioned with access to the vCenter appliance (in this case tagged with **devops**)
-  Edit `http/user-data` 
    -  Edit line **16** and **17** to add a static boot ip that has internet access replace
    -  Encrypted password on line **28** for **administrator** (e.g. `mkpasswd -m sha-512 --rounds=4096 passwordhere`)
    -  Edit Line **33** with an SSH public key if you want to use SSH keys for access
- Finally edit `variables.pkrvars.hcl` variable values for your environment specifically:
    - `vcenter_username`    
    - `vcenter_server`  
    - `vcenter_datacenter`
    - `vcenter_host`  
    - `vcenter_datastore`  
    - `vcenter_network`  
    - `vcenter_folder`  
    - `vcenter_cluster`  

> [!NOTE]  
> The IP address you use in `http/meta-data` is only required to have internet access to setup and provision all of the packages needed, once this is done it will remove the IP from the machine ready for when terraform picks up the packer template later.

## Module Details

In detail, the module performs the following tasks:

- Retrieves essential information about the vSphere environment using data sources.
- Downloads and sets up the ISO with the details like checksum and paths.
- Provisions a Ubuntu 22.04 virtual machine with specified configurations.
- Installs multiple software packages, updates, handles local script execution and other configurations.
- Cleans up the VM post-installation via scripts.
- Provides flexibility for customisations based on your infrastructure requirements.

## Usage

### Execute Packer vSphere Ubuntu 22.04 CI Template Generator

To use this deployment, follow these steps:

1. Trigger the `Packer vSphere Ubuntu 22.04 CI Template Generator` workflow manually from the "Actions" tab in your GitHub repository.

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

This deployment is intended to simplify the provisioning of a Ubuntu 22.04 VM template in a vSphere environment, to be used in conjunction with Terraform. It should be used with care, considering the resources it creates and their associated costs. Review and adjust the configurations to match your specific requirements and security considerations.
