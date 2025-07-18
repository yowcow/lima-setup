APT_FILES = hashicorp.list github-cli.list
APT_SOURCES = $(foreach file,$(APT_FILES),$(addprefix /etc/apt/sources.list.d/, $(file) ))

LSB_RELEASE = jammy
ARCH = $(shell dpkg --print-architecture)

.PHONY: all
all: apt-setup
	$(MAKE) $(APT_SOURCES)

/etc/apt/sources.list.d/hashicorp.list: /usr/share/keyrings/hashicorp-archive-keyring.gpg
	echo "deb [arch=$(ARCH) signed-by=$<] https://apt.releases.hashicorp.com $(LSB_RELEASE) main" | tee $@

/usr/share/keyrings/hashicorp-archive-keyring.gpg:
	curl https://apt.releases.hashicorp.com/gpg \
		| gpg --dearmor --batch --yes -o $@

/etc/apt/sources.list.d/github-cli.list: /usr/share/keyrings/githubcli-archive-keyring.gpg
	echo "deb [arch=$(ARCH) signed-by=$<] https://cli.github.com/packages stable main" | tee $@

/usr/share/keyrings/githubcli-archive-keyring.gpg:
	curl -L https://cli.github.com/packages/githubcli-archive-keyring.gpg -o $@

.PHONY: apt-setup
apt-setup:
	apt-get update
	apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg

.PHONY: install
install:
	$(MAKE) apt-install
	$(MAKE) aws-install

.PHONY: apt-install
apt-install:
	apt-get update
	apt-get install -yq \
		apt-file \
		binfmt-support \
		bison \
		build-essential \
		carton \
		cmake \
		cpanminus \
		curl \
		docker-buildx \
		docker-compose-v2 \
		docker.io \
		erlang \
		fd-find \
		gettext \
		gh \
		git \
		golang \
		gpg \
		htop \
		libbz2-dev \
		libevent-dev \
		libffi-dev \
		liblzma-dev \
		libprotoc-dev \
		libsqlite3-dev \
		libssl-dev \
		libutf8proc-dev \
		libxml2-utils \
		luarocks \
		make \
		mariadb-client \
		ncal \
		neovim \
		netcat-openbsd \
		ninja-build \
		nsnake \
		pass \
		perl \
		perl-doc \
		php-cli \
		php-mbstring \
		php-xml \
		pinentry-tty \
		pipx \
		protobuf-compiler \
		qemu-system \
		rebar3 \
		ripgrep \
		rustup \
		socat \
		speedtest-cli \
		tmux \
		unzip \
		whois \
		zsh
	apt-get install -yq terraform terraform-ls

.PHONY: aws-install
aws-install: /tmp/session-manager-plugin.deb
	dpkg -i $<

.INTERMEDIATE: /tmp/session-manager-plugin.deb
/tmp/session-manager-plugin.deb:
	curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_$(ARCH)/session-manager-plugin.deb" -o $@
