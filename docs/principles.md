# Principles

Last revised: 2026-10-03

These rules cut across the whole project. Specs and decisions cite a rule by its
`PR-` ID instead of restating it. Each rule ends in a checkable form, so that a
reviewer can check compliance and not only agree with the intent.

## PR-0001. Derive rather than transcribe

A number in this project has two legal origins:

1. A tool reports it, and the script records the report. A language version comes
   from the toolchain's own version command, not from a release page.
2. A measurement produced it, and docs/measurements/ records the measurement.

A value copied by hand from a web page, a changelog or another benchmark into a
document is not compliant, even with a link next to it. A copied value does not
change when its source changes.

Checkable form: a number in a document either names the tool that reported it or
cites a metric ID from docs/measurements/reference.md. A number with neither does
not go into a document.

## PR-0002. The result comes from the code path that measured it

The measurement script writes the result file. A document cites the file. A table in
a document is a view of that file, and a reader can regenerate the table from it.

A result typed into a document by hand drifts from the run it describes, and the
citation does not show the drift.

Checkable form: every table of measured values in docs/ names the result file it was
derived from, and the file is in the repository or reproducible by a task.

## PR-0003. Report distributions, not verdicts

Throughput, latency and resource consumption are distributions over repeated runs.
The project reports them as such: the number of runs, the median, the spread, and
the tail percentiles the method defines.

"Meaningful" is a cut drawn on a distribution. The document that draws it shows the
distribution, states where the cut lies and why, and shows what moves when the cut
moves. A single number per language with no spread is not a result under this rule.

Checkable form: no measured value appears without its run count and spread. No
language ranking appears without the distributions it was drawn from.

## PR-0004. Reproducibility

Same inputs, same procedure, same tables. The rule applies at two levels.

The rule does not hold an observation, one run on one machine, to byte identity. It
holds the observation to carrying enough context for a third party to redo every
derivation taken from it: machine, operating system, language implementation and
version, framework and version, load generator and version, concurrency, duration,
warm up, run count, and the commit of this repository.

The full rule holds for everything derived from an observation. The same result file
fed through the same script produces the same table, byte identical. Timestamps,
hash set iteration order and unordered parallel output inside a derivation are
defects.

The audience does not know the authors and has no reason to trust them. The reader
can re-derive the numbers from files in the repository, on their own machine.

Checkable form: `task check` regenerates every derived table and fails on a diff.
Every campaign document names the environment row it ran under.

## PR-0005. Label borrowed choices as hypotheses

A project may start from a choice another project made. It may not present that
choice as a derived decision.

A choice adopted from elsewhere and not yet measured here carries an `HY-` ID from
docs/hypotheses.md, and every place that relies on it cites the ID. A claim that is
not in the registry may not be relied on.

A hypothesis retires when a measurement settles it. The change that lands the
measurement deletes the row and updates every site that cited the ID.

Unverified prior art is stricter still. It cannot support a decision at all, because
this project adopted nothing from it. See docs/prior-art.md.

Checkable form: every `HY-` citation resolves to a row in docs/hypotheses.md. Every
decision in docs/decisions/ names the measurements and hypotheses it rests on, and
nothing with status unverified.

## PR-0006. Measurements are machine specific

A number measured on one machine is that machine's number. Hardware differs in single
thread speed, core count, memory bandwidth and network stack, and a web server's
throughput scales differently against each.

Rules:

1. Values from two machines do not combine into one table without a label that says
   which value came from where.
2. A ratio between two languages is a property of the machine that produced it. It
   is not rescaled to another machine's total.
3. Every campaign names its environment row in docs/measurements/environments.md.
   The reference the project publishes is one machine's reference. The kit exists so
   that a reader can produce their own.

Checkable form: no table mixes environment rows without a column that names the row.

## PR-0007. The measured path holds no connector

A request in the measured path touches the language implementation, the framework
when the tier has one, and the operating system, and nothing else. No database, no
authentication provider, no cache, no message broker, no outbound call.

A driver, a connection pool or a serialisation library for an external service
measures that library and the service. docs/objective.md keeps them out of scope.
Viitanen 2025 in docs/prior-art.md shows what happens otherwise: the one scenario
without a database showed no difference, and the author traced the differences in
the other to the ORM and the database.

Checkable form: during a run the process under test opens no network connection
other than the ones the load generator opened to it. The method records how this was
checked.

## PR-0008. Pin versions at the cutoff date

Each campaign names a cutoff date. Each implementation runs on the latest released
major.minor.patch of its language implementation at that date, and in the framework
tier on the latest released version of the framework at that date.

A campaign may use a version other than the latest when its document says which
version, why, and what the latest was. Older versions are an open question in
docs/objective.md and enter only under their own campaign.

The implementation is the unit, not the language. Van Kempen et al. in
docs/prior-art.md separate the two. A result for "Java" names the runtime it ran on.

Checkable form: the result file records the version string the toolchain printed,
per PR-0001. The campaign document records the cutoff date. The two agree, or the
document explains the gap.

## PR-0009. Every implementation passes the same conformance suite before measurement

One specification describes the workload. One conformance suite checks it. An
implementation that fails the suite is not measured, and a measurement taken from
one by mistake is not a result.

The suite is the only definition of "the same application". Without it, a faster
implementation may be one that does less.

Checkable form: the measurement task refuses to run against an implementation whose
last conformance run did not pass at the commit under test.

## PR-0010. The implementer is a recorded variable

Prechelt 2000 in docs/prior-art.md found that differences between programmers within
one language exceed differences between languages. A comparison that does not record
who wrote each implementation cannot tell the two apart.

Each implementation records who or what wrote it: a person, or an agent with its
model and the date, and the prompt or specification it worked from. It records the
time spent and the number of revisions. A table that compares implementations with
different implementers says so in the table.

Checkable form: every implementation directory holds a provenance file with these
fields. The derived tables carry an implementer column or state that it is constant.

## PR-0011. Partial results say what is missing

A campaign over many languages and two tiers will have gaps: a toolchain that did not
install, a run that failed, an implementation that missed the cutoff. Stopping at the
first gap makes the campaign useless. Continuing without a note produces a table
that looks complete and is not.

Rules:

1. The script that skipped an item counts it and lists it with the reason, per
   PR-0002.
2. A table built from an incomplete campaign carries an incomplete mark in the
   table.
3. A number derived from a partial campaign states its denominator.

Checkable form: the result file has a skipped section, and the derived table shows it.

## Cost

PR-0001 and PR-0002 together cost more than typing numbers into a table. Every number
needs a script behind it, so the measurement scripts have to exist before the first
campaign.

PR-0009 and PR-0010 cost the most at the moment they apply. PR-0009 blocks a
measurement when someone wants a result, and PR-0010 asks for a provenance file when
the code already works. Both are easy to skip, so both are a gate and a required file
instead of a judgement call.

PR-0007 excludes the part of a web application most people consider essential, on
purpose. A result that includes the connector answers a different question than the
one in docs/objective.md.

The project accepts the cost. The alternative is a ranking the reader cannot check.
docs/prior-art.md lists several.
