#!/bin/bash
# Export currently installed VS Code extensions to the dotfiles repo

set -euo pipefail

# Find the dotfiles repo by following the User directory symlink created by Stow
USER_DIR="$HOME/.config/Code/User"
if [ -L "$USER_DIR" ]; then
  # User dir is a symlink - follow it to find dotfiles
  DOTFILES_VSCODE="$( cd "$( dirname "$( readlink -f "$USER_DIR" )" )" && pwd )"
else
  # User dir exists but isn't a symlink - find the extensions dir within it
  DOTFILES_VSCODE="$USER_DIR"
fi

EXTENSIONS_FILE="$DOTFILES_VSCODE/extensions/dotfiles-sync/var/code-extensions.bkp"

# Export extensions list (excluding this local extension)
echo "Exporting VS Code extensions..."
code --list-extensions | grep -v "^misund.dotfiles-sync$" > "$EXTENSIONS_FILE"

echo "✓ VS Code extensions list updated at $EXTENSIONS_FILE"
echo "  Extensions exported: $(wc -l < "$EXTENSIONS_FILE")"
