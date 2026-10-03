# Glossary

Last revised: 2026-10-03

One meaning per term, used the same way in every document. The list uses the
definition list syntax of Markdown Extra: a term on one line, its definition on the
next, led by a colon. GitHub renders it as plain text. A term whose meaning is
still open says so and points to the open question in docs/objective.md.

## The subject

Base language
: A language together with the language implementation it runs on, at the version
PR-0008 pins. "Java" alone is not a base language. "Java on OpenJDK 26.0.1" is.

Language implementation
: The compiler or runtime that executes the code: CPython, OpenJDK, the Go
toolchain, Node.js, Bun. Two implementations of one language are two subjects.
Results name the implementation.

Runtime
: The part of a language implementation that must exist on the host when the
application runs. A self contained binary needs none. An application on the JVM,
Node.js or CPython needs one.

Deployment form
: Whether an implementation is a self contained binary or needs a runtime on the
host. Recorded per implementation. See HY-0002.

Ecosystem
: The compilers, runtimes, frameworks and libraries around a language. The
objective treats it as part of the base language where it affects the measured
path or the deployment form, and out of scope elsewhere.

Server
: The program that accepts HTTP and hands requests to the code, such as php-fpm,
Kestrel or Tomcat. Not a subject. Each tier uses the server its rule names.
DE-0003.

Tier
: One of three ways to implement the workload for a subject. The standard library
tier uses the language distribution alone. The micro library tier adds one
lightweight library. The full framework tier uses one full framework. A subject
appears at most once per tier. DE-0003.

Micro library
: A library that gives routing, request parsing and response helpers, without the
structure of a full framework. One per subject. DE-0003 names them.

Full framework
: A framework that adds structure such as dependency injection, conventions or an
ORM. One per subject, where the community has one. DE-0003 names them.

Implementer
: The person or agent that wrote an implementation. A recorded variable per
PR-0010. The provenance file names an agent with its model and the date.

Provenance file
: The file in each implementation directory that records the implementer, the
specification used, the time spent and the number of revisions. PR-0010 requires
it.

## The test

Workload
: The application every implementation builds and the user flows the load
generator runs against it. SP-0001 defines it for all subjects and tiers.
DE-0002.

Representative
: The property the workload must have. Each request passes through the parts a web
application runs in its own process, and the requests arrive in sessions, in the
order users produce them. DE-0002 lists the parts.

Conformance suite
: The tests that check an implementation against the workload specification. An
implementation that fails it is not measured. PR-0009.

Connector
: Any component in the request path that talks to something outside the process
under test: a database driver, an authentication provider, a cache client, a
message broker client, an outbound HTTP call. PR-0007 keeps connectors out of the
measured path.

Measured path
: The code a request passes through while the load generator runs. It holds the
language implementation, the framework when the tier has one, and the operating
system. PR-0007.

Load generator
: The tool that sends the workload and records throughput and latency. Named with
its version in every observation. HY-0005 concerns its own limit.

Meaningful
: The size of difference the recommendation treats as large enough to matter. A cut
drawn on a distribution per PR-0003. Where the cut lies is an open question in
docs/objective.md.

## The measurement

Cutoff date
: The date a campaign names. Every implementation runs on the latest released
major.minor.patch of its language implementation at that date, and in the
framework tier on the latest released framework version at that date. PR-0008.

Campaign
: One measurement run over a set of implementations under one cutoff date on one
environment, recorded in a dated document under docs/measurements/.

Environment
: One machine and operating system, described in one row of
docs/measurements/environments.md. Every campaign names its row. PR-0006.

Observation
: One run on one environment: the raw result file the measurement script writes.
Held to carrying full context, not to byte identity. PR-0004.

Derivation
: Anything computed from observations: a table, a ratio, a chart. Held to byte
identity under the same inputs and the same script. PR-0004.

Spread
: The variation of a measured value across repeated runs, reported with the median
per PR-0003. Also the variation across frameworks within one language, or across
languages within one tier, where the text says which.

Method
: A description of what one measurement measures, what it does not, and how to
repeat it. One file per method under docs/measurements/methods/.

Metric ID
: The identifier of one measured value in docs/measurements/reference.md. The
citation target for every number per PR-0001.

## The output

Reference
: The published set of measured numbers per language and tier, with version, cutoff
date and environment. One campaign's output. Success criterion 1 in
docs/objective.md.

Kit
: This repository, as the means to reproduce the reference on another machine.
Success criterion 2 in docs/objective.md.

Recommendation
: The document that states what the measurements support, with the caveat that it
covers the base language alone. Success criterion 3 in docs/objective.md.

## Identifiers

| Prefix | Meaning                                 | Lives in                          |
| ------ | --------------------------------------- | --------------------------------- |
| PR-    | A principle                             | docs/principles.md                |
| HY-    | An untested hypothesis                  | docs/hypotheses.md                |
| DE-    | A decision, with the data it rested on  | docs/decisions/                   |
| SP-    | A specification of one part of the test | specs/                            |
| MM-    | A measurement method                    | docs/measurements/methods/        |
| EN-    | An environment, one machine             | docs/measurements/environments.md |
| VM-    | A measured value                        | docs/measurements/reference.md    |

An ID does not change when its file moves. Cite the ID, not the path.
