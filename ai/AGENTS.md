# Personal agent instructions

These instructions are shared across all coding agents (Claude Code, Codex,
opencode and GitHub Copilot). The single source of truth lives in the
`dotfiles` repo at `ai/AGENTS.md`; every agent's instructions file is a symlink
to it (see the repo's `install.sh`).

## Go code style

These rules apply to **every Go file** you write or change, in any repo, and
to test code and table-driven tests too. Apply them to new and changed code
only; do not reformat untouched code.

Put each item on its own line (with a trailing comma) instead of one line when:

- **Function signatures** have more than one parameter — expand multi-value
  return lists the same way. This includes func literals, func types and
  interface methods. `a, b int` counts as two parameters. Single-parameter
  signatures stay inline.
- **Function calls** have three or more arguments, exceed 80 columns (a tab
  counts as 4; calls with a single plain identifier or selector argument, like
  `len(x.y)`, are exempt), or nest function calls three or more layers deep (the call
  itself counts as one layer, so `a(b(c(x)))` is three). When such nesting is
  split, split its inner calls too, unless they take no arguments. Shorter,
  shallower calls stay inline.
- **Composite literals in tests** (table-driven test rows in particular) use
  keyed fields, one per line, rather than positional one-liners.

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

### Check before you finish

Before reporting Go work as done, run `gostyle -fix -changed` in the repo (install with
`go install github.com/misund/gostyle@latest`; source in `~/src/misund/gostyle`).
It rewrites
fixable violations of the rules above on changed lines only (re-review the
resulting diff), and reports the rest. Fix everything it still reports. If it is not
installed, review `git diff` against the rules by hand. When delegating Go work
to a subagent, tell it to follow this section and run the check.

## Git

- **Do not add a `Co-authored-by: Copilot` trailer** (or any AI co-author
  trailer) to commit messages.
