#!/bin/bash
set -euo pipefail

cd ~

# Install dotfiles
# ================

DOTFILES_DIR="$HOME/dotfiles"
DOTFILES=(.gitconfig .gitignore_global .vimrc .zshrc .config/starship.toml)

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


# Install binaries
# ================

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

# ~/.binenv/gh extension install mislav/gh-branch

# Run setup scripts
# ================

# Arch linux desktop setup
if command -v pacman &> /dev/null; then
    ~/dotfiles/scripts/arch-linux.sh
    ~/dotfiles/scripts/discord.sh
fi
