---
name: dotfile-installer
description: Install and manage dotfiles in this repository. Use when adding a new config file to be tracked, symlinking a dotfile, or modifying which files are managed by the dotfiles repo.
---

# Installing Dotfiles

## Adding a new dotfile

1. Place the file in the dotfiles repo at its path relative to `$HOME` (e.g., `.config/foo/config` goes in `~/dotfiles/.config/foo/config`)

2. Add the path to the `DOTFILES` array in `install.sh`:
   ```bash
   DOTFILES=(.gitconfig .gitignore_global ... .config/foo/config)
   ```

3. Run `./install.sh` to create the symlink

## Directory configs (Sway, Waybar)

Sway and Waybar configs are symlinked as entire directories by `scripts/arch-linux.sh`, not via the DOTFILES array. To add a new directory-based config, add symlinking logic to `scripts/arch-linux.sh` following the existing pattern.
