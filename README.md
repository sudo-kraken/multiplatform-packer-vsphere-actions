<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&pause=1000&width=435&lines=Multi-Os+Packer+Modules+for+GitHub+Actions" alt="Typing SVG"/>
</p>

<p align="center">
  <img src="https://media.giphy.com/media/hvRJCLFzcasrR4ia7z/giphy.gif" width="50" alt="Repo Languages and Tools"/>
</p>

<h1 align="center">Repo Languages and Tools</h1>
 
<p align="center">
  <a href="https://www.packer.io/"><img src="https://img.shields.io/badge/Packer-%23E7EEF0.svg?style=flat&logo=packer&logoColor=%2302A8EF" alt="Packer" /></a>
  <a href="https://www.terraform.io/"><img src="https://img.shields.io/badge/-Terraform-623CE4?style=flat&logo=terraform&logoColor=white" alt="Terraform" /></a>
  <a href="https://www.ansible.com/"><img src="https://img.shields.io/badge/Ansible-%231A1918.svg?style=flat&logo=ansible&logoColor=white" alt="Ansible" /></a>
  <a href="https://git-scm.com/"><img src="https://img.shields.io/badge/-Git-F05032?style=flat&logo=git&logoColor=white" alt="Git" /></a>
  <a href="https://github.com/features/actions"><img src="https://img.shields.io/badge/-GitHub_Actions-2088FF?style=flat&logo=github-actions&logoColor=white" alt="GitHub Actions" /></a>
  <a href="https://www.linux.org/"><img src="https://img.shields.io/badge/-Linux-FCC624?style=flat&logo=linux&logoColor=black" alt="Linux" /></a>
  <a href="https://www.docker.com/"><img src="https://img.shields.io/badge/-Docker-2496ED?style=flat&logo=docker&logoColor=white" alt="Docker" /></a>
  <a href="https://www.gnu.org/software/bash/"><img src="https://img.shields.io/badge/-Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white" alt="Bash" /></a>
  <a href="https://docs.microsoft.com/en-us/powershell/"><img src="https://img.shields.io/badge/-PowerShell-5391FE?style=flat&logo=powershell&logoColor=white" alt="PowerShell" /></a>
  <a href="https://www.python.org/"><img src="https://img.shields.io/badge/-Python-3776AB?style=flat&logo=python&logoColor=white" alt="Python" /></a>
</p>

<p align="center">
<br>
<a href="https://www.buymeacoffee.com/jharrison94"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png"></a></p>

## Overview
This repository forms the first part of a comprehensive infrastructure-as-code (IAC) pipeline. It focuses on automating the creation of image templates for various operating systems, including Ubuntu, Rocky Linux, and Windows Server versions. These templates are essential for deploying virtual machines within a vSphere environment.

> [!NOTE]  
> Each template type in this repo has its own README detailing usage instructions. All deployments are executed through GitHub Actions, utilising a self-hosted GitHub runner to ensure seamless automation.

## Integration with Terraform Deployment Repository
The templates generated here are designed to be directly utilised by my second repository, which leverages Terraform for the deployment of these VMs. This integration provides a streamlined process from template creation to VM deployment.
[Terraform Repository for Deployment](https://github.com/sudo-kraken/multiplatform-terraform-module-actions)

After creating templates with this repository, head over to my Terraform Deployment Repository to deploy your virtual machines and other resources. This second part of my IAC pipeline allows you to deploy across multiple providers, including AWS and VMware, using the templates generated here.
Why This Integration Matters
  - Efficiency: Automate the entire process from OS image creation to VM deployment.
  - Consistency: Ensure standardized configurations across your deployments.
  - Scalability: Easily scale your infrastructure with templated, automated deployments.

## Usage
To begin using this repository:
  -  Familiarise yourself with each template's README.
  -  Set up your environment for GitHub Actions.
  -  Follow the detailed instructions for creating templates.
  -  Once templates are created, use them in conjunction with my Terraform repository for full deployment cycles.
