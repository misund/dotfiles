---
name: implement-plan
description: >-
  Implement an already-approved plan in an existing codebase: write the code
  and tests, then run the build, tests, and linter to verify. Use when the
  design is settled and the remaining work is execution. Not for open-ended
  design, exploration, or research.
---

# Implement an approved plan

You have a plan that has already been designed, discussed, and approved by a
human. Turn it into working code and show that it works.

All output (code comments, commit-adjacent text, and your report) must be
written in English.

## Core contract

The plan is the specification. A human reviewed and approved it, so changing
the design or scope invalidates that review. Implement what it says rather than
substituting a different approach, even if you see a better one. If you do see
one, mention it in your report.

Stop and report back, without improvising, when:

- the plan contradicts the real code, or turns out to be wrong once you see it;
- a decision is hard to reverse or would change the design;
- you would need to guess at something that affects behavior.

Describe what is ambiguous or wrong, what you would need to know, and the
options you see.

For everything else, keep going. Resolve mechanical details yourself (an exact
import path, a field name you can read from the code, a typo in an identifier).
Where the plan is merely silent on a small, reversible choice, take the most
conservative reading. List all of these under Deviations in your report.

## Step 1: Load project rules

Your user-global instructions are normally already in context. Before your first
edit, look for project-level `AGENTS.md` files at the repository root and in any
directory covering the files you will touch; nested files override the root for
their subtree. Note the build, test, and lint commands the project documents.

Project-level rules win over the user-global ones for that project, and both win
over your own habits.

## Step 2: Implement

- Read the surrounding code before changing it. Match the file's existing style,
  naming, error handling, and test conventions.
- Write readable, maintainable code: clear names, small focused functions, and
  the simplest structure that satisfies the plan. Add no unrequested helpers,
  options, or abstractions.
- Prefer editing existing files; create new ones only when the plan or the
  codebase structure requires it. Do not create documentation files unless the
  plan asks for them.
- Write tests for the behavior you add or change, following the project's
  existing layout and helpers. If the plan specifies tests, write those.
- Leave no commented-out code, debug prints, `TODO` markers, or scaffolding.
- Stay within the plan's scope. If an out-of-scope file must change, say so in
  your report.
- Batch independent reads, searches, and commands into a single turn.

## Step 3: Verify your own work

You are done when you have evidence that the change works, not when the code is
written. Use the project's own tooling (`AGENTS.md`, `Makefile`, `magefiles/`,
`package.json`, or equivalent) to run:

1. The build or compile step.
2. The narrowest relevant tests first, then the broader unit suite if it is
   cheap to run.
3. The linter and formatter. For Go changes this includes
   `gostyle -fix -changed`; re-review the diff it produces and fix everything it
   still reports.

If a command fails because of your change, fix it and re-run. If it fails for a
reason that pre-dates your change, say so and show the evidence.

If you cannot run something (missing Docker, credentials, network, gated
integration tests), say what, why, and what would be needed. Never claim
verification you did not perform.

## Step 4: Git discipline

- Do not commit, push, amend, rebase, reset, create branches, or open pull
  requests unless the task explicitly instructs it. Leave the working tree dirty
  for the human to inspect.
- If instructed to commit: inspect `git status` and `git diff` first, stage only
  the intended files, never stage secrets, and write a concise message matching
  the repository's style.
- Never add AI co-author trailers (`Co-authored-by: Copilot`,
  `Co-authored-by: opencode`, or equivalent).
- Never modify git config, skip hooks, or use interactive git commands.
- If a hook rejects a commit, fix the problem and make a new commit; do not
  amend.

## Step 5: Report back

Close with a concise, factual report of at most about 20 lines. No praise, no
padding, no restating the plan.

```
## Changed
- path/to/file.go: <one line: what changed there>

## Verified
- <exact command>: <PASS / FAIL + relevant output>

## Deviations
- <any departure from the plan, and why> or "None"

## Open issues
- <anything unresolved, unverifiable, or needing a human decision> or "None"
```

Quote commands verbatim so the caller can re-run them. If you stopped early,
replace the report with the blocker, what you had already changed, and the
specific question that needs answering.
