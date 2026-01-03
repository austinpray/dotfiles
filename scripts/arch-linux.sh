#!/bin/bash
set -euo pipefail

PACKAGES=(
    brightnessctl
    just
    lxqt-policykit
    network-manager-applet
    openssh
    otf-font-awesome
    podman
    polkit
    qemu-user-static
    qemu-user-static-binfmt
    rsync
    uv
    waybar
    wireless-regdb
    wl-clipboard
)

# Desktop apps
# ============
PACKAGES+=(
    # blender
    opensnitch
    qt5-wayland
)

# # AMD GPU support
# if lspci | grep -iE 'vga.*amd|vga.*ati|display.*amd' &> /dev/null; then
#     PACKAGES+=(hip-runtime-amd)
# fi

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
    if paru -Qi "$package" &> /dev/null; then
        echo "$package is already installed"
    else
        echo "$package needs to be installed"
        TO_INSTALL+=("$package")
    fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
    echo "Installing ${#TO_INSTALL[@]} package(s)..."
    paru -S --noconfirm "${TO_INSTALL[@]}"
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

# Symlink Sway Config
# ===================

if command -v sway &> /dev/null; then
    DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
    SWAY_CONFIG_SRC="$DOTFILES_DIR/.config/sway"
    SWAY_CONFIG_DEST="$HOME/.config/sway"

    if [ -L "$SWAY_CONFIG_DEST" ] && [ "$(readlink "$SWAY_CONFIG_DEST")" = "$SWAY_CONFIG_SRC" ]; then
        echo "Sway config directory symlink already exists"
    else
        echo "Creating sway config directory symlink..."
        mkdir -p "$HOME/.config"
        rm -rf "$SWAY_CONFIG_DEST"
        ln -s "$SWAY_CONFIG_SRC" "$SWAY_CONFIG_DEST"
        echo "Sway config directory symlinked"
    fi
else
    echo "sway is not installed, skipping config symlink"
fi

# Symlink Waybar Config
# =====================

if command -v waybar &> /dev/null; then
    DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
    WAYBAR_CONFIG_SRC="$DOTFILES_DIR/.config/waybar"
    WAYBAR_CONFIG_DEST="$HOME/.config/waybar"

    if [ -L "$WAYBAR_CONFIG_DEST" ] && [ "$(readlink "$WAYBAR_CONFIG_DEST")" = "$WAYBAR_CONFIG_SRC" ]; then
        echo "Waybar config symlink already exists"
    else
        echo "Creating waybar config symlink..."
        mkdir -p "$(dirname "$WAYBAR_CONFIG_DEST")"
        ln -sf "$WAYBAR_CONFIG_SRC" "$WAYBAR_CONFIG_DEST"
        echo "Waybar config symlinked"
    fi
else
    echo "waybar is not installed, skipping config symlink"
fi

# Configure Podman Registries
# ===========================

PODMAN_REGISTRY_CONF="/etc/containers/registries.conf.d/10-unqualified-search-registries.conf"
EXPECTED_CONTENT='unqualified-search-registries = ["docker.io"]'

if [ -f "$PODMAN_REGISTRY_CONF" ]; then
    echo "Podman registry config already exists"
else
    echo "Configuring Podman registries..."
    sudo mkdir -p "$(dirname "$PODMAN_REGISTRY_CONF")"
    echo "$EXPECTED_CONTENT" | sudo tee "$PODMAN_REGISTRY_CONF" > /dev/null
    echo "Podman registries configured"
fi

# Authenticate Podman with GitHub Container Registry
# ===================================================

if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    echo "Authenticating Podman with GitHub Container Registry..."
    gh auth token | podman login ghcr.io -u austinpray --password-stdin
    echo "Podman authenticated with ghcr.io"
else
    echo "GitHub CLI not authenticated, skipping ghcr.io login"
fi

# Configure Wireless Regulatory Domain
# ====================================

WIRELESS_REGDOM_CONF="/etc/conf.d/wireless-regdom"

if [ -f "$WIRELESS_REGDOM_CONF" ]; then
    if grep -q '^WIRELESS_REGDOM="US"' "$WIRELESS_REGDOM_CONF"; then
        echo "US wireless regulatory domain already configured"
    else
        echo "Configuring US wireless regulatory domain..."
        sudo sed -i 's/^#WIRELESS_REGDOM="US"/WIRELESS_REGDOM="US"/' "$WIRELESS_REGDOM_CONF"
        echo "US wireless regulatory domain configured (reboot required)"
    fi
else
    echo "wireless-regdom config not found, skipping regdom configuration"
fi

# Enable OpenSnitch Daemon
# ========================

echo "Configuring OpenSnitch daemon..."
if systemctl is-enabled opensnitchd.service &> /dev/null; then
    echo "opensnitchd.service is already enabled"
else
    echo "Enabling opensnitchd.service..."
    sudo systemctl enable --now opensnitchd.service
    echo "opensnitchd.service enabled and started"
fi
