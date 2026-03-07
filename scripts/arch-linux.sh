#!/bin/bash
set -euo pipefail

PACKAGES=(
    brightnessctl
    bubblewrap
    docker
    docker-buildx
    docker-compose
    dkms
    just
    linux-headers
    lxqt-policykit
    network-manager-applet
    mosh
    openssh
    tmux
    otf-font-awesome
    podman
    podman-compose
    polkit
    python-pip
    qemu-user-static
    qemu-user-static-binfmt
    recutils
    r8152-dkms
    rsync
    socat
    uv
    wireless-regdb
    wl-clipboard
)

# Desktop apps
# ============
PACKAGES+=(
    # blender
    cable
    grim
    opensnitch
    pinta
    pngquant
    pwvucontrol
    qt5-wayland
    screengrab
    slurp
    swappy
    wl-clipboard
)

# Sway
# ====
PACKAGES+=(
    mako
    swayidle
    swaylock
    waybar
)

# Speech Recognition
# ==================
PACKAGES+=(
    wtype
    handy-bin
)

# Screen color temperature
# ========================
PACKAGES+=(
    gammastep
)

# Network tools
# =============
PACKAGES+=(
    ethtool
    ookla-speedtest-bin
)

# # AMD GPU support
# if lspci | grep -iE 'vga.*amd|vga.*ati|display.*amd' &> /dev/null; then
#     PACKAGES+=(hip-runtime-amd)
# fi

# Fonts
# =====
# Nerd Fonts
PACKAGES+=(
    ttf-jetbrains-mono-nerd
)

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

# Packages to remove (declarative uninstall)
# ==========================================
REMOVE_PACKAGES=(
    hyprwhspr
    pavucontrol
    python-gobject
    gtk4
    gtk4-layer-shell
    speedtest-cli
)

# Replace PulseAudio with PipeWire
# =================================

if paru -Qi pulseaudio &> /dev/null; then
    echo "Replacing pulseaudio with pipewire-pulse..."
    paru -Rdd --noconfirm pulseaudio
    paru -S --noconfirm pipewire-pulse
    echo "Replaced pulseaudio with pipewire-pulse"
elif paru -Qi pipewire-pulse &> /dev/null; then
    echo "pipewire-pulse is already installed"
else
    echo "Installing pipewire-pulse..."
    paru -S --noconfirm pipewire-pulse
    echo "pipewire-pulse installed"
fi

# Remove unwanted packages
# ========================

if [ ${#REMOVE_PACKAGES[@]} -gt 0 ]; then
    echo "Checking packages to remove..."
    TO_REMOVE=()

    for package in "${REMOVE_PACKAGES[@]}"; do
        if paru -Qe "$package" &> /dev/null; then
            echo "$package is explicitly installed, will remove"
            TO_REMOVE+=("$package")
        else
            echo "$package is not explicitly installed, skipping"
        fi
    done

    if [ ${#TO_REMOVE[@]} -gt 0 ]; then
        echo "Removing ${#TO_REMOVE[@]} package(s)..."
        paru -Rs --noconfirm "${TO_REMOVE[@]}"
        echo "Removal complete"
    else
        echo "No packages to remove"
    fi
fi

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

# Deploy SSH Server Config
# ========================

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SSHD_CONFIG_SRC="$DOTFILES_DIR/etc/ssh/sshd_config"
SSHD_CONFIG_DEST="/etc/ssh/sshd_config"

echo "Deploying sshd_config..."
if [ -f "$SSHD_CONFIG_DEST" ] && diff -q "$SSHD_CONFIG_SRC" "$SSHD_CONFIG_DEST" &> /dev/null; then
    echo "sshd_config is already up to date"
else
    sudo cp "$SSHD_CONFIG_SRC" "$SSHD_CONFIG_DEST"
    echo "sshd_config deployed to $SSHD_CONFIG_DEST"
fi

# Remove weak DH moduli (require >= 3072-bit)
if [ -f /etc/ssh/moduli ]; then
    if awk '$5 < 3071 { found=1; exit } END { exit !found }' /etc/ssh/moduli 2>/dev/null; then
        echo "Removing weak Diffie-Hellman moduli..."
        awk '$5 >= 3071' /etc/ssh/moduli | sudo tee /etc/ssh/moduli.tmp > /dev/null
        sudo mv /etc/ssh/moduli.tmp /etc/ssh/moduli
        echo "Weak moduli removed"
    else
        echo "DH moduli already hardened"
    fi
fi

# Ensure sshd is disabled (use ssh-start/ssh-end for on-demand access)
if systemctl is-enabled sshd.service &> /dev/null; then
    echo "Disabling sshd.service (use ssh-start/ssh-end for on-demand access)..."
    sudo systemctl disable sshd.service
    echo "sshd.service disabled"
else
    echo "sshd.service is already disabled"
fi

# Deploy NetworkManager Dispatcher: WiFi/Wired Exclusive
# ======================================================

NM_DISPATCH_SRC="$DOTFILES_DIR/etc/NetworkManager/dispatcher.d/70-wifi-wired-exclusive.sh"
NM_DISPATCH_DEST="/etc/NetworkManager/dispatcher.d/70-wifi-wired-exclusive.sh"

echo "Deploying NetworkManager WiFi/wired-exclusive dispatcher..."
if [ -f "$NM_DISPATCH_DEST" ] && diff -q "$NM_DISPATCH_SRC" "$NM_DISPATCH_DEST" &> /dev/null; then
    echo "WiFi/wired-exclusive dispatcher is already up to date"
else
    sudo cp "$NM_DISPATCH_SRC" "$NM_DISPATCH_DEST"
    sudo chown root:root "$NM_DISPATCH_DEST"
    sudo chmod 755 "$NM_DISPATCH_DEST"
    echo "WiFi/wired-exclusive dispatcher deployed"
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

# Enable Gammastep Indicator Service
# ==================================

echo "Configuring Gammastep indicator service..."
if systemctl --user is-enabled gammastep-indicator.service &> /dev/null; then
    echo "gammastep-indicator.service is already enabled"
else
    echo "Enabling gammastep-indicator.service..."
    systemctl --user enable --now gammastep-indicator.service
    echo "gammastep-indicator.service enabled and started"
fi
