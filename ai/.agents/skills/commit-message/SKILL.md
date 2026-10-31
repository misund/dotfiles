---
name: commit-message
description: >-
  Write git commit messages in the house style: conventional-commits subject
  and prose body explaining context, change, and design reasoning. Use whenever
  you are about to create or amend a commit, or draft a commit message.
---

# Commit messages

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
  (`InvoiceGetter`, `ports.InvoiceReader`) instead of vague references, but
  keep each paragraph to 2-4 sentences. No filler like "this commit also".
- Don't restate the diff; explain the reasoning the diff doesn't show.
- No AI co-author trailers (e.g. `Co-authored-by: Copilot`).

Example:

```
fix(billing): adapt invoice export to narrowed reader ports

origin/main moved the HTTP handlers onto narrow, handler-local reader
interfaces backed by invoice.Service, instead of depending on
ports.InvoiceReader directly. exporter.ByCustomer took
ports.InvoiceReader plus an IncludeDrafts flag, which no longer compiles
against those interfaces and re-couples the handlers to ports.

Change ByCustomer to take an InvoiceGetter function value instead, so
exporter depends only on domain and never dictates which reader method
a handler may call. The public handler passes GetPaidInvoices directly:
its interface has no drafts method, so the compiler now enforces the
no-drafts guarantee that a test previously checked at runtime. Internal
handlers keep selecting the method from scopes, passing the method value
instead of a flag.

Test fakes are updated to match: exporter's tests use plain getter
closures, and the public handler's fake implements its narrow interface
directly.
```
