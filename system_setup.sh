# Install my favourite programs on a new and shiny system
set -euo pipefail

install_rootless_docker() {
	echo
	read -p "Install rootless docker? [y/N]:" OKGO
	OKGO=${OKGO:-N}
	if ! [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
	then
		echo "Not installing docker."
	else
		echo "Checking docker prerequisites..."
		command -v newuidmap >/dev/null 2>&1 && echo "uidmap is already installed." || { sudo apt install -y uidmap; }
		command -v dbus-user-session >/dev/null 2>&1 && echo "dbus-user-session is already installed." || { sudo apt install -y dbus-user-session; }

		echo "Disabling system-wide docker daemon..."
		sudo systemctl disable --now docker.service docker.socket

		echo "Removing any conflicting unofficial packages..."
		for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
		
		# Add Docker's official GPG key:
		sudo install -m 0755 -d /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
		sudo chmod a+r /etc/apt/keyrings/docker.gpg

		# Add the Docker repository to Apt sources:
		echo \
			"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
			"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		sudo apt-get update

		echo "Installing docker..."
		sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

		# Setup rootless docker
		dockerd-rootless-setuptool.sh install
	fi
}

install_terraform() {
	echo
	read -p "Install terraform? [y/N]:" OKGO
	OKGO=${OKGO:-N}
	if ! [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
	then
		echo "Not installing terraform."
	else
		wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
		echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
		sudo apt update && sudo apt install terraform
	fi
}

install_spacectl() {
	echo "I haven't implemented automated installation of spacectl yet."
	echo "Installation guide: https://github.com/spacelift-io/spacectl"
	echo "I have ended up grabbing the latest release from GitHub: https://github.com/spacelift-io/spacectl/releases"
	read -p "Hit [Enter] to continue": OK
}

install_if_not_exists() {
  command -v $1 >/dev/null 2>&1 && echo "$1 already exists."
  if [ $? -ne 0 ]; then
    read -p "Install $1? [y/N]: " confirm
    if [[ $confirm =~ ^[yY]|[yY][eE][sS]$ ]]; then
      $2
    else
      echo "Not installing $1."
    fi
  fi
}

install_bun() {
	curl -fsSL https://bun.sh/install | bash
}

install_gh() {
	command -v curl >/dev/null 2>&1 || (echo "The install function for gh depends on curl. You'll need to install curl first" && return 1)
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
}

read -p "Install command line tools? [Y/n]:" OKGO
OKGO=${OKGO:-Y}
if ! [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
then
	echo "Skipping the command line tools."
else 
	echo "Installing command line tools..."

	# Transfer data with URL syntax
	install_if_not_exists "curl" "sudo apt install curl"

	# Version control
	install_if_not_exists "git" "sudo apt install git"

	# Interactive processes viewer
	install_if_not_exists "htop" "sudo apt install htop"

	# Text editor
	install_if_not_exists "vim" "sudo apt install vim"

	# Terminal multiplexer
	install_if_not_exists "tmux" "sudo apt install tmux"

	# Indented directory trees
	install_if_not_exists "tree" "sudo apt install tree"

	# Silver searcher
	install_if_not_exists "ag" "sudo apt install silversearcher-ag"

	# JSON processor
	install_if_not_exists "jq" "sudo apt install jq"

	# YAML processor
	install_if_not_exists "yq" "sudo snap install yq"

	# Copy to clipboard from command line
	install_if_not_exists "xclip" "sudo apt install xclip"

	# Run apps in isolated, portable containers
	install_if_not_exists "docker" "install_rootless_docker"
	
	# Automate infrastructure provisioning and management using code
	install_if_not_exists "terraform" "install_terraform"

	# CI/CD for infrastructure as code
	install_if_not_exists "spacectl" "install_spacectl"

	# GitHub CLI
	install_if_not_exists "gh" "install_gh"

	# CLI for Google Cloud Platform products and services
	install_if_not_exists "gcloud" "sudo snap install google-cloud-cli --classic"
fi

echo
read -p "Install programming languages? [y/N]:" OKGO
OKGO=${OKGO:-N}
if ! [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
then
	echo "Skipping the programming languages."
else 
	echo "Installing programming languages..."

	# Node version manager
	[ -d "$NVM_DIR/.git" ] && echo "nvm already exists." || {
		read -p "Install nvm? [Y/n]:" OKGO
		OKGO=${OKGO:-Y}
		if [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
		then
		 	echo "Installing nvm."
			curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash;
			source ~/.bash_profile;
			nvm install stable;
			nvm use stable;
		fi
	}

	# Golang
	check_go_version_and_install() {
		# Query latest stable release (array is newest->oldest)
		local go_releases_json="$(curl -fsSL 'https://go.dev/dl/?mode=json')"

		# Grab the first stable release (e.g., "go1.25.0")
		local latest_go_version="$(jq -r '[.[] | select(.stable==true)][0].version' <<< "$go_releases_json")"

		# Detect currently installed Go version (if any)
		local installed_go_version="none"
		if command -v go >/dev/null 2>&1; then
			# Extract just the "go1.x.x" part
			installed_go_version="$(go version | awk '{print $3}')"
		fi

		[[ "$installed_go_version" == "$latest_go_version" ]] && echo "go is already at the latest version ($latest_go_version)." || {
			echo "Installed Go version: $installed_go_version"
			echo "Latest Go version:    $latest_go_version"

			read -p "Install $latest_go_version? [Y/n]:" OKGO
			OKGO=${OKGO:-Y}
			if [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
			then
				echo "Installing go."

				if [[ -z "$latest_go_version" || "$latest_go_version" == "null" ]]; then
					echo "Could not determine latest Go version."
					read -p "Manually specify a release (e.g. 'go1.25.0'):" wanted_go_version
				fi

				GO_PLATFORM=linux-amd64
				GO_FILENAME="${wanted_go_version:-$latest_go_version}.${GO_PLATFORM}.tar.gz"
				GO_DOWNLOAD_LINK="https://go.dev/dl/${GO_FILENAME}"

    			echo "Downloading Go from $GO_DOWNLOAD_LINK"
				curl -O -L $GO_DOWNLOAD_LINK
				sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf ${GO_FILENAME}
				[[ -d /usr/local/go/bin ]] && export PATH=$PATH:/usr/local/go/bin # Also in .bash_profile
				rm $GO_FILENAME
				go version
				go env -w GOBIN=~/bin
			fi
		}
	}
	check_go_version_and_install

	command -v bun >/dev/null 2>&1 && echo "bun already exists." || {
		read -p "Install bun? [Y/n]:" OKGO
		OKGO=${OKGO:-Y}
		if [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
		then
			install_bun
		fi
	}
fi

echo
read -p "Install many visual programs? [y/N]:" OKGO
OKGO=${OKGO:-N}
if ! [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
then
	echo "Skipping the visual programs."
else
	echo "Installing visual programs..."
	# Browsers
	install_if_not_exists "chromium" "sudo snap install chromium"
	install_if_not_exists "brave" "sudo snap install brave"

	# Editors
	install_if_not_exists "code" "sudo snap install --classic code"

	# Communication
	install_if_not_exists "slack" "sudo snap install slack"

	# Music player
	install_if_not_exists "spotify" "sudo snap install spotify"

	# Gnome things
	install_if_not_exists "gnome-session" "sudo apt install gnome-session"
	install_if_not_exists "gnome-tweaks" "sudo apt install gnome-tweaks"
	install_if_not_exists "extension-manager" "sudo apt install gnome-shell-extension-manager"

	# Selfies
	install_if_not_exists "cheese" "sudo snap install cheese --candidate"
fi

# Enable dark mode
echo "Enabling dark mode..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-purple-dark'
