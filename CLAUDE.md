# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment

- Arch Linux with Sway (Wayland compositor)
- Package manager: paru (AUR helper)
- Dotfiles directory: ~/dotfiles

## Installation

Run `./install.sh` from the dotfiles directory to:
1. Symlink dotfiles to home directory
2. Install binenv and CLI tools (starship, gh, delta, dust)
3. Run arch-linux.sh for system packages and Sway/Waybar setup

## Architecture

**Dotfile management**: Files listed in the `DOTFILES` array in `install.sh` are symlinked to `$HOME`. To add a new dotfile, add its path (relative to dotfiles dir) to this array.

**Directory configs**: Sway and Waybar configs are symlinked as directories by `scripts/arch-linux.sh`, not via the DOTFILES array.

**Key config locations**:
- `.config/sway/config` - Sway window manager
- `.config/waybar/config.jsonc` - Status bar
- `.config/mako/config` - Notifications

**Scripts**:
- `scripts/arch-linux.sh` - Package installation and system setup
- `scripts/discord.sh` - Discord installation
- `bin/` - Media conversion utilities (ffmpeg wrappers)
