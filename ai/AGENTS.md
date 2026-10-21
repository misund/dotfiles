# Personal agent instructions

These instructions are shared across all coding agents (Claude Code, Codex,
opencode and GitHub Copilot). The single source of truth lives in the
`dotfiles` repo at `ai/AGENTS.md`; every agent's instructions file is a symlink
to it (see the repo's `install.sh`).

## Go code style

Put each item on its own line (with a trailing comma) instead of one line when:

- **Function signatures** have more than one parameter — expand multi-value
  return lists the same way. Single-parameter signatures stay inline.
- **Function calls** have three or more arguments, exceed 80 columns, or nest
  function calls three or more layers deep. When such nesting is split, split
  its inner calls too. Shorter, shallower calls stay inline.

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

func addTimeZone(conn *pgx.Conn) error { /* single param stays inline */ }

logger.ConfigureGlobalLogger(
	logger.WithHook(
		loghook.NewHook(),
	),
	logger.WithLevel(logger.LevelInfo),
)

addTimeZone(conn) // short, shallow, few args -> inline
```

## Git

- **Do not add a `Co-authored-by: Copilot` trailer** (or any AI co-author
  trailer) to commit messages.
