[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh && nvm alias default stable # This loads NVM
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion # Bash completion for NVM
[[ -d /usr/local/go/bin ]] && export PATH=$PATH:/usr/local/go/bin # Add Golang's go and gofmt to path

command -v yarn >/dev/null 2>&1 && { ( export PATH=$PATH:`yarn global bin` ) }
