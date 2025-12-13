#!/bin/bash
# Install VS Code extensions from the backup list

set -euo pipefail

# Get the extension root directory
EXT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
EXTENSIONS_FILE="$EXT_DIR/var/code-extensions.bkp"

if [[ ! -f "$EXTENSIONS_FILE" ]]; then
    echo "Error: Extensions file not found at $EXTENSIONS_FILE"
    exit 1
fi

if ! command -v code &> /dev/null; then
    echo "Error: VS Code is not installed or 'code' command is not in PATH"
    exit 1
fi

echo "Installing VS Code extensions from backup..."
while IFS= read -r extension; do
    [[ -z "$extension" ]] && continue
    echo "Installing: $extension"
    code --install-extension "$extension" --force
done < "$EXTENSIONS_FILE"

echo ""
echo "✓ VS Code extensions installation complete!"
echo "  Installed: $(wc -l < "$EXTENSIONS_FILE") extensions"
