# .bashrc
export PS1="\[$(tput bold)\]\[\033[38;5;42m\]\w\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;14m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\]\n\[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"


# Node
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Golang
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

export PATH=$PATH:$HOME/Apps/flutter/bin

# Composer
export PATH=~/.config/composer/vendor/bin:$PATH

# Java
export CLASSPATH="$HOME/classpath/gson-2.8.6.jar":"${CLASSPATH}"

# Kubernetes
export KUBE_EDITOR="vim"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Config
export CHROME_EXECUTABLE="brave-browser"

# Docker Aliases
alias msf="docker run -it --privileged --net=host metasploitframework/metasploit-framework"

# Qt5CT
export QT_QPA_PLATFORMTHEME=qt5ct

# Snap
alias disable-snap="sudo systemctl stop snapd.service && sudo systemctl mask snapd.service"
alias enable-snap="sudo systemctl unmask snapd.service && sudo systemctl start snapd.service && sudo snap refresh"
