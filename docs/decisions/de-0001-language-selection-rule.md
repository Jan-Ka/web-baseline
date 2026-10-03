# DE-0001. Languages enter by usage rank, by benchmark presence, or by choice

Date: 2026-10-03

## Question

Which languages enter the comparison, and by which rule?

## Data

From docs/research/language-candidates.md.

Ranks in the five language rankings, under HY-0007. A dash means the language is
not in the published list. Octoverse publishes only a top 10.

| Language   | Stack Overflow | TIOBE | RedMonk | Octoverse | W3Techs |
| ---------- | -------------: | ----: | ------: | --------: | ------: |
| JavaScript |              1 |     6 |       1 |         3 |       2 |
| TypeScript |              6 |     - |       6 |         1 |       - |
| Python     |              4 |     1 |       2 |         2 |       7 |
| Java       |              8 |     4 |       3 |         4 |       4 |
| C#         |              7 |     5 |       4 |         5 |       6 |
| PHP        |             12 |    14 |       4 |         6 |       1 |
| Go         |             13 |    12 |      12 |        10 |      17 |
| C++        |             10 |     3 |       7 |         8 |      15 |
| Ruby       |             17 |     - |       9 |         - |       3 |
| Rust       |             14 |    10 |      20 |         - |       - |
| Kotlin     |             15 |     - |      14 |         - |       - |

Benchmark repositories, counted on this machine from pinned commits. The research
document holds the commits and the command to repeat the count.

| Language   | TechEmpower | the-benchmarker |
| ---------- | ----------: | --------------: |
| Java       |          68 |              21 |
| PHP        |          38 |              57 |
| Python     |          36 |              47 |
| Rust       |          32 |              32 |
| Go         |          22 |              42 |
| C#         |          22 |               8 |
| JavaScript |          21 |              69 |
| C++        |          19 |               2 |
| Ruby       |          14 |              13 |
| Kotlin     |           7 |               7 |

## Reasoning

The audience wants to know how the languages they use compare. The rankings answer
which languages those are. None of them counts web backend use directly, and each
one has a different bias. A language in the top 20 of all five is in wide use by
each of these measures.

The cut at top 20 is a judgement. A top 10 would drop PHP and Go, which the web
specific sources rank high. Octoverse publishes only 10 places, so for Octoverse
the condition is the top 10. JavaScript and TypeScript count together and take the
better rank, because TypeScript runs on the same implementations. W3Techs lists
ASP.NET, which counts as C#. W3Techs places Go and C++ only through the order of
its list below 0.1 percent.

Usage alone misses the languages people bring into the debate for performance. Rust
is outside the Octoverse top 10 and absent from W3Techs, but it has 32 entries in
each benchmark repository. The benchmark repositories show which languages
contributors consider worth measuring.

The cut at 30 entries in each repository is also a judgement. A single repository
is not enough, because the counts depend on who contributes to it. C# has 22
entries in one and 8 in the other.

Ruby meets neither condition. It misses the TIOBE top 20 and the Octoverse top 10.
The project author adds it by choice. The reason is its use at large sites, under
HY-0008. GitHub, Shopify and GitLab run their main application on Ruby on Rails,
according to docs/research/large-sites.md. In the rankings, Ruby is 3 at W3Techs
and 9 at RedMonk, and it holds 8.1 percent of the top 1,000 sites at W3Techs.

## Decision

A language enters the comparison if it meets at least one of these conditions.

1. It is in the top 20 of each of the five language rankings in
   docs/research/language-candidates.md, or in the top 10 where a ranking publishes
   only 10 places.
2. It has at least 30 entries in each of the two benchmark repositories.

In addition, Ruby enters by the choice of the project author.

On 2026-10-03 this gives JavaScript or TypeScript, Python, Java, C#, PHP, Go, C++,
Rust and Ruby.

## Consequences

- The comparison starts with nine languages. Kotlin is the next one.
- Ruby is the only language that enters without meeting a condition. A later
  campaign keeps Ruby only if the author confirms the choice again.
- C++ enters through the rankings, not through web use. The Wikipedia table in
  docs/research/large-sites.md lists C++ at 6 of 16 sites, but no site in that
  document names C++ as its main back end.
- A later campaign applies the rule again to current data. The list can change
  between campaigns.
- The decision does not settle which implementations enter for a language with more
  than one, such as Node.js, Bun and Deno. It also does not settle whether
  JavaScript and TypeScript count as one language or two in the results. Both stay
  open.
- The usage part rests on HY-0007. The choice of Ruby rests on HY-0008. If a check
  of the rankings or the sites changes the result, this decision is revisited.
