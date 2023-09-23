#!/bin/bash

echo "This will install shiny dotfiles. Your old dotfiles will be deleted."
read -p "Continue? [Y/n]:" OKGO
OKGO=${OKGO:-Y}
if [[ $OKGO =~ ^[yY]|[yY][eE][sS]$ ]]
then
	echo "You were warned. Commencing shininess..."
else
	exit
fi

# Get the directory of this script
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Remove old dotfiles
rm ~/.bashrc
rm ~/.bash_prompt
rm ~/.bash_aliases
rm ~/.bash_kubecontext
rm ~/.bash_npm_completion
rm ~/.bash_profile
rm ~/.less_colors
rm ~/.gitconfig
rm ~/.gitconfig-coop
rm ~/.npmrc
rm ~/.tmux.conf
rm ~/.vimrc
rm ~/.ssh/config
rm ~/.ssh/keydir
rm ~/.config/tiling-assistant/layouts.json
rm -rf ~/.vim/
rm -rf ~/bin/git-whoami
rm -rf $DIR/bin/git-whoami

# bzr-like command `git whoami`
mkdir -p $DIR/bin
git clone https://github.com/petere/git-whoami $DIR/bin/git-whoami

# Symlink files in this repo
ln -s $DIR/.bashrc ~/.bashrc
ln -s $DIR/.bash_prompt ~/.bash_prompt
ln -s $DIR/.bash_aliases ~/.bash_aliases
ln -s $DIR/.bash_kubecontext ~/.bash_kubecontext
ln -s $DIR/.bash_npm_completion ~/.bash_npm_completion
ln -s $DIR/.bash_profile ~/.bash_profile
ln -s $DIR/.less_colors ~/.less_colors
ln -s $DIR/.gitconfig ~/.gitconfig
ln -s $DIR/.gitconfig-coop ~/.gitconfig-coop
ln -s $DIR/.npmrc ~/.npmrc
ln -s $DIR/.tmux.conf ~/.tmux.conf
ln -s $DIR/.vimrc ~/.vimrc
mkdir -p ~/.ssh
ln -s $DIR/.ssh/config ~/.ssh/config
ln -s $DIR/.ssh/keydir ~/.ssh/keydir
ln -s $DIR/.config/tiling-assistant/layouts.json ~/.config/tiling-assistant/layouts.json
mkdir -p ~/bin
ln -s $DIR/bin/git-whoami/git-whoami ~/bin/git-whoami

# Would you like to use copies instead?
# cp $DIR/.bashrc ~/
# cp $DIR/.bash_prompt ~/
# cp $DIR/.bash_aliases ~/
# cp $DIR/.bash_profile ~/
# cp $DIR/.gitignore ~/
# cp $DIR/.gitconfig ~/
# cp $DIR/.vimrc ~/

# source to use our new dotfiles
source ~/.bashrc

echo "Setting up ~/.vim directories"

# Set up vim directories and install Pathogen:
mkdir -p ~/.vim
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/backups
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/swaps
mkdir -p ~/.vim/undo
ln -s $DIR/.vim/colors ~/.vim/colors
ln -s $DIR/.vim/ftplugin ~/.vim/ftplugin
ln -s $DIR/.vim/plugin ~/.vim/plugin

# Get some plugins
git clone https://github.com/moll/vim-node.git ~/.vim/bundle/node                             # Node tools
git clone https://github.com/mattn/emmet-vim.git ~/.vim/bundle/emmet-vim                      # Boilerplate shorthands
git clone https://github.com/editorconfig/editorconfig-vim.git ~/.vim/bundle/editorconfig-vim # Define tab styles per project cross-developers and cross-editors
git clone https://github.com/wavded/vim-stylus.git ~/.vim/bundle/vim-stylus                   # Syntax highlighting for Stylus
git clone https://github.com/othree/yajs.vim.git ~/.vim/bundle/yajs.vim                       # Syntax highlighting for ES6
git clone https://github.com/mxw/vim-jsx.git ~/.vim/bundle/vim-jsx                            # Syntax highlighting for JSX

curl -LSso ~/.vim/autoload/pathogen.vim \
  https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

echo "Setting up neovim"
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
ln -s ~/.vim $XDG_CONFIG_HOME/nvim
ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim

echo "Setting up bash completion for yarn"
COMPLETIONS_DIR="${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions"
rm $COMPLETIONS_DIR/yarn
mkdir -p ${COMPLETIONS_DIR}
curl -o "${COMPLETIONS_DIR}/yarn" https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash

echo "Finished!"
