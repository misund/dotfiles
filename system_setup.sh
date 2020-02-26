# Install my favourite programs on a new and shiny system

# Text editor
command -v git >/dev/null 2>&1 || { sudo apt install git; }

# Version control
command -v vim >/dev/null 2>&1 || { sudo apt install vim; }

# Terminal multiplexer
command -v tmux >/dev/null 2>&1 || { sudo apt install tmux; }

# Copy to clipboard from command line
command -v tmux >/dev/null 2>&1 || { sudo apt install xclip; }

# Browser
command -v chromium >/dev/null 2>&1 || { sudo apt install chromium-browser; }

# Integrated development environment (IDE)
command -v atom >/dev/null 2>&1 || { wget -O atom.deb https://atom.io/download/deb && sudo dpkg --install atom.deb && rm atom.deb; }

# Desktop manager
command -v gdm3 >/dev/null 2>&1 || { sudo apt install gdm3; }

# Node version manager
command -v nvm >/dev/null 2>&1 || { curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh; source ~/.bash_profile; nvm install stable; nvm use stable; }

# Silver searcher
command -v ag >/dev/null 2>&1 || { sudo apt install silversearcher-ag }

# Music player
command -v spotify >/dev/null 2>&1 || { sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886; echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list; sudo apt update; sudo apt install spotify-client; }
