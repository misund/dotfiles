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
rm ~/.gitconfig
rm ~/.gitignore
rm ~/.vimrc
rm ~/.ssh/config
rm -rf ~/.vim/colors/

# Symlink files in this repo 
ln -s $DIR/.bashrc ~/.bashrc
ln -s $DIR/.bash_prompt ~/.bash_prompt
ln -s $DIR/.bash_aliases ~/.bash_aliases
ln -s $DIR/.gitconfig ~/.gitconfig
ln -s $DIR/.gitignore ~/.gitignore
ln -s $DIR/.vimrc ~/.vimrc
mkdir -p ~/.ssh
ln -s $DIR/.ssh/config ~/.ssh/config

# Would you like to ue copies instead?
# cp $DIR/.bash_prompt ~
# cp $DIR/.bashrc ~/
# cp $DIR/.gitignore ~/
# cp $DIR/.vimrc ~/
# cp $DIR/.gitconfig ~/

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

curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

echo "Finished!"
