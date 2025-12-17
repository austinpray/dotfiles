export EDITOR=vim
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/dotfiles/bin:$PATH
export PATH=$HOME/.binenv:$PATH
export PATH=$HOME/.local/bin:$PATH

# SSH Agent (Arch Linux with systemd)
if [ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

bindkey -v
# End of lines configured by zsh-newuser-install

eval "$(starship init zsh)"

# completion
source <(binenv completion zsh)
