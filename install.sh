#!/bin/bash
set -euo pipefail

# Get the directory of this script
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd "$DIR"

echo "Installing dotfiles with GNU Stow..."
echo "This will create symlinks from your home directory to this dotfiles repo."
echo ""
echo "Note: If you have existing dotfiles, Stow will refuse to overwrite them."
echo "You can manually backup/remove conflicting files, or run with --adopt to"
echo "merge existing files into this repo."
echo ""
read -p "Continue? [Y/n]: " OKGO
OKGO=${OKGO:-Y}
[[ ! $OKGO =~ ^[yY]|[yY][eE][sS]$ ]] && exit 0

# Ensure XDG_CONFIG_HOME is set
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is not installed."
    echo "Install it with: sudo apt install stow"
    exit 1
fi

# Clone git-whoami if not present
echo "Setting up git-whoami..."
if [[ ! -d stow-bin/bin/git-whoami ]]; then
    git clone https://github.com/petere/git-whoami stow-bin/bin/git-whoami
fi

# Stow all packages
echo "Creating symlinks with Stow..."
stow -v -t ~ -S */

# Setup vim directories and plugins
echo "Setting up vim directories..."
mkdir -p ~/.vim/{autoload,backups,bundle,swaps,undo}

# Install Pathogen if not present
if [[ ! -f ~/.vim/autoload/pathogen.vim ]]; then
    echo "Installing Pathogen..."
    curl -LSso ~/.vim/autoload/pathogen.vim \
        https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
fi

# Clone vim plugins if they don't exist
echo "Installing vim plugins..."
[[ ! -d ~/.vim/bundle/node ]] && \
    git clone https://github.com/moll/vim-node.git ~/.vim/bundle/node
[[ ! -d ~/.vim/bundle/emmet-vim ]] && \
    git clone https://github.com/mattn/emmet-vim.git ~/.vim/bundle/emmet-vim
[[ ! -d ~/.vim/bundle/editorconfig-vim ]] && \
    git clone https://github.com/editorconfig/editorconfig-vim.git ~/.vim/bundle/editorconfig-vim
[[ ! -d ~/.vim/bundle/vim-stylus ]] && \
    git clone https://github.com/wavded/vim-stylus.git ~/.vim/bundle/vim-stylus
[[ ! -d ~/.vim/bundle/yajs.vim ]] && \
    git clone https://github.com/othree/yajs.vim.git ~/.vim/bundle/yajs.vim
[[ ! -d ~/.vim/bundle/vim-jsx ]] && \
    git clone https://github.com/mxw/vim-jsx.git ~/.vim/bundle/vim-jsx

# Setup neovim symlinks
echo "Setting up neovim..."
mkdir -p $XDG_CONFIG_HOME
if [[ ! -L $XDG_CONFIG_HOME/nvim && ! -e $XDG_CONFIG_HOME/nvim ]]; then
    ln -s ~/.vim $XDG_CONFIG_HOME/nvim
fi
if [[ ! -L $XDG_CONFIG_HOME/nvim/init.vim && ! -e $XDG_CONFIG_HOME/nvim/init.vim ]]; then
    ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
fi

# Setup bash completion for yarn
echo "Setting up bash completion for yarn..."
COMPLETIONS_DIR="${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions"
mkdir -p "${COMPLETIONS_DIR}"
if [[ ! -f "${COMPLETIONS_DIR}/yarn" ]]; then
    curl -o "${COMPLETIONS_DIR}/yarn" \
        https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
fi

echo ""
echo "✓ Dotfiles installed successfully!"
echo ""
echo "To activate the new dotfiles, run: source ~/.bashrc"
echo ""
echo "To uninstall, run: stow -D -t ~ bash git vim tmux ssh misc config stow-bin"
