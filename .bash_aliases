# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -lh'
alias la='ls -alh'
alias l='ls -l'
alias grep='grep --color=auto'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias ..='cd ..'
alias lock='gnome-screensaver-command --lock'

#-------------------------------------------------------------
# spelling typos - highly personnal and keyboard-dependent :-)
#-------------------------------------------------------------

alias xs='cd'
alias vf='cd'
alias clea='clear'
alias clera='clear'
alias gti='git'
alias cim='vim'

#-------------------------------------------------------------
# A few fun ones
#-------------------------------------------------------------

function xtitle()      # Adds some text in the terminal frame.
{
    case "$TERM" in
        *term | rxvt)
            echo -n -e "\033]0;$*\007" ;;
        *)  
            ;;
    esac
}

# aliases that use xtitle
alias top='xtitle Processes on $HOST && top'
alias make='xtitle Making $(basename $PWD) ; make'
alias ncftp="xtitle ncFTP ; ncftp"

# .. and functions
function man()
{
    for i ; do
        xtitle The $(basename $1|tr -d .[:digit:]) manual
        command man -a "$i"
    done
}

function lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}

#-------------------------------------------------------------
# More aliases
#-------------------------------------------------------------
alias bitch="sudo"
alias gimmerails="source ~/.rvm/bin/rvm"
alias mienkofaktura='export FAKTURADB=~/.mienkofaktura/faktura.db && faktura.py'
alias evil-update='sudo apt-get update && sudo apt-get upgrade --yes && sudo apt-get dist-upgrade --yes && sudo apt-get autoremove --yes'

#-------------------------------------------------------------
# SSHs I often use...
#-------------------------------------------------------------
alias uio='ssh -Yl thomamha smaragd.ifi.uio.no'
alias loop='ssh misund@loop.serversenter.net'
alias windows='rdesktop -f -k no -r sound:local -u thomamha windows.ifi.uio.no'
alias win='rdesktop -f -k no -r sound:remote -u thomas 192.168.1.46'
alias wopr='ssh -Yl thomas wopr.neuf.no'
alias ftpwopr='sftp thomas@wopr.neuf.no'
alias ftpuio='sftp thomamha@smaragd.uio.no'
# see also .ssh/config
