# dotfiles

My dotfiles. Use at will. Lots of it is taken directly from Paul Irish at https://github.com/paulirish/dotfiles

Targets **Ubuntu** and assumes `apt`, `snap`, and `GNOME` are available. Other distros are not supported.

## Setup

Run the two scripts in order on a fresh system:

```sh
./system_setup.sh  # 1. install packages and tools
./install.sh        # 2. symlink dotfiles into place
```

### `system_setup.sh`

Interactively installs command line tools (git, vim, tmux, stow, jq, docker, terraform, gh, gcloud, ...),
optionally installs programming language toolchains (nvm/node, go, gostyle, bun), optionally installs GUI apps
(browsers, VS Code, Slack, Spotify, GNOME tweaks, ...) via `apt`/`snap`, and applies some GNOME/terminal
preferences (dark theme, terminal color scheme, Ptyxis config). Each step prompts before installing
anything, so it's safe to re-run and skip what you already have.

### `install.sh`

Uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink each top-level package directory into
`$HOME`:

- `bash` – bashrc, profile, prompt, aliases, completions
- `config` – XDG config files (starship, ptyxis, tiling-assistant)
- `git` – gitconfig(s)
- `misc` – misc dotfiles (e.g. `.less_colors`)
- `ssh` – ssh config and public keys
- `tmux` – tmux config
- `vim` – vimrc and vim plugins (also wires up Neovim via symlinks)
- `vscode` – VS Code settings, keybindings, and extensions

It also clones [`git-whoami`](https://github.com/petere/git-whoami) into `stow-bin/bin/`, sets up Vim
directories and Pathogen plugins, wires Neovim to the Vim config, installs yarn bash completion, and
installs the local `dotfiles-sync` VS Code extension if `code` is available. Stow refuses to overwrite
existing files, so remove/backup conflicts first, or pass `--adopt` to merge them into this repo.

### Uninstall

Remove the symlinks with:

```sh
stow -D -t ~ bash git vim tmux ssh misc config stow-bin
```
