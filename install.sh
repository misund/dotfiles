#!/bin/bash

echo "Installing dotfiles. Your old files WILL be deleted. Sorry."

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
rm ~/.gitconfig
rm ~/.gitignore
rm ~/.npmrc
rm ~/.vimrc
rm ~/.ssh/config
rm -rf ~/.vim/

# Symlink files in this repo 
ln -s $DIR/.bashrc ~/.bashrc
ln -s $DIR/.bash_prompt ~/.bash_prompt
ln -s $DIR/.bash_aliases ~/.bash_aliases
ln -s $DIR/.bash_profile ~/.bash_profile
ln -s $DIR/.gitconfig ~/.gitconfig
ln -s $DIR/.gitignore ~/.gitignore
ln -s $DIR/.npmrc ~/.npmrc
ln -s $DIR/.vimrc ~/.vimrc
mkdir -p ~/.ssh
ln -s $DIR/.ssh/config ~/.ssh/config

# Would you like to ue copies instead?
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
git clone https://github.com/moll/vim-node.git ~/.vim/bundle/node
git clone https://github.com/mattn/emmet-vim.git ~/.vim/bundle/emmet-vim
git clone https://github.com/editorconfig/editorconfig-vim ~/.vim/bundle/editorconfig-vim

curl -LSso ~/.vim/autoload/pathogen.vim \
  https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

echo "Setting up nvm"

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh

source ~/.bash_profile # Reload profile to make sure nvm is go
nvm install stable

echo "Finished!"
