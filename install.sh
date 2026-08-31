#!/bin/bash
set -euo pipefail

cd ~

DOTFILES_DIR="$HOME/dotfiles"

# These dotfiles cover two kinds of machine: the Arch Linux desktop and a GCP
# devbox (a headless Ubuntu VM with the analytics monorepo). Anything that only
# makes sense in front of a monitor is applied on Arch only; a devbox is
# detected by the ~/.gcpdevbox file its provisioner drops.
IS_ARCH_DESKTOP=false
if command -v pacman &> /dev/null; then
    IS_ARCH_DESKTOP=true
fi

# Install dotfiles
# ================

# Portable configs. Safe on a headless box: .zshrc is inert where zsh is not
# installed, and shell/common.sh (which it and ~/.bashrc both source) adapts to
# whichever machine it finds itself on.
DOTFILES=(.gitignore_global .vimrc .zshrc .tmux.conf .config/starship.toml)

# Wayland compositor, terminal, notifications, night light, dictation, rootless
# containers — all desktop-only, and all pointless on a devbox.
DOTFILES_DESKTOP=(.config/containers/containers.conf .config/ghostty/config .config/mako/config .config/gammastep/config.ini .local/share/com.pais.handy/settings_store.json)

if [ "$IS_ARCH_DESKTOP" = true ]; then
    DOTFILES+=("${DOTFILES_DESKTOP[@]}")
else
    echo "Not an Arch desktop: skipping ${#DOTFILES_DESKTOP[@]} desktop-only configs"
fi

# ~/.gitconfig is a real file that *includes* the tracked one, rather than a
# symlink to it. Plenty of tooling configures git by writing `git config
# --global` (gh auth setup-git, and the gcpdevbox configure-git-auth.sh, which
# stamps an identity from the GitHub profile on every interactive shell). Those
# writes follow a symlink, so symlinking this file puts machine-local identity
# under version control and carries a work email onto every machine that shares
# these dotfiles. Note that `git config --global` does not read `include`
# directives, so such tools cannot see the tracked values and will keep
# rewriting them; only the outer file satisfies them.
#
# Tracked settings come from the include, machine-local ones sit after it, and
# git takes the last value for a key, so the machine always wins.
setup_gitconfig() {
    local target="$HOME/.gitconfig"

    # Carry the machine's identity into the new file. The tracked config sets
    # user.useConfigOnly, so an install that dropped the email on the floor
    # would leave git refusing to commit until whatever configured it (a
    # devbox's configure-git-auth.sh, or a human) ran again. `--global` ignores
    # includes, so this reads only machine-local values.
    local existing_email existing_name
    existing_email="$(git config --global --get user.email || true)"
    existing_name="$(git config --global --get user.name || true)"

    if [ -L "$target" ]; then
        echo "Replacing ~/.gitconfig symlink with a machine-local file"
        rm "$target"
    elif [ -e "$target" ] && grep -qF 'path = ~/dotfiles/.gitconfig' "$target"; then
        echo ".gitconfig already includes the dotfiles config"
        return
    elif [ -e "$target" ]; then
        echo "Backing up existing .gitconfig to .gitconfig.backup"
        mv "$target" "$target.backup"
    fi

    echo "Creating $target (machine-local, includes the tracked config)"
    cat > "$target" <<'GITCONFIG'
# Machine-local git config. Deliberately not tracked in ~/dotfiles: this is
# where this machine's identity lives, along with anything written by
# `git config --global`. Shared settings come from the include below.
[include]
	path = ~/dotfiles/.gitconfig
GITCONFIG

    if [ -n "$existing_email" ]; then
        echo "Preserving this machine's git identity: ${existing_email}"
        printf '\n[user]\n\temail = %s\n' "$existing_email" >> "$target"
        if [ -n "$existing_name" ]; then
            printf '\tname = %s\n' "$existing_name" >> "$target"
        fi
    fi
}
setup_gitconfig

# Symlink dotfiles to home directory
for file in "${DOTFILES[@]}"; do
    # Create parent directory if needed (e.g., ~/.config for .config/starship.toml)
    target_dir="$(dirname "$HOME/$file")"
    if [ ! -d "$target_dir" ]; then
        echo "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    if [ -L "$HOME/$file" ] && [ "$(readlink "$HOME/$file")" = "$DOTFILES_DIR/$file" ]; then
        echo "$file is already symlinked correctly"
    else
        if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            echo "Backing up existing $file to $file.backup"
            mv "$HOME/$file" "$HOME/$file.backup"
        fi
        echo "Creating symlink: $HOME/$file -> $DOTFILES_DIR/$file"
        ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
    fi
done

# ~/.bashrc gets a sourcing block rather than a symlink, for the same reason as
# ~/.gitconfig: a devbox provisions that file and rewrites marked blocks inside
# it. The block goes at the end so the shared config wins over anything the
# distro's default rc set, and it is keyed on its own marker so re-running this
# script does not stack up copies.
setup_bashrc() {
    local target="$HOME/.bashrc"
    local marker="# BEGIN dotfiles (managed by ~/dotfiles/install.sh)"

    if [ -e "$target" ] && grep -qF "$marker" "$target"; then
        echo ".bashrc already sources the dotfiles shell config"
        return
    fi

    echo "Appending the dotfiles shell config block to $target"
    cat >> "$target" <<BASHRC

$marker
source "\$HOME/dotfiles/shell/common.sh"
# END dotfiles
BASHRC
}
setup_bashrc


# Install binaries
# ================

if [ -f "$HOME/.use-binenv" ]; then
    ARCH=$(uname -m)
    BINENV_VERSION="0.21.1"

    # Detect architecture
    case $ARCH in
        x86_64)
            ARCH="amd64"
            ;;
        aarch64|arm64)
            ARCH="arm64"
            ;;
        *)
            echo "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac


    mkdir -p ~/.local/bin

    if ! command -v binenv &> /dev/null; then
        echo "Installing binenv..."
        (
            cd "$(mktemp -d)"
            curl -fsSL -O https://github.com/devops-works/binenv/releases/download/v${BINENV_VERSION}/binenv_linux_${ARCH}
            curl -fsSL -O https://github.com/devops-works/binenv/releases/download/v${BINENV_VERSION}/checksums.txt
            sha256sum  --check --ignore-missing checksums.txt
            mv binenv_linux_${ARCH} binenv
            chmod +x binenv
            ./binenv update
            ./binenv install binenv
            rm binenv
        )
    else
        echo "binenv is already installed, skipping installation"
    fi

    ~/.binenv/binenv install starship
    # ~/.binenv/binenv install jq
    ~/.binenv/binenv install gh
    ~/.binenv/binenv install delta
    ~/.binenv/binenv install dust
else
    # A devbox gets starship, gh, delta and friends from the monorepo's aqua
    # config, so a second version manager would only fight with it.
    echo "Skipping binenv installation (no ~/.use-binenv flag found)"
fi

# ~/.binenv/gh extension install mislav/gh-branch

# Run setup scripts
# ================

# Arch linux desktop setup
if [ "$IS_ARCH_DESKTOP" = true ]; then
    ~/dotfiles/scripts/arch-linux.sh
    ~/dotfiles/scripts/discord.sh
fi

if ! command -v claude &> /dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash 
fi
