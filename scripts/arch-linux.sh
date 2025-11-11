#!/bin/bash
set -euo pipefail

PACKAGES=()

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
