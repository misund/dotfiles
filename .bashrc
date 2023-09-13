# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

RED='\033[0;31m'
NOCOLOR='\033[0m' # No Color
printf "${RED}<3${NOCOLOR}\n"

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

    # /* @TODO Properly install starship prompt: */
    # /**
    #  - Shallow clone nerd fonts repo and install the Druid Mono font
    #  - Set the font in Gnome Terminal Emulator (with gsettings?)
    #  - Set the font in VS Code
    #  - Install starship
    #  - let the command under this comment replace most of what's in .bash_prompt
    #  - add .config/starship to dotfiles
    #  */

    command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
fi

if [ -f ~/.bash_kubecontext ]; then
  . ~/.bash_kubecontext
fi

# Define colors in less (man uses less for paging by default)
if [ -f ~/.less_colors ]; then
    . ~/.less_colors
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# NPM script completion, e.g. `npm run clean`
if [ -f ~/.bash_npm_completion ]; then
    . ~/.bash_npm_completion
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
# kubectl completion, pls
command -v kubectl >/dev/null 2>&1 && { (source <(kubectl completion bash) ) }

# execute files in $HOME/bin
PATH="$HOME/bin:$PATH"

# Add Jena to Java's CLASSPATH
export CLASSPATH=$CLASSPATH:$HOME/bin/Jena-2.6.4/bin

# Add RVM to PATH for scripting
#PATH="$HOME/.gem/ruby/1.9.1/bin:$PATH"
PATH=$PATH:$HOME/.rvm/bin

# Add NVM to PATH for scripting
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh # This loads NVM
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion # Bash completion for NVM
export NODE_PATH=$NODE_PATH:$HOME/.npm/lib/node_modules # Put NPM root value in node path
export PATH=$PATH:~/.npm/bin # run node modules' executables (like grunt)

# Start tmux
[[ -z "$TMUX" ]] && exec tmux

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
