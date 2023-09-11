# Install my favourite programs on a new and shiny system

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

	# Silver searcher
	command -v ag >/dev/null 2>&1 && echo "ag already exists." || { sudo apt install silversearcher-ag; }

	# Copy to clipboard from command line
	command -v xclip >/dev/null 2>&1 && echo "xclip already exists." || { sudo apt install xclip; }
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
			GO_VERSION=1.19.1
			GO_PLATFORM=linux-amd64
			GO_FILENAME="go${GO_VERSION}.${GO_PLATFORM}.tar.gz"
			GO_DOWNLOAD_LINK="https://go.dev/dl/${GO_FILENAME}"

			curl -O -L $GO_DOWNLOAD_LINK
			sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.1.linux-amd64.tar.gz
			[[ -d /usr/local/go/bin ]] && export PATH=$PATH:/usr/local/go/bin # Also in .bash_profile
			rm $GO_FILENAME
			go version
			go env -w GOBIN=~/bin
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

# Enable dark mode
echo "Enabling dark mode..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-purple-dark'
