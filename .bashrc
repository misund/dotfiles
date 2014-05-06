# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Prompt and title
if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Force UTF-8 output
export LANG=en_US.UTF-8

# gief utf8
export LC_ALL=en_US.utf8

# New files should be 0755 (u=rwx, g=rx, o=rx)
umask 022

#------------------------------------------------------------
# Path
#------------------------------------------------------------
# execute files in $HOME/bin
PATH="$HOME/bin:$PATH"

# Add Jena to Java's CLASSPATH
export CLASSPATH=$CLASSPATH:$HOME/bin/Jena-2.6.4/bin

# Add RVM to PATH for scripting
#PATH="$HOME/.gem/ruby/1.9.1/bin:$PATH"
PATH=$PATH:$HOME/.rvm/bin

# Add NVM to PATH for scripting
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh && nvm use 0.10 # This loads NVM
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion # Bash completion for NVM
export NODE_PATH=$NODE_PATH:$HOME/.npm/lib/node_modules # Put NPM root value in node path
export PATH=$PATH:~/.npm/bin # run node modules' executables (like grunt)
