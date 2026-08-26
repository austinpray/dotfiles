export EDITOR=vim
export PATH=/usr/local/bin:$PATH
if command -v binenv &>/dev/null || [ -x "$HOME/.binenv/binenv" ]; then
    export PATH=$HOME/.binenv:$PATH
fi
export PATH=$HOME/.local/bin:$PATH
export PATH="$HOME/.devcontainers/bin:$PATH"
export PATH=$HOME/dotfiles/bin:$PATH

# Disable Claude Code telemetry
export DISABLE_TELEMETRY=1
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

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
if command -v binenv &>/dev/null; then
    source <(binenv completion zsh)
fi

if [ -f "$HOME/analytics/.shellenv" ]; then
    source "$HOME/analytics/.shellenv"
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

