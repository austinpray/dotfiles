# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment

These dotfiles cover two machines:

- **Arch Linux desktop** with Sway (Wayland compositor); package manager paru (AUR helper)
- **GCP devbox**: a headless Ubuntu VM with the `mixpanel/analytics` monorepo at `~/analytics`

Dotfiles directory: `~/dotfiles` on both.

## Installation

Run `./install.sh` from the dotfiles directory to:

1. Symlink dotfiles to home directory
2. Wire `shell/common.sh` into `~/.bashrc`
3. Install binenv and CLI tools (starship, gh, delta, dust), if `~/.use-binenv` exists
4. Run arch-linux.sh for system packages and Sway/Waybar setup, on Arch

The script is idempotent and detects its machine, so it is safe to re-run on either.

## Architecture

**Dotfile management**: Files listed in the `DOTFILES` array in `install.sh` are symlinked to `$HOME`. To add a new dotfile, add its path (relative to dotfiles dir) to this array. Desktop-only configs go in `DOTFILES_DESKTOP` instead, which is appended to `DOTFILES` only when pacman is present; a devbox has no compositor, terminal emulator or notification daemon to configure.

**Machine detection**: `IS_ARCH_DESKTOP` keys off pacman and gates the desktop configs and setup scripts. `shell/common.sh` keys off `~/.gcpdevbox`, the marker a devbox's provisioner drops, for choices that only differ there.

**Shell config lives in `shell/common.sh`**, not in an rc file. Both `.zshrc` and a marker block that `install.sh` appends to `~/.bashrc` source it, so bash on a devbox and zsh on the laptop get the same environment. `~/.bashrc` is not symlinked for the same reason `~/.gitconfig` is not: a devbox provisions that file and rewrites marked blocks inside it.

**`~/dotfiles/bin` is off PATH on a devbox**: `bin/gh` wraps the real `gh` to require a `.github-token.txt` in the cwd, which is what you want on a personal machine holding scoped per-project tokens. A devbox has one GitHub identity and monorepo tooling that shells out to `gh`, so the shadow only breaks things there. `ggh` reaches the real binary either way.

**The monorepo's `.shellenv` is sourced at most once per shell**: it bootstraps aqua, refreshes gcloud and cluster credentials and activates a virtualenv, so it is far too expensive to source twice. A devbox's own `~/.bashrc` already sources it, so `shell/common.sh` skips it when `AQUA_GLOBAL_CONFIG` is already exported.

**Directory configs**: Sway and Waybar configs are symlinked as directories by `scripts/arch-linux.sh`, not via the DOTFILES array.

**`.gitconfig` is not symlinked**: `install.sh` writes a real `~/.gitconfig` that `[include]`s the tracked one. Tools that run `git config --global` (`gh auth setup-git`, the gcpdevbox `configure-git-auth.sh`) write through a symlink, which would commit machine-local identity and carry a work email to every machine sharing these dotfiles. Keep identity out of the tracked file; put it in `~/.gitconfig` after the include. Re-running `install.sh` reads the existing `user.email`/`user.name` back out and rewrites them after the include, since the tracked config's `user.useConfigOnly` would otherwise leave git refusing to commit.

**Key config locations**:

- `shell/common.sh` - Shared bash/zsh environment
- `.config/sway/config` - Sway window manager
- `.config/waybar/config.jsonc` - Status bar
- `.config/mako/config` - Notifications
- `.config/ghostty/config` - Terminal (GitHub palette)

**Scripts**:

- `scripts/arch-linux.sh` - Package installation and system setup
- `scripts/discord.sh` - Discord installation
- `bin/` - Media conversion utilities (ffmpeg wrappers)
