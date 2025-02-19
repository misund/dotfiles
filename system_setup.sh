# Install my favourite programs on a new and shiny system

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
	command -v curl >/dev/null 2>&1 && echo "curl already exists." || { sudo apt install curl; }

	# Version control
	command -v git >/dev/null 2>&1 && echo "git already exists." || { sudo apt install git; }

	# Interactive processes viewer
	command -v htop >/dev/null 2>&1 && echo "htop already exists." || { sudo apt install htop; }

	# Text editor
	command -v vim >/dev/null 2>&1 && echo "vim already exists." || { sudo apt install vim; }

	# Terminal multiplexer
	command -v tmux >/dev/null 2>&1 && echo "tmux already exists." || { sudo apt install tmux; }

	# Indented directory trees
	command -v tree >/dev/null 2>&1 && echo "tree already exists." || { sudo apt install tree; }

	# Silver searcher
	command -v ag >/dev/null 2>&1 && echo "ag already exists." || { sudo apt install silversearcher-ag; }

	# Copy to clipboard from command line
	command -v xclip >/dev/null 2>&1 && echo "xclip already exists." || { sudo apt install xclip; }

	# Run apps in isolated, portable containers
	command -v docker >/dev/null 2>&1 && echo "docker already exists." || install_rootless_docker
	
	# Automate infrastructure provisioning and management using code
	command -v terraform >/dev/null 2>&1 && echo "terraform already exists." || install_terraform

	# CI/CD for infrastructure as code
	command -v spacectl >/dev/null 2>&1 && echo "spacectl already exists." || install_spacectl

	# GitHub CLI
	command -v gh >/dev/null 2>&1 && echo "gh already exists." || install_gh

	# CLI for Google Cloud Platform products and services
	command -v gcloud >/dev/null 2>&1 && echo "gcloud already exists." || { sudo snap install google-cloud-cli --classic; }
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
	command -v go >/dev/null 2>&1 && echo "go already exists." || {
		read -p "Install go? [Y/n]:" OKGO
		OKGO=${OKGO:-Y}
		if [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
		then
			echo "Installing go."
			GO_VERSION=1.24.0
			GO_PLATFORM=linux-amd64
			GO_FILENAME="go${GO_VERSION}.${GO_PLATFORM}.tar.gz"
			GO_DOWNLOAD_LINK="https://go.dev/dl/${GO_FILENAME}"

			curl -O -L $GO_DOWNLOAD_LINK
			sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf ${GO_FILENAME}
			[[ -d /usr/local/go/bin ]] && export PATH=$PATH:/usr/local/go/bin # Also in .bash_profile
			rm $GO_FILENAME
			go version
			go env -w GOBIN=~/bin
		fi
	}

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
	command -v chromium >/dev/null 2>&1 && echo "chromium already exists." || { sudo snap install chromium; }
	command -v brave >/dev/null 2>&1 && echo "brave already exists." || { sudo snap install brave; }

	# Editors
	command -v code >/dev/null 2>&1 && echo "code already exists." || { sudo snap install --classic code; }

	# Communication
	command -v slack >/dev/null 2>&1 && echo "slack already exists." || { sudo snap install slack; }

	# Music player
	command -v spotify >/dev/null 2>&1 && echo "spotify already exists." || { sudo snap install spotify; }

	# Gnome things
	command -v gnome-session >/dev/null 2>&1 && echo "gnome-session already exists." || { sudo apt install gnome-session; }
	command -v gnome-tweaks >/dev/null 2>&1 && echo "gnome-tweaks already exists." || { sudo apt install gnome-tweaks; }
	command -v extension-manager >/dev/null 2>&1 && echo "extension-manager already exists." || { sudo apt install gnome-shell-extension-manager; }

	# Selfies
	command -v cheese >/dev/null 2>&1 && echo "cheese already exists." || { sudo snap install cheese --candidate; }
fi

# Enable dark mode
echo "Enabling dark mode..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-purple-dark'
