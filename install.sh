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
rm ~/.bash_profile
rm ~/.less_colors
rm ~/.gitconfig
rm ~/.npmrc
rm ~/.tmux.conf
rm ~/.vimrc
rm ~/.ssh/config
rm ~/.ssh/keydir
rm -rf ~/.vim/
rm -rf $DIR/bin/git-whoami

# bzr-like command `git whoami`
mkdir -p $DIR/bin
git clone https://github.com/petere/git-whoami $DIR/bin/git-whoami

# Symlink files in this repo 
ln -s $DIR/.bashrc ~/.bashrc
ln -s $DIR/.bash_prompt ~/.bash_prompt
ln -s $DIR/.bash_aliases ~/.bash_aliases
ln -s $DIR/.bash_profile ~/.bash_profile
ln -s $DIR/.less_colors ~/.less_colors
ln -s $DIR/.gitconfig ~/.gitconfig
ln -s $DIR/.npmrc ~/.npmrc
ln -s $DIR/.tmux.conf ~/.tmux.conf
ln -s $DIR/.vimrc ~/.vimrc
mkdir -p ~/.ssh
ln -s $DIR/.ssh/config ~/.ssh/config
ln -s $DIR/.ssh/keydir ~/.ssh/keydir
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

echo "Setting up nvm"

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh

source ~/.bash_profile # Reload profile to make sure nvm is go
nvm install stable
nvm use stable

echo "Finished!"
