# Packer vSphere Windows Server 2016 CI Template Generator

## Overview

This Packer Deployment simplifies the creation of a Windows Server 2016 (WS16) virtual machine template in a vSphere environment. It automates various base setup tasks, including resource provisioning, network configuration, and software installation, and sysprep etc. Tailored for WS16.

## Prerequisites
- GitHub Secrets have been set for the following values
   - `VSPHERE_PASSWORD` the password for your vCenter user
- GitHub self-hosted runner, provisioned with access to the vCenter appliance (in this case tagged with **devops**)
-  Edit `configs/autounattend.xml` 
    -  Licence key on line **67** (e.g. `11111-22222-33333-44444-55555`)
    -  Edit your Org name on line **72**
    -  OPTIONAL: You can edit the password on lines **108** and **187** the default is `Passw0rd.`
- Edit `scripts/set-static-ip.ps1` 
    - Line **8** set the IP address you will be assigning to the build process for internet access
    - Line **15** set the gateway IP address for the previous IP on line **8** and set the prefix length in CIDR notation i.e. `255.255.255.0` would be `24`
- Edit `windows2016.pkr.hcl` 
    - Line **168** update this line to have the correct Datastore and Path to the Windows ISO
- Finally edit `variables.pkrvars.hcl` variable values for your environment specifically:
    - `vcenter_server`  
    - `vcenter_user`
    - `vcenter_datacenter`
    - `vcenter_datastore`  
    - `esx_host`
    - `vcenter_cluster`  
    - `vcenter_folder`  
    - `vm_network`  
    - `iso_checksum` this is the sha256 hash of the iso file  

> [!NOTE]  
> If you change the password used be sure to update the unattend file as well as the password used in the variables file

## Module Details

In detail, the module performs the following tasks:

- Retrieves essential information about the vSphere environment using data sources.
- Sets up ISO details like checksum and paths.
- Provisions a WS16 virtual machine with specified configurations.
- Installs .NET 4.8, Chocolatey, OpenSSH, PowerShell 7 and other configurations.
- Cleans up the VM post-installation via scripts.
- Provides flexibility for customisations based on your infrastructure requirements.

## Usage

### Packer vSphere Windows Server 2016 CI Template Generator

To use this deployment, follow these steps:

1. Trigger the `Packer vSphere Windows Server 2016 CI Template Generator` workflow manually from the "Actions" tab in your GitHub repository.

2. The workflow will execute the following steps:

   - **Checkout**: This step checks out the repository to the GitHub Actions runner.
   - **Packer Setup**: Sets up the Packer CLI on the runner.
   - **Packer Init**: Initialises your Packer working directory.
   - **Packer Validate**: Ensures that the HCL and Var files are valid and can be executed.
   - **Packer Build**: Applies the changes needed to achieve the desired template output using Packer.

## License

This Packer deployment is open-source and available under the GNU General Public License v3.0.

## Authors

[Joe Harrison]

## Support

For questions, issues, or contributions, please open an issue in this repository.

## Disclaimer

This deployment is intended to simplify the provisioning of WS16 VM templates in a vSphere environment, to be used in conjunction with Terraform. It should be used with care, considering the resources it creates and their associated costs. Review and adjust the configurations to match your specific requirements and security considerations.
