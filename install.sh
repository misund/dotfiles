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
[[ ! $OKGO =~ ^([yY]|[yY][eE][sS])$ ]] && exit 0

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
# renovate: datasource=git-refs depName=https://github.com/tpope/vim-pathogen currentValue=master
# Checksum below is recomputed by .github/workflows/renovate-checksums.yml
PATHOGEN_COMMIT="ac4dd9494fa9008754e49dff85bff1b5746c89b4"
PATHOGEN_SHA256="aa5cfa007809596bd55ee1f21f62bd9afa3a29f1c4ac785312ee467b0648180e"
if [[ ! -f ~/.vim/autoload/pathogen.vim ]]; then
    echo "Installing Pathogen..."
    PATHOGEN_TMP="$(mktemp)"
    curl -LSso "$PATHOGEN_TMP" \
        "https://raw.githubusercontent.com/tpope/vim-pathogen/${PATHOGEN_COMMIT}/autoload/pathogen.vim"
    echo "${PATHOGEN_SHA256}  ${PATHOGEN_TMP}" | sha256sum -c -
    mv "$PATHOGEN_TMP" ~/.vim/autoload/pathogen.vim
fi

# Clone vim plugins if they don't exist
echo "Installing vim plugins..."
VIM_PLUGINS=(
    "moll/vim-node:node"
    "mattn/emmet-vim"
    "editorconfig/editorconfig-vim"
    "wavded/vim-stylus"
    "othree/yajs.vim"
    "mxw/vim-jsx"
)
for plugin in "${VIM_PLUGINS[@]}"; do
    repo="${plugin%%:*}"
    name="${repo##*/}"
    dir="${plugin#*:}"
    [[ "$dir" == "$plugin" ]] && dir="$name"
    target="$HOME/.vim/bundle/$dir"
    [[ ! -d "$target" ]] && git clone "https://github.com/$repo.git" "$target"
done

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
# renovate: datasource=git-refs depName=https://github.com/dsifford/yarn-completion currentValue=master
# Checksum below is recomputed by .github/workflows/renovate-checksums.yml
YARN_COMPLETION_COMMIT="73fe6781037336d210ba25b9dd0e90a335839e58"
YARN_COMPLETION_SHA256="d98a81b18339ab717a94758fa7e7ebd58404588b510f55f7c141f7d489f19568"
if [[ ! -f "${COMPLETIONS_DIR}/yarn" ]]; then
    YARN_COMPLETION_TMP="$(mktemp)"
    curl -LSso "$YARN_COMPLETION_TMP" \
        "https://raw.githubusercontent.com/dsifford/yarn-completion/${YARN_COMPLETION_COMMIT}/yarn-completion.bash"
    echo "${YARN_COMPLETION_SHA256}  ${YARN_COMPLETION_TMP}" | sha256sum -c -
    mv "$YARN_COMPLETION_TMP" "${COMPLETIONS_DIR}/yarn"
fi

# Install local VS Code extension for dotfiles sync
if command -v code &> /dev/null; then
    echo "Installing dotfiles-sync VS Code extension..."
    VSIX_PATH="$DIR/vscode/.config/Code/User/extensions/dotfiles-sync/build/dotfiles-sync-0.0.1.vsix"
    if [[ -f "$VSIX_PATH" ]]; then
        code --install-extension "$VSIX_PATH" --force
    fi
fi

echo ""
echo "✓ Dotfiles installed successfully!"
echo ""
echo "To activate the new dotfiles, run: source ~/.bashrc"
echo ""
echo "To uninstall, run: stow -D -t ~ ai bash git vim tmux ssh misc config stow-bin vscode"
