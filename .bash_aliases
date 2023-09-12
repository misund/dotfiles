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
 
# tmux
alias tmux='tmux attach || tmux new'

_apt_search_installed() {
    local keyword
    local verbose=false
    local installedFlag="\e[32m[Installed]"
    local configuredFlag="\e[33m[Cfg-files]"
    local indent="           "
    local wrap_width=80
    local cache_output=""
    local dpkg_output=$(dpkg-query -W -f='${Status} ${Package}\n')

    # Check for -v flag for verbosity
    if [ "$1" == "-v" ]; then
        verbose=true
        keyword="$2"
    else
        keyword="$1"
    fi

    while IFS= read -r line; do
        local pkg=$(echo "$line" | awk '{print $1}')
        local short_desc=$(echo "$line" | sed -E "s/^[^ ]+ //")
        local flag=""
        
        cache_output=$(apt-cache show "$pkg" 2>/dev/null)

        # Fetch version
        local version=$(echo "$cache_output" | grep "Version:" | head -n 1 | awk '{print $2}')

        # Check if the package is installed using the cached dpkg_output
        if echo "$dpkg_output" | grep --color=always -q "install ok installed $pkg"; then
            flag=$installedFlag
        elif echo "$dpkg_output" | grep --color=always -q "deinstall ok config-files $pkg"; then
            flag=$configuredFlag
        else
            flag=$indent
        fi

        echo -e "$flag \e[36m$pkg\e[0m $version $short_desc"

        # Fetch verbose description if verbose is true
        if $verbose; then
            # local verbose_desc=$(echo "$cache_output" | grep -A10 "Description-en:" | tail -n +2 | sed ':a;N;$!ba;s/\n/ /g' | fold -s -w $((wrap_width - ${#indent})))
            local verbose_desc=$(echo "$cache_output" | grep -A10 "Description-en:" | tail -n +2 )
            verbose_desc=$(echo "$verbose_desc" | grep -vE "Description-md5:|Task:" | sed 's/  .*$//')
            # If verbose, display the description on the next line followed by an additional newline
            if [ ! -z "$verbose_desc" ]; then
                echo -e "$verbose_desc" | sed "s/^/$indent/"
                echo ""
            fi
        fi

    done < <(apt-cache search "$keyword")
}

apt() {
    # If it starts with "apt search" or "apt search -v" and has exactly one argument
    if [[ "$1" == "search" && ($# -eq 2 || ($# -eq 3 && "$2" == "-v")) ]]; then
        # Call our custom search function
        shift
        _apt_search_installed "$@"
    else
        # Call the actual apt command
        command apt "$@"
    fi
}

# Alias to call the function
alias apt-search='_apt_search_installed'

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
alias clip='xclip -selection clipboard'
alias pbcopy='xclip -selection clipboard'

#-------------------------------------------------------------
# spelling typos - highly personnal and keyboard-dependent :-)
#-------------------------------------------------------------

alias xs='cd'
alias vf='cd'
alias vd='cd'
alias clea='clear'
alias claer='clear'
alias clera='clear'
alias celar='clear'
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
alias evil-update='sudo apt-get update && sudo apt-get upgrade --yes && sudo apt-get dist-upgrade --yes && sudo apt-get autoremove --yes && sudo snap refresh'
alias packaged-node-version="node -pe \"require('./package').engines.node\""

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
