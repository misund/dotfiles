# Personal agent instructions

These instructions are shared across all coding agents (Claude Code, Codex,
opencode and GitHub Copilot). The single source of truth lives in the
`dotfiles` repo at `ai/AGENTS.md`; every agent's instructions file is a symlink
to it (see the repo's `install.sh`).

## Go code style

- **Multi-line function signatures for multi-parameter functions.** When a Go
  function has more than one parameter, list one parameter per line, and expand
  multi-value return lists so each return value is on its own line. Keep
  single-parameter functions on a single line.

  ```go
  func NewWithConfig(
  	ctx context.Context,
  	cfg *pgxpool.Config,
  	opts ...otelpgx.Option,
  ) (
  	*pgxpool.Pool,
  	error,
  ) {
  	// ...
  }

  // Single-parameter functions stay single-line:
  func addTimeZone(conn *pgx.Conn) error {
  	// ...
  }
  ```
