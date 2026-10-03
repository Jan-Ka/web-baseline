# web-baseline

Does the base language have a meaningful effect on how a web application performs,
and how large is that effect? This project answers that with a test that is
repeatable and representative. The same workload runs in each language, in two
tiers: the language alone, and the language with the framework its community treats
as essential. The measurement is requests per second and resource consumption.

The measured path holds no database, no authentication and no other connector. A
test that includes them compares connector implementations as much as languages.
The result covers the base language alone, and the recommendation says so.

The full statement is in [docs/objective.md](docs/objective.md).

## How the project reasons

- Every number in a document names the tool that reported it or cites a
  measurement recorded in this repository.
- Every decision names the evidence it rested on.
- Prior art cannot support a decision while its status is unverified.
- A claim the project relies on without a measurement is a registered hypothesis,
  written down before the measurement.
- Numbers are machine specific and come with their spread. A single number per
  language is not a result.

The rules, each with a checkable form, are in [docs/principles.md](docs/principles.md).

## Documents

- `docs/` holds the foundation: [objective](docs/objective.md),
  [principles](docs/principles.md), [glossary](docs/glossary.md),
  [prior art](docs/prior-art.md) and [hypotheses](docs/hypotheses.md).
- `docs/decisions/` holds one file per decision, with the data it rests on.
- `docs/research/` holds desk research that decisions draw on.

## Status

Decided: which languages enter the comparison (DE-0001) and the workload, a small
marketplace driven by user flows (DE-0002). Open: the implementations per language,
the tiers, and what size of difference counts as meaningful.

## Reproducing the reference

The reference is the published set of measured numbers. This repository is the kit
to reproduce it on another machine. The kit arrives with the first measurement
campaign. Until then there is nothing to run.

## Working in this repository

You need [git](https://git-scm.com/) and [Task](https://taskfile.dev/). Then:

```sh
task setup    # hooks, secrets, MCP servers, skills
task check    # markdown format and lint, package audit, what CI gates on
```

`main` only accepts signed commits. Machine specific files never reach a commit, and
the hooks in `.githooks/` enforce both. Documentation follows ASD-STE100 Simplified
Technical English. [docs/setup.md](docs/setup.md) has the details.

## License

MIT. See [LICENSE](LICENSE).
