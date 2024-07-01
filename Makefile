APT_SOURCES := $(foreach file, google-cloud-sdk.list hashicorp.list, $(addprefix /etc/apt/sources.list.d/, $(file)))

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

/etc/apt/sources.list.d/google-cloud-sdk.list: /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=$<] https://packages.cloud.google.com/apt cloud-sdk main" > $@

/usr/share/keyrings/cloud.google.gpg:
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
		| gpg --dearmor -o $@

/etc/apt/sources.list.d/hashicorp.list: LSB_RELEASE = jammy
/etc/apt/sources.list.d/hashicorp.list: /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$$(dpkg --print-architecture) signed-by=$<] https://apt.releases.hashicorp.com $(LSB_RELEASE) main" > $@

/usr/share/keyrings/hashicorp-archive-keyring.gpg:
	curl https://apt.releases.hashicorp.com/gpg \
		| gpg --dearmor -o $@

.PHONY: install
install: apt-install
	$(MAKE) /usr/local/bin/aws

.PHONY: apt-install
apt-install:
	apt-get update
	apt-get install -yq \
		apt-file \
		build-essential \
		cmake \
		docker-buildx \
		docker-compose-v2 \
		docker.io \
		erlang \
		git \
		golang \
		gpg \
		htop \
		libssl-dev \
		libxml2-utils \
		luarocks \
		make \
		mariadb-client \
		ncal \
		neovim \
		netcat-openbsd \
		pass \
		perl \
		php-cli \
		pinentry-tty \
		pipx \
		rebar3 \
		ripgrep \
		rustup \
		socat \
		speedtest-cli \
		tmux \
		whois \
		zsh
	apt-get install -yq google-cloud-cli
	apt-get install -yq terraform terraform-ls

/usr/local/bin/aws: /tmp/awscliv2
	if [ "$$(command -v aws)" != "" ]; then \
		$</aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update; \
	else \
		$</aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli; \
	fi

/tmp/awscliv2: /tmp/awscliv2.zip
	unzip $< -d $@

/tmp/awscliv2.zip: ARCH = $(shell uname -i)
/tmp/awscliv2.zip:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-$(ARCH).zip" -o $@

.PHONY: clean
clean:
	rm -rf /tmp/awscliv2 /tmp/awscliv2.zip
