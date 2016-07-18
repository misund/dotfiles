# Install my favourite programs on a new and shiny system

# Text editor
command -v git >/dev/null 2>&1 || { sudo apt install git; }

# Version control
command -v vim >/dev/null 2>&1 || { sudo apt install vim; }

# Terminal multiplexer
command -v tmux >/dev/null 2>&1 || { sudo apt install tmux; }

# Browser
command -v chromium >/dev/null 2>&1 || { sudo apt install chromium-browser; }

# Integrated development environment (IDE)
command -v atom >/dev/null 2>&1 || { wget -O atom.deb https://atom.io/download/deb && sudo dpkg --install atom.deb && rm atom.deb; }

# Desktop manager
command -v gdm3 >/dev/null 2>&1 || { sudo apt install gdm3; }

# Node version manager
command -v nvm >/dev/null 2>&1 || { curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh; source ~/.bash_profile; nvm install stable; nvm use stable; }
