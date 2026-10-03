# Language candidates

Last revised: 2026-10-03

This document collects the data for choosing the languages. DE-0001 sets the rule
and the resulting list.

All data comes from desk research on 2026-10-03 and none of it is checked yet. The
status rule in docs/prior-art.md applies. DE-0001 relies on the usage numbers
through HY-0007.

The sources fall into two groups. Usage sources show what people use or talk about.
Implementation sources show which frameworks exist per language. Neither group shows
directly which languages people use for web backends.

## Usage sources

Values are percent unless the row gives a rank.

| Source                                                                                                                                                | What it counts                     | Period               | Server relevant results                                                                                                  |
| ----------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| [Stack Overflow Developer Survey 2025](https://survey.stackoverflow.co/2025/technology), languages, professional developers                           | Self reported use                  | May to Aug 2025      | JavaScript 68.8, Python 54.8, TypeScript 48.8, C# 29.9, Java 29.6                                                        |
| Stack Overflow Developer Survey 2025, web frameworks, professional developers                                                                         | Self reported use                  | May to Aug 2025      | Node.js 49.1, ASP.NET Core 21.3, Express 20.3, Spring Boot 15.6, FastAPI 15.1                                            |
| [GitHub Octoverse 2025](https://github.blog/news-insights/octoverse/octoverse-a-new-developer-joins-github-every-second-as-ai-leads-typescript-to-1/) | Contributors on GitHub             | Sep 2024 to Aug 2025 | Top 10 by contributors in Aug 2025. 1 TypeScript, 2 Python, 3 JavaScript, 4 Java, 5 C#, 6 PHP, 8 C++, 10 Go              |
| [RedMonk January 2026](https://redmonk.com/sogrady/2026/04/14/language-rankings-1-26/)                                                                | GitHub and Stack Overflow, by rank | Q1 2026              | 1 JavaScript, 2 Python, 3 Java, 4 PHP and C#, 6 TypeScript, 7 C++, 9 Ruby, 11 Swift, 12 Go, 14 Kotlin and Scala, 20 Rust |
| [TIOBE September 2026](https://www.tiobe.com/tiobe-index/)                                                                                            | Search engine hits                 | Sep 2026             | Python 17.76, C 10.28, C++ 8.67, Java 7.54, C# 4.22, JavaScript 2.76                                                     |
| [W3Techs](https://w3techs.com/technologies/overview/programming_language)                                                                             | Public websites, server side       | 2026-10-03           | PHP 69.8, JavaScript 7.6, Ruby 7.1, Java 5.5, Scala 5.0, ASP.NET 4.2, Python 1.1, Go below 0.1                           |

DE-0001 counts the five language rankings, not the framework row. This table gives
the rank of each candidate in each ranking. A dash means the language is not in the
published list.

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
| C          |             11 |     2 |      10 |         - |      14 |
| Swift      |             19 |    18 |      11 |         - |       - |
| Scala      |              - |     - |      14 |         - |       5 |

How the ranks were read:

- Stack Overflow counts every entry in the professional list, including HTML/CSS,
  SQL, Bash/Shell and PowerShell. Swift ties with Assembly at 5.7 percent.
- TIOBE is the September 2026 top 20 from the TIOBE page.
- Octoverse publishes only a top 10, by contributors in August 2025.
- W3Techs lists ASP.NET, which counts as C# here. The ranks leave out the entry
  for static files. Ranks 10 and lower follow the order of the list of languages
  below 0.1 percent, and the page does not say that this order is a ranking.

- The Stack Overflow, W3Techs, TIOBE and Octoverse values come from summaries of
  the source pages. The RedMonk ranking comes from a search summary of the RedMonk
  post.
- We could not find the 2026 Stack Overflow results. Secondary reports only repeat
  the 2025 values.
- W3Techs counts websites, so WordPress inflates PHP and APIs and internal services
  do not show up. The Scala value may be a detection error.
- TIOBE does not separate web work from other work.

## High-traffic sites

These two sources show what the largest sites run. They are not part of the usage
sources that DE-0001 counts.

W3Techs splits the server side language share by traffic rank. The page shows only
the top three languages. Values are percent, read on 2026-10-03.

| Language   | Top 1,000 | Top 10,000 | Top 100,000 | Top 1,000,000 | All sites |
| ---------- | --------: | ---------: | ----------: | ------------: | --------: |
| PHP        |      58.8 |       60.0 |        61.3 |          64.8 |      69.8 |
| JavaScript |      30.6 |       27.3 |        20.1 |          12.7 |       7.6 |
| Ruby       |       8.1 |        8.4 |         9.2 |          12.5 |       7.1 |

The share of JavaScript grows with traffic and the share of PHP falls.

The Wikipedia article
[Programming languages used in most popular websites](https://en.wikipedia.org/wiki/Programming_languages_used_in_most_popular_websites)
lists the back end languages of 16 large sites. The page was last edited on
2026-10-01. Its entries cite older sources, and a large site runs many services in
many languages, so a listed language does not show how much of the site uses it.

| Back end language | Sites | Sites that list it                                                   |
| ----------------- | ----: | -------------------------------------------------------------------- |
| Java              |     8 | Google, Facebook, YouTube, Amazon, X, eBay, LinkedIn, Netflix        |
| PHP               |     6 | Facebook, Yahoo, Etsy, Wikipedia, Fandom, WordPress.com              |
| C++               |     6 | Google, Facebook, YouTube, Amazon, X, Bing                           |
| Python            |     5 | Google, Facebook, YouTube, Pinterest, Netflix                        |
| JavaScript        |     3 | Google, eBay, LinkedIn                                               |
| Scala             |     3 | X, eBay, LinkedIn                                                    |
| C                 |     2 | Google, YouTube                                                      |
| Go                |     2 | Google, YouTube                                                      |
| C#                |     2 | Bing, MSN                                                            |
| Erlang            |     2 | Facebook, Pinterest                                                  |
| Ruby              |     1 | X                                                                    |
| Others            |     1 | Perl at Amazon, Hack, D and Haskell at Facebook, Elixir at Pinterest |

## Benchmark repositories

Each count is the number of subdirectories in a language directory. A subdirectory
holds one framework or one variant. The counts show what contributors chose to
benchmark, which reflects interest in performance rather than usage.

| Repository                                                                            | Commit                                     | State                     |
| ------------------------------------------------------------------------------------- | ------------------------------------------ | ------------------------- |
| [TechEmpower/FrameworkBenchmarks](https://github.com/TechEmpower/FrameworkBenchmarks) | `57d92fbec6f8fd7431bc77326dd0484e60c96e20` | Archived since 2026-03-24 |
| [the-benchmarker/web-frameworks](https://github.com/the-benchmarker/web-frameworks)   | `268c363c2f464ff06c5b75c8b74b1c4d20e3fa62` | Active                    |

TechEmpower has 41 languages and the-benchmarker has 32. The table lists every
language with at least 5 entries in either repository. the-benchmarker counts
TypeScript as JavaScript.

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
| Scala      |          18 |               6 |
| Ruby       |          14 |              13 |
| Clojure    |          11 |               4 |
| TypeScript |           9 |                 |
| Kotlin     |           7 |               7 |
| Haskell    |           7 |               2 |
| Crystal    |           7 |              12 |
| Zig        |           6 |               2 |
| Perl       |           6 |               4 |
| Nim        |           6 |              15 |
| F#         |           6 |               8 |
| Dart       |           6 |               8 |
| Swift      |           5 |               6 |
| D          |           5 |               7 |
| C          |           5 |               2 |
| Elixir     |           2 |               6 |
| V          |           2 |               5 |
| R          |           1 |               5 |

The counts depend on who contributes. For example, C# has 22 entries in
TechEmpower and 8 in the-benchmarker.

To repeat the TechEmpower count, run the following in a POSIX shell. For
the-benchmarker, count the top level directories at its commit and skip the ones
that start with a dot.

```sh
git clone -q --filter=blob:none --no-checkout https://github.com/TechEmpower/FrameworkBenchmarks te
git -C te ls-tree -d --name-only 57d92fbec6f8fd7431bc77326dd0484e60c96e20 frameworks/ |
  while read -r d; do
    echo "$(git -C te ls-tree -d --name-only 57d92fbec6f8fd7431bc77326dd0484e60c96e20 "$d/" | wc -l) ${d#frameworks/}"
  done | sort -rn
```

## GitHub search

A GitHub search on 2026-10-03 found these frameworks with more than 3000 stars. The
search used the topics web-framework and http-server, and the phrase web framework
in the description. Star counts are in thousands.

| Language   | Frameworks                                   |
| ---------- | -------------------------------------------- |
| Python     | Django 91, Flask 75, Tornado 22, Sanic 19    |
| Go         | Gin 89, Fiber 40, Echo 33, Beego 32, Iris 26 |
| JavaScript | Express 70, Fastify 37                       |
| TypeScript | Hono 32, AdonisJS 19                         |
| Swift      | Vapor 26                                     |
| Rust       | Rocket 26, Actix Web 25                      |
| Elixir     | Phoenix 23                                   |
| Kotlin     | Ktor 15                                      |
| C++        | Drogon 14                                    |
| Scala      | Play 13                                      |
| Ruby       | Sinatra 12                                   |
| PHP        | CakePHP 9                                    |
| Java       | Dropwizard 9                                 |

The search did not find Spring Boot, Ruby on Rails, Laravel, ASP.NET Core, FastAPI
or NestJS, because their repositories do not use these topics or this phrase. So
the table is not a ranking. A ranking by stars would need a hand-picked list of
repositories, and picking that list adds bias.

## Observations

1. JavaScript or TypeScript, Python, Java, C#, PHP, Go and C++ are in the top 20
   of every ranking. Ruby misses TIOBE and the Octoverse top 10.
2. Rust and Go rank higher in the benchmark repositories than in the usage sources.
3. Kotlin, Scala and C++ have many TechEmpower entries and a low rank for web work
   in the other sources.
4. Crystal, Nim and Zig appear only in the benchmark repositories.
5. At the largest sites, Java, PHP, C++ and Python appear most often. Rust does
   not appear in the Wikipedia table.
6. JavaScript and TypeScript run on Node.js, Bun and Deno. A base language includes
   its implementation, so the choice has to name the implementations too. Java and
   Kotlin share the JVM.

## Candidate list

DE-0001 includes a language if it is in the top 20 of every ranking, or if it has
at least 30 entries in each benchmark repository. That rule gives this list.

- JavaScript or TypeScript
- Python
- Java
- C#
- PHP
- Go
- C++
- Rust

Ruby would be the next language, then Kotlin.

## Open points

- Which implementations to include for a language with more than one, such as
  Node.js, Bun and Deno.
- Whether JavaScript and TypeScript count as one language or two.
- Checking every number in this document.
