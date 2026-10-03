# Prior art

Last revised: 2026-10-03

This survey is desk research carried out on 2026-10-03. No entry was checked on
this machine. Each entry names its source page and the date of reading.

Every entry carries a status. Nothing here may support a decision while its status
is unverified.

| Value      | Meaning                                                              |
| ---------- | -------------------------------------------------------------------- |
| verified   | checked here, with the check recorded in docs/measurements/          |
| disproved  | checked here and found false, with the check recorded                |
| unverified | read from the source named in the entry, not checked on this machine |

## Benchmark suites

### TechEmpower Framework Benchmarks

[GitHub](https://github.com/TechEmpower/FrameworkBenchmarks),
[results](https://www.techempower.com/benchmarks/),
[blog](https://www.techempower.com/blog/)

Status: unverified

Read 2026-10-03 from the GitHub page. The repository carries the notice "This
repository was archived by the owner on Mar 24, 2026. It is now read-only." The README
does not state a reason. The README describes the tests as "plaintext responses, JSON
serialization, database reads and writes via the object-relational mapper (ORM),
collections, sorting, server-side templates, and XSS counter-measures". The named test
types are plaintext, JSON, single query, multiple queries, fortunes and updates.

The last round is Round 23. A TechEmpower blog post from 2026-03-16 refers to it. A
secondary source gives its release date as February 2025. That date is not checked
against TechEmpower.

Criticisms found in community threads, not checked here: the load tool wrk is subject
to coordinated omission, the ranking uses average latency, each run lasts 15 seconds,
and the results publish the best case per framework.

What it compares: frameworks, with a database behind most tests. What it isolates: not
the language. A language appears many times with different frameworks and different
ORM choices.

### The Computer Language Benchmarks Game

[site](https://benchmarksgame-team.pages.debian.net/benchmarksgame/index.html),
[how programs are measured](https://benchmarksgame-team.pages.debian.net/benchmarksgame/how-programs-are-measured.html)

Status: unverified

Read 2026-10-03 from the two pages above. It measures elapsed time as "the lowest
elapsed time from 12 BenchExec measurements", CPU time with a 95 percent confidence
interval from 11 measurements, peak memory, and the gzip size of the source file. It
clears file system caches and swap before each measurement and drops the first
measurement. The machine is "a quad-core 3.0GHz Intel i5-3330 with 15.8 GiB of RAM
and 2TB SATA disk drive; using Ubuntu 24.04". There are 11 benchmark programs.

The site calls its own tests micro benchmarks that are "far from realistic".

What it compares: language implementations on CPU-bound algorithms. What it isolates:
the language implementation, within the limits of one contributed program per
language. It does not cover a web workload.

### web-frameworks by the-benchmarker

[GitHub](https://github.com/the-benchmarker/web-frameworks),
[dashboard](https://web-frameworks-benchmark.netlify.app/result)

Status: unverified

Read 2026-10-03 from the README. It runs "minimal HTTP throughput and latency tests"
against three routes: `GET /` with an empty body, `GET /user/:id` that returns the id,
and `POST /user` with an empty body. The load runs as a closed loop over keep-alive
connections. The README names zrk as the load generator and refers to an open
discussion about a modern load generator. The README does not name the hardware.

Read 2026-10-03 from the dashboard. The current results are "Latest, 2026-09-30
(c1ea5e3)". Each row names the language with a version, the framework with a version,
and three requests per second figures. The column labels were not captured. The
hardware is not on the result page.

The first column shows this spread, highest and lowest framework per language:

| Language   | Highest                 | Lowest              | Ratio       |
| ---------- | ----------------------- | ------------------- | ----------- |
| javascript | morojs-engine, 280,980  | yume-server, 3,066  | about 90x   |
| nim        | caprese, 270,543        | scorper, 0          | undefined   |
| rust       | may_minihttp, 258,247   | summer-boot, 30,755 | about 8x    |
| java       | activej, 225,968        | struts2, 7,120      | about 30x   |
| go         | breeze, 213,956         | gramework, 26,014   | about 8x    |
| python     | peregrine-wsgi, 187,882 | django, 538         | about 350x  |
| php        | workerman, 182,035      | hleb2-swoole, 12    | over 10000x |

The top frameworks of javascript, nim, rust, dart, java, zig and go sit between
213,956 and 280,980, a span of about 1.3x. The lowest rows for python and php are far
below what a working server returns, so some rows likely measure a broken
configuration rather than the framework. The language versions are not uniformly
current: the table lists go 1.21 next to rust 1.98 and java 26.

What it compares: frameworks, with no database. What it isolates: closer to the
language than TechEmpower, but the unit is still the framework. The spread above is
the strongest indication in this survey that a framework ranking does not describe
the language.

### Energy Efficiency across Programming Languages

[2017 study page](https://greenlab.di.uminho.pt/?p=238),
[2021 journal version, PDF](https://web.fe.up.pt/~jacome/downloads/SCP21.pdf),
[2025 reanalysis, arXiv](https://arxiv.org/abs/2410.05460)

Status: unverified

Read 2026-10-03 from the study page and the arXiv abstract. Pereira et al. measured
runtime, memory and energy for "twenty seven well-known software languages" on "ten
different programming problems". The problems came from the Benchmarks Game. The main
claim is a ranking of languages by energy, with slower languages consuming more.

Van Kempen, Kwon, Nguyen and Berger, "It's Not Easy Being Green", ASE 2025, build a
causal model and separate language implementations from languages, application
specific implementations, active cores and memory activity. They report that "when
these factors are controlled for, notable discrepancies in prior work vanish" and
conclude that "the choice of programming language implementation has no significant
impact on energy consumption beyond execution time".

What it compares: languages on micro benchmarks. What the reanalysis adds: a list of
confounds that any language comparison has to control, and the warning that a ranking
reads as a causal claim even when the authors only measured an association.

## Same application in many languages

### RealWorld

[GitHub](https://github.com/gothinkster/realworld)

Status: unverified

Read 2026-10-03 from the README. "Every tutorial is built against the same API spec".
A shared end to end suite checks frontends. Backends that "pass the full API spec test
suite" are listed as spec compliant. "Over 100 implementations have been created". The
README names two active maintainers. A secondary source said the project stops
maintenance. The README does not say that.

What it compares: full stack implementations of a blog clone with authentication,
CRUD, relations and pagination. What it isolates: nothing. It is a learning resource,
not a measurement. The pattern of one spec plus one conformance suite is the part that
transfers.

### TodoMVC

[site](https://todomvc.com/)

Status: unverified

Read 2026-10-03 from mirrors of the README. The same todo application in many
JavaScript frameworks, so that a developer can "compare the syntax and structure of
different frameworks". The README itself says the application "offers a limited view
of what a framework may be capable of".

What it compares: frontend frameworks within one language, by reading the code. Out of
scope here.

### 7GUIs

[site](https://eugenkiss.github.io/7guis/)

Status: unverified

Read 2026-10-03 from the site. "A GUI Programming Benchmark" that "defines seven tasks
that represent typical challenges in GUI programming". Implementations are compared "in
terms of their notation". The seven tasks per secondary sources: Counter, Temperature
Converter, Flight Booker, Timer, CRUD, Circle Drawer, Spreadsheet.

What it compares: GUI toolkits by the code they require, not by resources. Out of
scope here.

### Rosetta Code

[site](https://rosettacode.org/)

Status: unverified

Not fetched. A wiki of solutions to common programming tasks in many languages. The
Nanz and Furia study below uses it as its data set.

## Academic comparisons

### Prechelt 2000

[KIT page](https://ps.ipd.kit.edu/180_744.php)

Status: unverified

Read 2026-10-03 from the KIT page. Lutz Prechelt, "An empirical comparison of C, C++,
Java, Perl, Python, Rexx, and Tcl", IEEE Computer, issue 10, 2000, pages 23 to 29.
"80 implementations of the same set of requirements are compared" on "run time, memory
consumption, source text length, comment density, program structure, reliability, and
the amount of effort required for writing them". The task is string manipulation and
dictionary search. Findings: the scripting languages were more productive, and "often
turn out better than Java and not much worse than C or C++" at run time. The finding
that matters most here: "differences between languages tend to be smaller than the
typical differences due to different programmers within the same language".

### Nanz and Furia 2015

[arXiv](https://arxiv.org/abs/1409.0252)

Status: unverified

Read 2026-10-03 from the arXiv abstract. "A Comparative Study of Programming Languages
in Rosetta Code", ICSE 2015, pages 778 to 788. 7,087 programs for 745 tasks in eight
languages: C, Go, C#, Java, F#, Haskell, Python, Ruby. Findings: functional and
scripting languages are more concise. "C is hard to beat when it comes to raw speed on
large inputs, but performance differences over inputs of moderate size are less
pronounced". Compiled strongly typed languages fail less often at run time.

### Ray et al. 2014 and the Berger et al. 2019 reproduction

[reproduction, arXiv](https://arxiv.org/abs/1901.10220),
[rebuttal by Ray et al., arXiv](https://arxiv.org/pdf/1911.07393)

Status: unverified

Read 2026-10-03 from the arXiv abstract of the reproduction. Ray et al. claimed "a
statistically significant association between eleven programming languages and software
defects in projects hosted on GitHub". Berger, Hollenbeck, Maj, Vitek and Vitek, TOPLAS
2019, repeated and reanalysed it. After the reanalysis "only four languages are found
to have a statistically significant association with defects, and even for those the
effect size is exceedingly small". A secondary source summarises the rebuttal by Ray
et al. as agreeing that the effects are small and that an absence of effect is a
possible reading.

What it measures: defects, not performance. What transfers: a published language
ranking from observational data did not survive reanalysis.

## Popular write-ups

### "Popular Backend Frameworks Performance Benchmark", dev.to, 2025

[post](https://dev.to/tuananhpham/popular-backend-frameworks-performance-benchmark-1bkh)

Status: unverified

Read 2026-10-03 from the post. The author took TechEmpower Round 23 data for the
fortunes test, filtered to full and micro ORM implementations, and ranked eight
frameworks by requests per second relative to Laravel. ASP.NET leads at 609,966
requests per second. Express sits at 78,136. The author concludes that compiled
languages beat interpreted languages. The post reports no latency, no memory, no run
count and no hardware. The fortunes test includes a database query and template
rendering.

What it shows for the side investigation: a framework benchmark with a database in it
reaches the public as a statement about languages, with one number per language.

### Viitanen 2025, "A Comparative Analysis of Modern Programming Languages in REST API Development"

[Theseus](https://www.theseus.fi/handle/10024/884660),
[code](https://github.com/tuukkaviitanen/api-comparison)

Status: unverified

Read 2026-10-03 from the PDF. Tuukka Viitanen, bachelor's thesis, Tampere University
of Applied Sciences, April 2025, 77 pages. One author implemented one REST API in
JavaScript with Node and Express, TypeScript with Bun and Elysia, C# with ASP.NET Core
minimal APIs, Go with Gin, and Rust with Axum. The API has CRUD, pagination, sorting,
filtering, request validation, authentication and authorisation, and a PostgreSQL
database. A shared functional test suite enforces the API contract.

The author states the position this project shares: "although the title of this
thesis specifically mentions comparing programming languages, the truth is that the
whole ecosystems are evaluated."

Method: k6 ramps from 1 to 100 virtual users. The database, the application and k6
each run with 1 CPU core and 1 GB of memory on a 4 core, 8 GB machine. Resource
usage comes from the Docker statistics API. Two scenarios: a light one that serves a
static OpenAPI file with no database access, and a heavy one that reads 1,000 rows
and computes a report. "The tests were run multiple times, and the results were consistently
similar." The thesis gives no run count and no percentiles.

Findings: in the light scenario "there are no significant differences among the
implementations". In the heavy scenario Go completes the most requests, then C#, then
Rust, and Node and Bun complete far fewer with CPU at 100 percent. Rust uses the least
memory, under 0.5 percent of the limit. The database CPU reached 100 percent under the
Go implementation, and the k6 runner almost saturated under C# and Go. The author
attributes Rust's result to "my limited experience with the language and its
ecosystem". The author declares no winner.

What it shows for this project: the one scenario without a database shows no
difference. The scenario with a database shows differences, and the author traces
them to the ORM, the database and the implementer rather than to the language. This is
the connector problem from docs/objective.md, seen in a study that included the
connector.

### Other write-ups found, not read

- "Performance comparison: C# vs Node vs Java vs Go vs Rust", dev.to. REST APIs that
  serve similar data, deployed to Kubernetes.
- "Concurrency in modern programming languages", dev.to series by deepu105. A
  concurrent web server in Rust, Go, Node, Deno, Kotlin and Java.
- "2024's fastest web servers for REST APIs", Medium.

## How this project differs

- **Unit of comparison.** Every suite above compares frameworks or whole
  applications. This project compares the language and its runtime, with a framework
  tier beside it so that the two stay separate.
- **No database, no authentication in the measured path.** TechEmpower, RealWorld,
  the dev.to ranking and Viitanen all include them. This project treats them as
  connector measurements and keeps them out, see docs/objective.md. Viitanen's own
  light scenario, the one path without the database, is the one that showed no
  difference.
- **Ecosystem as part of the result.** None of the suites report whether the artefact
  is a self contained binary or needs a runtime on the host. This project records it.
- **Named implementation and version.** Van Kempen et al. show that language and
  language implementation are different variables. This project pins the
  implementation at the latest major.minor.patch on the cutoff date.
- **Remeasurable by a reader.** The Benchmarks Game documents its procedure. The
  others publish results only. This project publishes the procedure and the scripts.
- **The nearest suite stopped.** TechEmpower archived its repository on 2026-03-24.
  Whether anyone continues it is not checked.

## What this project borrows

- From the Benchmarks Game: repeated runs, a dropped first run, confidence intervals,
  cache clearing, and a stated machine.
- From RealWorld: one spec and one conformance suite that every implementation must
  pass before measurement.
- From the-benchmarker: a route set small enough to need no database.
- From Prechelt: the warning that one implementer per language measures the
  implementer. The design has to answer it.
- From Berger et al. and Van Kempen et al.: state the hypotheses before measuring, and
  list the confounds before ranking.
