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

Run the following as root. This sets up APT sources and installs all packages in one shot:

```bash
sudo make install
```

To keep packages up to date on an existing VM:

```bash
sudo make update
```

### Phase 2 — User dotfiles setup

After the system setup is complete, set up your personal environment as a regular user:

```bash
git clone --recurse-submodules https://github.com/yowcow/dotfiles.git ~/dotfiles
make -C ~/dotfiles install
```

## Makefile Targets

The `Makefile` provides several targets to manage the installation:

| Target         | Description                                                                                                                                                                |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `install`      | **First-time setup.** Sets up APT sources, then runs `apt-install`, `snap-install`, and `aws-install`.                                                                     |
| `update`       | **Ongoing updates.** Upgrades APT packages, refreshes snaps, and reinstalls the latest Session Manager Plugin.                                                             |
| `all`          | Sets up APT sources for HashiCorp (`terraform`, `terraform-ls`) and GitHub CLI (`gh`). Called automatically by `install`.                                                  |
| `apt-install`  | Installs APT packages: `git`, `golang`, `docker.io`, `neovim`, `terraform`, `rustup`, `gh`, `perl`, `php-cli`, and more.                                                  |
| `apt-upgrade`  | Runs `apt-get upgrade` to upgrade all installed APT packages.                                                                                                              |
| `snap-install` | Installs snap packages (`aws-cli`, `google-cloud-sdk`). Idempotent — runs `snap refresh` if already installed.                                                             |
| `snap-refresh` | Refreshes all installed snap packages.                                                                                                                                     |
| `aws-install`  | Downloads and installs the latest AWS Session Manager Plugin.                                                                                                              |
| `clean`        | Removes APT source files and keyrings added by `all`.                                                                                                                      |
| `help`         | Shows a help message with all available targets.                                                                                                                           |

## Customization

You can customize the list of packages to be installed by editing the `Makefile`. The main list of packages is in the `apt-install` target.
