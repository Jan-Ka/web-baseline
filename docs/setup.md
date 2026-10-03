# Setup

Last revised: 2026-10-03

How to prepare a clone of this repository for work on it. A reader who only wants to
rerun a measurement does not need this page. The README points to what they need.

## Tools

You need two tools:

- [git](https://git-scm.com/)
- [Task](https://taskfile.dev/)

Three tools are optional. [pnpm](https://pnpm.io/) serves `task lint`, `task fmt` and
`task audit`.
[Claude Code](https://docs.anthropic.com/en/docs/claude-code) serves
`task setup:mcp`, which registers the MCP servers for it. The
[1Password CLI](https://developer.1password.com/docs/cli/) serves
`task setup:secrets`. Run `task check:prereqs` to see which tools are missing.

Task runs every command in its own POSIX shell on Windows, macOS and Linux. The same
`Taskfile.yml` and the same scripts work on all three. You do not need a separate
PowerShell or Bash version.

## First run

Create `.env`. `.gitignore` covers it. Pick one way:

- By hand: copy `.env.example` to `.env` and fill in the values.
- With 1Password: copy `.env.example` to `.env.1password` and replace each empty
  value with an `op://<vault>/<item>/<field>` reference. Sign in with `op signin`.
  `task setup` then writes `.env` for you.

Then run:

```sh
task setup
```

`task setup` does five things:

1. It checks the tools above.
2. It activates the git hooks in `.githooks/`.
3. It writes `.env` from `.env.1password` when that file exists. Otherwise it keeps
   your `.env`.
4. It registers the Claude Code MCP servers for this project when Claude Code is
   installed. Otherwise it skips this step with a note. The registration holds no
   token. It names `task mcp:headers` as the headers helper.
5. It installs the pinned Claude Code skills into `.claude/skills/`.

If a 1Password lookup fails, run `SETUP_VERBOSE=1 task setup:secrets` to see the
raw error. The default output hides it, because it repeats the vault and item name.

Run `task` without arguments to list all tasks.

## Local files

Machine specific setup never reaches a commit:

- `.gitignore` covers `.env` and `.env.1password`. `.env.example` documents the
  variables. `.env` is the source of truth. 1Password is one optional way to write
  it.
- `task setup:mcp` writes the MCP registrations to the project-local Claude Code
  config under your user profile, not to this repository. The registration holds
  no token. Claude Code runs `task mcp:headers` on every connection, and that task
  reads the tokens from `.env` at that moment. A rotated token in `.env` takes
  effect on the next connection.
- `.gitignore` covers agent and editor workspace files. This includes `CLAUDE.md`,
  `.claude/`, `.mcp.json` and `.vscode/`.
- The pre-commit hook rejects these paths if someone stages them anyway. It also
  rejects added lines that look like credentials, and prints only a masked prefix.
- The commit-msg hook rejects AI attribution trailers in commit messages.

The hooks live in `.githooks/`. `task setup:hooks` activates them with
`git config core.hooksPath .githooks`.

## Signed commits

`main` only accepts signed commits. Three layers enforce this:

1. The pre-commit hook rejects a commit when `commit.gpgsign` is off, or when SSH
   signing has no `user.signingkey`.
2. The pre-push hook rejects a push that contains a commit without a signature
   header. It does not check that the signature is valid.
3. A GitHub ruleset on `main` requires valid signatures, requires a linear history,
   and blocks force pushes and deletion. Repository admins can bypass it.

GitHub checks signatures against the keys on your account. Add your signing key
there first. See the GitHub guide on
[commit signature verification](https://docs.github.com/authentication/managing-commit-signature-verification).
`task setup:hooks` also sets `tag.gpgsign` for this repository.

## Markdown lint and format

The documents are part of the product, so they get the same treatment as source.

```sh
task fmt      # prettier, aligns tables
task lint     # markdownlint-cli2
task audit    # pnpm audit, known advisories in the pinned packages
task check    # what CI gates on: fmt:check, lint and audit
```

`package.json` and `pnpm-lock.yaml` pin both tools. The tasks install them into
`node_modules/` on first use. `.gitignore` covers that directory.

Since pnpm 12, Dependabot does not see the packages in `pnpm-lock.yaml`. `task audit`
does this check locally. `pnpm-workspace.yaml` holds the advisories that it ignores.
Add an advisory there only when no patched release exists.

## Writing style

Documentation and code comments follow ASD-STE100 Simplified Technical English in its
STE-flavored mode. That means short sentences, active voice, one instruction per
sentence, and no semicolons. `task setup:skills` installs the
[asd-ste100 skill](https://github.com/danyuchn/asd-ste100-skill) for Claude Code.
