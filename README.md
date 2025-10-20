<div align="center">
<img src="docs/assets/logo.png" align="center" width="144px" height="144px"/>

### Multiplatform Packer vSphere Actions

_Packer templates with ready-to-run GitHub Actions for building Windows and Linux images on VMware vSphere._
</div>

<div align="center">

[![Packer](https://img.shields.io/badge/Packer-Required-%2302A8EF?logo=packer&logoColor=white&style=for-the-badge)](https://www.packer.io/)
[![Packer Version](https://img.shields.io/badge/Packer-1.10%2B-%2302A8EF?logo=packer&logoColor=white&style=for-the-badge)](https://www.packer.io/)

</div>

<div align="center">

[![OpenSSF Scorecard](https://img.shields.io/ossf-scorecard/github.com/sudo-kraken/multiplatform-packer-vsphere-actions?label=openssf%20scorecard&style=for-the-badge)](https://scorecard.dev/viewer/?uri=github.com/sudo-kraken/multiplatform-packer-vsphere-actions)

</div>

## Contents

- [Overview](#overview)
- [Architecture at a glance](#architecture-at-a-glance)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick start](#quick-start)
- [Repository structure](#repository-structure)
- [Templates included](#templates-included)
- [Integration with Terraform deployment repository](#integration-with-terraform-deployment-repository)
- [Workflows](#workflows)
- [Inputs and secrets](#inputs-and-secrets)
- [Troubleshooting](#troubleshooting)
- [Licence](#licence)
- [Security](#security)
- [Contributing](#contributing)
- [Support](#support)

## Overview

This repository forms the first part of an infrastructure as code pipeline. It automates the creation of vSphere VM templates for multiple operating systems. These templates are intended to be consumed by the companion Terraform repository for downstream deployments.

> [!NOTE]  
> Each template directory contains its own README with exact usage, variables and any prerequisites. All builds are executed via GitHub Actions using a self hosted runner.

## Architecture at a glance

- Packer templates for VMware vSphere
- GitHub Actions workflows to drive `packer init`, `packer validate` and `packer build`
- Self hosted GitHub runner recommended for access to vSphere networks
- Parameterised builds via workflow inputs and repository or organisation secrets

## Features

- Multi OS support including Ubuntu, Rocky Linux and Windows Server variants
- Opinionated build steps for vSphere images with custom post processors where applicable
- Consistent tagging and naming to simplify later selection by Terraform modules
- Modular layout per OS with per template READMEs

## Prerequisites

- VMware vSphere environment with credentials and permissions to build templates
- A self hosted GitHub runner with network access to vSphere
- ISO sources or content library entries as required by each template
- Repository or organisation secrets configured for vSphere credentials and template variables

## Quick start

1. Fork or clone this repository.
2. Review the README in the target template directory for OS specific guidance.
3. Configure required secrets in your repository or organisation.
4. From the Actions tab, choose the workflow for your template and run it with the required inputs.

## Repository structure

```
.
├── .github/                 # GitHub Actions workflows
├── templates/               # Packer templates grouped by OS
│   ├── ubuntu/
│   ├── rocky/
│   └── windows/
├── .devcontainer/           # Optional devcontainer setup
├── .vscode/                 # Editor settings
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── SECURITY.md
└── README.md
```

## Templates included

Typical images provided include:

- Ubuntu LTS releases
- Rocky Linux releases
- Windows Server releases

Refer to each template’s README for the exact versions, variables and build steps.

## Integration with Terraform deployment repository

The templates created here are used directly by the Terraform modules in the companion repository:

- [Multiplatform Terraform Module Actions](https://github.com/sudo-kraken/multiplatform-terraform-module-actions)

This integration lets you move from image creation to VM deployment with a consistent set of inputs.

> [!NOTE]  
> Build the required templates here first, then run the Terraform workflows to deploy VMs that consume those templates.

## Workflows

The workflows provided will:

1. Run `packer init` and `packer validate` for the selected template.
2. Execute `packer build` with inputs supplied through the workflow form.
3. Publish the resulting template to your vSphere environment.

## Inputs and secrets

Common secrets and inputs:

- **vSphere**
  - `VSPHERE_SERVER`
  - `VSPHERE_USER`
  - `VSPHERE_PASSWORD`
  - Datacentre, cluster, datastore and network names as inputs
- **Template specific**
  - ISO URLs or content library names
  - Guest customisation values such as admin credentials or SSH keys

Names and scopes vary by template. Always check the template’s README for authoritative details.

## Troubleshooting

- **Validation fails**  
  Ensure all required inputs are provided and the template specific variables match your environment.
- **Build cannot reach ISO or network**  
  Confirm the self hosted runner can access required networks and repositories.
- **Template not visible after build**  
  Verify permissions on the destination datastore or content library and confirm naming conventions.

## Licence

This project is licensed under the MIT Licence. See the [LICENCE](LICENCE) file for details.

## Security

If you discover a security issue, please review and follow the guidance in [SECURITY.md](SECURITY.md), or open a private security focused issue with minimal details and request a secure contact channel.

## Contributing

Feel free to open issues or submit pull requests if you have suggestions or improvements.  
See [CONTRIBUTING.md](CONTRIBUTING.md)

## Support

Open an [issue](/../../issues) with as much detail as possible, including the template you used, workflow inputs and any logs that help reproduce the problem.
