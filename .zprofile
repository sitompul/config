# Node
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Golang
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

export PATH=$PATH:$HOME/Applications/flutter/bin

# Java
export CLASSPATH="$HOME/classpath/gson-2.8.6.jar":"${CLASSPATH}"

# Kubernetes
export KUBE_EDITOR="vim"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Docker Aliases
alias msf="docker run -it --privileged --net=host metasploitframework/metasploit-framework"
