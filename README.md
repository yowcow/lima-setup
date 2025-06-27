# lima-setup

This repository provides a `Makefile` to automate the setup of a development environment on a Debian-based Linux system, such as a [Lima](https://github.com/lima-vm/lima) VM. It installs a comprehensive set of development tools, CLIs, and programming languages.

## Prerequisites

- A Debian-based Linux environment (e.g., Ubuntu).
- `make`
- `curl`
- `sudo` privileges to install software and add APT repositories.

## Usage

The setup is split into two main steps: setting up APT repositories and installing packages.

1.  **Setup APT Repositories:**
    This step adds the necessary APT repositories for HashiCorp and GitHub CLI tools.

    ```bash
    sudo make all
    ```

2.  **Install Packages:**
    This step installs all the packages and tools defined in the `Makefile`.

    ```bash
    sudo make install
    ```

You can also run both steps together:

```bash
sudo make all install
```

## Makefile Targets

The `Makefile` provides several targets to manage the installation:

| Target        | Description                                                                                                                                                                 |
|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `all`         | Sets up APT sources for HashiCorp (`terraform`, `terraform-ls`) and GitHub CLI (`gh`).                                                                                        |
| `install`     | A meta-target that runs `apt-install` and `aws-install`.                                                                                                                    |
| `apt-install` | Installs a wide range of packages from the APT repositories. Key packages include: `git`, `golang`, `docker.io`, `neovim`, `terraform`, `rustup`, `gh`, `perl`, `php-cli`, and more. |
| `aws-install` | Installs the AWS CLI v2 and the AWS Session Manager Plugin.                                                                                                                 |
| `clean`       | Removes temporary files downloaded during the installation process.                                                                                                         |
| `help`        | Shows a help message with the main targets.                                                                                                                                 |

## Customization

You can customize the list of packages to be installed by editing the `Makefile`. The main list of packages is in the `apt-install` target.
