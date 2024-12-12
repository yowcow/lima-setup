APT_SOURCES := $(foreach file, hashicorp.list, $(addprefix /etc/apt/sources.list.d/, $(file)))

.PHONY: all
all: apt-setup
	$(MAKE) $(APT_SOURCES)

.PHONY: apt-setup
apt-setup:
	apt-get update
	apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg

#/etc/apt/sources.list.d/google-cloud-sdk.list: /usr/share/keyrings/cloud.google.gpg
#    echo "deb [signed-by=$<] https://packages.cloud.google.com/apt cloud-sdk main" > $@
#
#/usr/share/keyrings/cloud.google.gpg:
#	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
#		| gpg --dearmor -o $@

/etc/apt/sources.list.d/hashicorp.list: LSB_RELEASE = jammy
/etc/apt/sources.list.d/hashicorp.list: ARCH = $(shell dpkg --print-architecture)
/etc/apt/sources.list.d/hashicorp.list: /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(ARCH) signed-by=$<] https://apt.releases.hashicorp.com $(LSB_RELEASE) main" > $@

/usr/share/keyrings/hashicorp-archive-keyring.gpg:
	curl https://apt.releases.hashicorp.com/gpg \
		| gpg --dearmor -o $@

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
		cmake \
		curl \
		docker-buildx \
		docker-compose-v2 \
		docker.io \
		erlang \
		gettext \
		git \
		golang \
		gpg \
		htop \
		libbz2-dev \
		libevent-dev \
		libffi-dev \
		liblz-dev \
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
		pass \
		perl \
		php-cli \
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
	#apt-get install -yq google-cloud-cli
	apt-get install -yq terraform terraform-ls

.PHONY: aws-install
aws-install: /usr/local/bin/aws

/usr/local/bin/aws:
	$(MAKE) aws-install-cliv2
	$(MAKE) aws-install-session-manager-plugin

.PHONY: aws-install-cliv2
aws-install-cliv2: /tmp/awscliv2
	if [ "$$(command -v aws)" != "" ]; then \
		$</aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update; \
	else \
		$</aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli; \
	fi

/tmp/awscliv2: /tmp/awscliv2.zip
	unzip $< -d $@

aws-install-session-manager-plugin: /tmp/session-manager-plugin.deb
	dpkg -i $<

.INTERMEDIATE: /tmp/awscliv2.zip /tmp/session-manager-plugin.deb
/tmp/awscliv2.zip: ARCH = $(shell uname -i)
/tmp/awscliv2.zip:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-$(ARCH).zip" -o $@

/tmp/session-manager-plugin.deb: ARCH = $(shell dpkg --print-architecture)
/tmp/session-manager-plugin.deb:
	curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_$(ARCH)/session-manager-plugin.deb" -o $@

.PHONY: clean
clean:
	rm -rf /tmp/awscliv2 /tmp/awscliv2.zip
