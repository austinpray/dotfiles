---
name: dotfile-installer
description: Install and manage dotfiles in this repository. Use when adding a new config file to be tracked, symlinking a dotfile, or modifying which files are managed by the dotfiles repo.
---

# Installing Dotfiles

## Adding a new dotfile

1. Place the file in the dotfiles repo at its path relative to `$HOME` (e.g., `.config/foo/config` goes in `~/dotfiles/.config/foo/config`)

2. Add the path to the `DOTFILES` array in `install.sh`:
   ```bash
   DOTFILES=(.gitignore_global .vimrc ... .config/foo/config)
   ```

   If the config only makes sense in front of a monitor (compositor, terminal,
   notifications, dictation), add it to `DOTFILES_DESKTOP` instead. That array
   is folded into `DOTFILES` only on an Arch desktop, so a headless devbox does
   not collect symlinks to configs nothing there reads.

3. Run `./install.sh` to create the symlink

## Shell configuration

Shell environment goes in `shell/common.sh`, which both `.zshrc` and a marker
block in the machine-local `~/.bashrc` source. Put anything shell-specific
(zsh keybindings, bash completion) in the rc file instead, and gate anything
devbox-specific on `[ -f "$HOME/.gcpdevbox" ]`.

## Directory configs (Sway, Waybar)

Sway and Waybar configs are symlinked as entire directories by `scripts/arch-linux.sh`, not via the DOTFILES array. To add a new directory-based config, add symlinking logic to `scripts/arch-linux.sh` following the existing pattern.
