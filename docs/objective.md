# Objective

Last revised: 2026-10-03

## Problem

Does the base language have a meaningful effect on how a web application performs,
and how large is that effect? This project answers that with a test that is both
repeatable and representative.

Existing comparisons include databases and authentication in the workload. In our
view such a test measures two things at once. It compares connector implementations
as much as it compares languages.

## Question

Two things, measured on a repeatable and representative test:

1. Does the base language have a meaningful effect?
2. How large is that effect?

"Base language" means the language together with the language implementation it
runs on, at the latest released major.minor.patch version on the cutoff date of the
measurement. "Java" alone is not a base language. "Java on OpenJDK 26.0.1" is. See
docs/glossary.md.

## What the comparison measures

The primary outcome is requests per second and resource consumption in general.

The ecosystem counts as part of the language. Some major languages produce a binary
that needs nothing from the operating system. Others need a runtime. That alone might
cause large differences, so the comparison records it.

The comparison measures each language in two tiers:

1. The language without any framework.
2. The language with the framework its community treats as essential for web apps.
   Spring Boot is one example.

Two further questions belong to the comparison:

- Which metrics do people usually use to compare languages in this context, including
  the metrics that are wrong for it?
- Are there essential changes one has to make to improve a language's result, and how
  much do they change it?

## Success criteria

1. A reference exists: the measured numbers per language and tier, with the version,
   the cutoff date and the machine recorded.
2. This repository is the kit to remeasure the reference. The documentation and the
   tooling are sufficient when the author can run the whole measurement from them
   alone. If the author can, an average programmer can.
3. A recommendation exists. It states that it covers the language alone.

## Audience

The public. Technically interested people, people who hold strong opinions about
languages, and whoever looks for this information.

## Non-goals

- Database and connector performance.
- Authentication libraries.
- Developer productivity and developer experience.
- Which framework is best within one language.
- Frontend and mobile development.

## Open questions

- What a proper comparison encompasses. This is the first piece of work. It decides
  what "representative" means here and which workload stays outside the test.
- Whether older versions enter the comparison, for example to show whether a gap
  closed over time.
- Which languages enter the comparison, and by which rule.
- What size of difference counts as meaningful.
