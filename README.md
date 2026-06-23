# lima-setup

This repository provides a `Makefile` to automate the setup of a development environment on a Debian-based Linux system, such as a [Lima](https://github.com/lima-vm/lima) VM. It installs a comprehensive set of development tools, CLIs, and programming languages.

## Prerequisites

- A Debian-based Linux environment (e.g., Ubuntu).
- `make`
- `curl`
- `sudo` privileges to install software and add APT repositories.

## Usage

A fresh Lima VM setup consists of two phases: system-level setup (this repo, run as root) followed by user-level dotfiles setup.

### Phase 1 — System setup (this repo)

1.  **Setup APT Repositories:**
    Adds the necessary APT repositories for HashiCorp and GitHub CLI tools.

    ```bash
    sudo make all
    ```

2.  **Install Packages:**
    Installs all packages and tools defined in the `Makefile`.

    ```bash
    sudo make install
    ```

    Or run both at once:

    ```bash
    sudo make all install
    ```

### Phase 2 — User dotfiles setup

After the system setup is complete, set up your personal environment as a regular user:

```bash
git clone --recurse-submodules https://github.com/yowcow/dotfiles.git ~/dotfiles
make -C ~/dotfiles install
```

## Makefile Targets

The `Makefile` provides several targets to manage the installation:

| Target        | Description                                                                                                                                                                 |
|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `all`         | Sets up APT sources for HashiCorp (`terraform`, `terraform-ls`) and GitHub CLI (`gh`).                                                                                        |
| `install`     | A meta-target that runs `apt-install`, `snap-install`, and `aws-install`.                                                                                                   |
| `apt-install` | Installs a wide range of packages from the APT repositories. Key packages include: `git`, `golang`, `docker.io`, `neovim`, `terraform`, `rustup`, `gh`, `perl`, `php-cli`, and more. |
| `aws-install` | Installs the AWS CLI v2 and the AWS Session Manager Plugin.                                                                                                                 |
| `clean`       | Removes APT source files and keyrings added by `all`.                                                                                                                       |
| `help`        | Shows a help message with all available targets.                                                                                                                            |

## Customization

You can customize the list of packages to be installed by editing the `Makefile`. The main list of packages is in the `apt-install` target.
