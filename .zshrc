export EDITOR=vim
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/dotfiles/bin:$PATH
export PATH=$HOME/.binenv:$PATH
export PATH=$HOME/.local/bin:$PATH

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

bindkey -v
# End of lines configured by zsh-newuser-install

eval "$(starship init zsh)"

# completion
source <(binenv completion zsh)
