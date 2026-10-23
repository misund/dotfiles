## Commit messages

- **Subject**: `type(scope): summary`, imperative mood, no trailing period.
  `type` is conventional-commits style (`feat`, `fix`, `refactor`, `chore`,
  ...); `scope` is the package or component most affected.
- **Body**: prose paragraphs, no bullet lists, wrapped at ~72-80 columns.
  Each paragraph does one job:
  1. **Context/problem** — what state the code was in and why it needed to
     change (a stub, a conflicting refactor upstream, a bug). Name the
     concrete types/functions involved, not just "the code".
  2. **What changed** — the actual change, described at the level of
     types/functions/files, not a line-by-line diff narration.
  3. **Why this shape** — the design reasoning: why this approach over an
     obvious alternative, what invariant it now enforces, what it decouples.
  4. *(optional)* **Notable side effects** — behaviour changes, test
     changes, or trade-offs a reviewer would otherwise have to spot
     themselves (e.g. "error message changed from X to Y", "a runtime check
     became a compile-time one").
- Favor precision over completeness: mention concrete identifiers
  (`CustomerGetter`, `ports.CustomerReader`) instead of vague references, but
  keep each paragraph to 2-4 sentences. No filler like "this commit also".
- Don't restate the diff; explain the reasoning the diff doesn't show.
- No AI co-author trailers (e.g. `Co-authored-by: Copilot`).

Example:

```
fix(orders): adapt checkout to the narrowed reader interface

The storage layer moved onto small, adapter-local reader interfaces
instead of the wide orders.Repository. checkout.LoadOrder still took
orders.Repository plus an includeDeleted flag, which no longer compiles
against those interfaces and ties the checkout code back to storage.

Change LoadOrder to take an OrderGetter function value instead, so
checkout depends only on the domain package and never dictates which
reader method a caller may use. The public handler passes GetOrder
directly: its interface has no deleted-order method, so the compiler now
enforces the guarantee that a test previously checked at runtime. Admin
handlers keep choosing the method from the caller's role and pass the
method value instead of a flag.

Test fakes are updated to match: checkout's tests use plain getter
closures, and the public handler's fake implements its narrow interface
directly.
```
