# Shell configuration shared by bash and zsh.
#
# Sourced by ~/dotfiles/.zshrc and by a marker block install.sh appends to
# ~/.bashrc. The rc files themselves are not symlinked into this repo for bash:
# a GCP devbox provisions ~/.bashrc and rewrites blocks in it, so a symlink
# would carry machine-local state back into version control (the same reasoning
# that keeps ~/.gitconfig a real file; see install.sh).

export EDITOR=vim

export PATH=/usr/local/bin:$PATH
if command -v binenv >/dev/null 2>&1 || [ -x "$HOME/.binenv/binenv" ]; then
    export PATH=$HOME/.binenv:$PATH
fi
export PATH=$HOME/.local/bin:$PATH
export PATH="$HOME/.devcontainers/bin:$PATH"

# ~/dotfiles/bin stays off PATH on a GCP devbox. Its `gh` is a wrapper that
# requires a .github-token.txt in the cwd and exits non-zero without one, which
# is the point on a personal machine juggling scoped per-project tokens. A
# devbox has exactly one GitHub identity and a monorepo full of tooling that
# shells out to `gh`, so shadowing the real binary there only breaks things.
# `ggh` reaches the real binary wherever the wrapper is on PATH.
if [ ! -f "$HOME/.gcpdevbox" ]; then
    export PATH=$HOME/dotfiles/bin:$PATH
fi

# Disable Claude Code telemetry
export DISABLE_TELEMETRY=1
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# SSH Agent (Arch Linux with systemd)
if [ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

# Devbox environment markers (DEVBOX=1, the bazel wrapper on PATH).
if [ -f "$HOME/.gcpdevbox" ]; then
    . "$HOME/.gcpdevbox"
fi

# The monorepo's shell env is expensive and interactive: it bootstraps aqua,
# refreshes gcloud and cluster credentials, and activates a virtualenv. A
# devbox's own ~/.bashrc already sources it, so key off a variable it exports
# to avoid paying for it twice in one shell.
if [ -f "$HOME/analytics/.shellenv" ] && [ -z "${AQUA_GLOBAL_CONFIG:-}" ]; then
    . "$HOME/analytics/.shellenv"
fi

# starship and binenv want the name of the running shell. Both are resolved
# after the PATH and .shellenv work above, which is where they come from on a
# devbox (aqua) and on Arch (binenv or pacman).
if [ -n "${ZSH_VERSION:-}" ]; then
    dotfiles_shell=zsh
elif [ -n "${BASH_VERSION:-}" ]; then
    dotfiles_shell=bash
else
    dotfiles_shell=
fi

if [ -n "$dotfiles_shell" ] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init $dotfiles_shell)"
fi

if [ -n "$dotfiles_shell" ] && command -v binenv >/dev/null 2>&1; then
    source <(binenv completion $dotfiles_shell)
fi

unset dotfiles_shell
