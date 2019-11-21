emulate sh -c 'source /etc/profile.d/apps-bin-path.sh'

# Node
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Golang
export PATH=$PATH:/usr/local/go/bin

# FLutter
export PATH=$PATH:$HOME/Apps/flutter/bin

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Android
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools 
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH/:$ANDROID_HOME/platform-tools

# Draft
export PATH=$PATH:$HOME/Apps/draft

# Aliases
alias code="codium"
alias dockerstop="docker stop $(docker ps -a -q)"
