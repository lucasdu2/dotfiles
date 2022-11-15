# Tess/K8s PATH modifications
export PATH=$PATH:/opt/tess/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=~/bin:$PATH

# Source zsh plugins
source $HOME/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh_plugins/zsh-vim-mode/zsh-vim-mode.plugin.zsh
source $HOME/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable ls color on MacOS
alias ls='ls -G'

# Aliases for nvim
alias vim="nvim"
alias vi="nvim"
alias vimdiff='nvim -d'
export EDITOR=nvim

# Alias for dotfiles git tracking
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Enable vi mode
bindkey -v

# Fix Kitty SSH
alias ssh='TERM="xterm-256color" ssh'

# Set bat theme
# export BAT_THEME="TwoDark"
export BAT_THEME="GitHub"

# eBay custom aliases/commands
alias ts='tess login -c'
alias kc='tess kubectl'

alias kd='tess kubectl describe'
alias kD='tess kubectl delete'
alias kdd='tess kubectl describe deployment'
alias ke='tess kubectl edit'
alias kg='tess kubectl get'
alias kl='tess kubectl logs'
alias klf='tess kubectl logs -f'
alias ko='tess kubectl get -oyaml'
alias kw='tess kubectl get -o wide'
alias kgp='tess kubectl get pod'
alias kgd='tess kubectl get deployment'
alias kubectl='tess kubectl'

kexec() {
    local pod=$1
    local container=${2:-none}
    local executable=${3:-/bin/bash}

    if [ -z "$pod" ]; then
        echo >&2 "error: must specify pod"
        return
    fi

    if [ "$container" != "none" ]; then
        cmd="tess kubectl exec -it $pod -c $container -- $executable"
    else
        cmd="tess kubectl exec -it $pod -- $executable"
    fi
    eval $cmd
}

ns ()
{
    if [ -n "$1" ]; then
        current_context=`tess kubectl config current-context`;
        tess kubectl config set-context ${current_context} --namespace=$1 > /dev/null;
    fi;
    echo "`tess kubectl config get-contexts | awk '/^\*/ {print $5}'`"
}

cluster ()
{
    if [ -n "$1" ]; then
        tess kubectl config use-context $1 > /dev/null;
    fi;
    echo "`tess kubectl config get-contexts | awk '/^\*/ {print $3}'`"
}

# Enable Starship prompt
eval "$(starship init zsh)"

# FZF integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
