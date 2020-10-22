# Install my favourite programs on a new and shiny system

echo "Installing command line tools..."

# Transfer data with URL syntax
command -v curl >/dev/null 2>&1 && echo "curl has already been installed on this system." || { sudo apt install curl; }

# Version control
command -v git >/dev/null 2>&1 && echo "git has already been installed on this system." || { sudo apt install git; }

# Interactive processes viewer
command -v htop >/dev/null 2>&1 && echo "htop has already been installed on this system." || { sudo apt install htop; }

# Text editor
command -v vim >/dev/null 2>&1 && echo "vim has already been installed on this system." || { sudo apt install vim; }

# Terminal multiplexer
command -v tmux >/dev/null 2>&1 && echo "tmux has already been installed on this system." || { sudo apt install tmux; }

# Silver searcher
command -v ag >/dev/null 2>&1 && echo "ag has already been installed on this system." || { sudo apt install silversearcher-ag; }

# Copy to clipboard from command line
command -v xclip >/dev/null 2>&1 && echo "xclip has already been installed on this system." || { sudo apt install xclip; }

# Node version manager
[ -d "$NVM_DIR/.git" ] && echo "nvm has already been installed on this system." || { curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh; source ~/.bash_profile; nvm install stable; nvm use stable; }

echo ""
echo "Would you like to install visual stuffs? This includes heavy things like gnome, spotify, chromium and atom."
read -p "Continue? [Y/n]:" OKGO
OKGO=${OKGO:-Y}
if [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
then
	echo "You were warned. Commencing shininess..."
else
	exit
fi

# Browser
command -v chromium >/dev/null 2>&1 && echo "chromium has already been installed on this system." || { sudo snap install chromium; }

# Integrated development environment (IDE)
command -v atom >/dev/null 2>&1 && echo "atom has already been installed on this system." || { wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add - && sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list' && sudo apt update && sudo apt install atom && apm install sync-settings; }

# Music player
command -v spotify >/dev/null 2>&1 && echo "spotify has already been installed on this system." || { sudo snap install spotify; }

# Desktop manager
command -v gnome-session >/dev/null 2>&1 && echo "gnome-session has already been installed on this system." || { sudo apt install gnome-session; }

# Gnome Tweak Tools
command -v gnome-tweaks >/dev/null 2>&1 && echo "gnome-tweaks has already been installed on this system." || { sudo apt install gnome-tweaks; }

# Enable dark mode
echo "Dark mode! Enabling the Adwaita-dark theme"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
