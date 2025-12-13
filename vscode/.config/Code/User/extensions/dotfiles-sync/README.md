# Dotfiles Sync Extension

This local VS Code extension automatically backs up your installed extensions list to your dotfiles repository.

## Files

- `update-vscode-extensions.sh` - Exports current extensions to backup file
- `install-vscode-extensions.sh` - Restores extensions from backup file
- `code-extensions.bkp` - List of installed extensions

## Installation

This extension is automatically symlinked when you run the dotfiles install script.

## Manual Usage

```bash
# Backup extensions manually
./update-vscode-extensions.sh

# Restore extensions
./install-vscode-extensions.sh
```
