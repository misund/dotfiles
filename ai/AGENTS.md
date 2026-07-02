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

- **Multi-line function calls when long or many arguments.** Split a function
  call across multiple lines (one argument per line, trailing comma) when the
  call *either* exceeds a line length of 80 characters *or* has three or more
  arguments. Otherwise keep it on a single line.

  ```go
  // Three or more arguments -> multiline:
  pool, err := NewWithConfig(
  	ctx,
  	cfg,
  	otelpgx.WithTracerProvider(tp),
  )

  // Over 80 characters -> multiline (even with two arguments):
  result, err := doSomethingWithAVeryLongName(
  	someRatherLongArgumentName,
  	anotherRatherLongArgumentName,
  )

  // Short and few arguments stay single-line:
  addTimeZone(conn)
  ```

- **Multi-line deeply nested function calls.** When function calls are nested
  three layers or more, split them across multiple lines instead of keeping
  them on one line, so the call structure stays readable.

  ```go
  // Three or more layers of nesting -> multiline:
  a(
  	b1(
  		c(),
  		c2(),
  	),
  	b2(
  		d1(),
  		d2(),
  	),
  )

  // One or two layers stay single-line (subject to the length/arg-count rule
  // above):
  a(b1(), b2())
  ```
