#!/bin/bash
set -euo pipefail

PACKAGES=(
    openssh
    wl-clipboard
)

# Fonts
# =====
# Emoji
PACKAGES+=(
    noto-fonts-emoji
)

# Kaomoji
PACKAGES+=(
    gnu-free-fonts
    ttf-arphic-uming
    ttf-indic-otf
)

echo "Checking Arch Linux packages..."

TO_INSTALL=()

for package in "${PACKAGES[@]}"; do
    if pacman -Qi "$package" &> /dev/null; then
        echo "$package is already installed"
    else
        echo "$package needs to be installed"
        TO_INSTALL+=("$package")
    fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
    echo "Installing ${#TO_INSTALL[@]} package(s)..."
    sudo pacman -S --noconfirm "${TO_INSTALL[@]}"
    echo "Installation complete"
else
    echo "All packages already installed"
fi

# Change shell to zsh
# ===================

if command -v zsh &> /dev/null; then
    CURRENT_SHELL=$(basename "$SHELL")
    if [ "$CURRENT_SHELL" != "zsh" ]; then
        ZSH_PATH=$(which zsh)
        echo "Changing default shell to zsh ($ZSH_PATH)..."
        chsh -s "$ZSH_PATH"
        echo "Shell changed to zsh. You'll need to log out and back in for the change to take effect."
    else
        echo "Default shell is already zsh"
    fi
else
    echo "zsh is not installed, skipping shell change"
fi

# Enable SSH Agent Service
# ========================

echo "Configuring SSH agent service..."
if systemctl --user is-enabled ssh-agent.service &> /dev/null; then
    echo "ssh-agent.service is already enabled"
else
    echo "Enabling ssh-agent.service..."
    systemctl --user enable ssh-agent.service
    systemctl --user start ssh-agent.service
    echo "ssh-agent.service enabled and started"
fi
