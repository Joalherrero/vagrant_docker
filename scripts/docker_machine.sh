#!/bin/bash

whoami

cd /vagrant/deploy/vagrant/scripts/

ensure_os_packages_exists() (
	declare -a pkgs=()
	for p in "$@"; do
		if ! command_exists "$p"; then
			pkgs+=("$p")
		fi
	done

	if ((${#pkgs[@]} == 0)); then
		return
	fi

	sudo apt-get update
	sudo apt-get install -y "${pkgs[@]}"
)

ensure_docker_exists() (
	if command_exists docker; then
		return
	fi

	# steps from https://docs.docker.com/engine/install/ubuntu/

	ensure_os_packages_exists \
		apt-transport-https \
		ca-certificates \
		gnupg-agent \
		software-properties-common \
		;

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
		sudo apt-key add -

	local repo
	repo=$(
		printf "deb [arch=amd64] https://download.docker.com/linux/ubuntu %s stable" \
			"$(lsb_release -cs)"
	)
	sudo add-apt-repository "$repo"

	ensure_os_packages_exists \
		containerd.io \
		docker-ce \
		docker-ce-cli \
		;
)

ensure_docker-compose_exists() (

	# from https://docs.docker.com/compose/install/
	sudo curl -fsSL \
		"https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" \
		-o /usr/local/bin/docker-compose

	sudo chmod +x /usr/local/bin/docker-compose
)



configure_vagrant_user() (
	sudo usermod -aG docker vagrant

)

main() (
	export DEBIAN_FRONTEND=noninteractive

	ensure_os_packages_exists curl jq
	ensure_docker_exists
	ensure_docker-compose_exists
	configure_vagrant_user

	echo $(pwd)

	

)

main