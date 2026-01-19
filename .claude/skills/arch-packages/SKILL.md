---
name: arch-packages
description: Install or remove Arch Linux packages declaratively. Use when adding a package to install, removing a package, or managing system packages via paru.
---

# Managing Arch Linux Packages

Packages are managed declaratively in `scripts/arch-linux.sh`. Running the script installs missing packages and removes unwanted ones.

## Installing a package

Add the package name to the appropriate `PACKAGES` array section in `scripts/arch-linux.sh`:

```bash
# Example sections:
PACKAGES=(...)           # Core packages
PACKAGES+=(...)          # Desktop apps
PACKAGES+=(...)          # Sway-related
PACKAGES+=(...)          # Speech Recognition
PACKAGES+=(...)          # Fonts
```

Choose the section that best fits the package's purpose, or create a new section with a comment header.

## Removing a package

Add the package name to the `REMOVE_PACKAGES` array in `scripts/arch-linux.sh`:

```bash
REMOVE_PACKAGES=(
    package-to-remove
    another-package
)
```

The script uses `paru -Qe` to check if the package is explicitly installed (not a dependency), then removes it with `paru -Rs` to also clean up orphaned dependencies.

## Running the script

```bash
./scripts/arch-linux.sh
```

Or run the full install:

```bash
./install.sh
```
