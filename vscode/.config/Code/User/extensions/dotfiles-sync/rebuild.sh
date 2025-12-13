#!/bin/bash
# Rebuild and reinstall the dotfiles-sync extension

set -e

cd "$(dirname "$0")"

echo "Building extension..."
npm run package

echo "Installing extension..."
npm run install

echo "✓ Extension rebuilt and installed!"
echo "  Reload VS Code to activate the updated extension"
