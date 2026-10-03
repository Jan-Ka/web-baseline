# Large sites

Last revised: 2026-10-03

This document lists the back end languages of large, well known sites. DE-0001 uses
it as the reason to add Ruby. HY-0008 holds the claim that the entries are current.

All entries come from desk research on 2026-10-03. The status rule in
docs/prior-art.md applies, and no entry is checked yet. A large site runs many
services in many languages. An entry names the language of the main application,
not every language the site uses.

## Statements by the sites

Each row cites a statement by the site, its engineering team or its project
documentation. Reddit is the exception. Its row cites an InfoQ report on a Reddit
engineering post. The column "Read from" says whether the statement was read from
the page or from a search summary of the page.

| Site           | Main back end                                        | Source                                                                                                                                                       | Date         | Read from      |
| -------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------ | -------------- |
| GitHub         | Ruby, Rails monolith                                 | [GitHub blog, Building GitHub with Ruby and Rails](https://github.blog/engineering/architecture-optimization/building-github-with-ruby-and-rails/)           | 2023-04-06   | page           |
| Shopify        | Ruby, Rails                                          | [Shopify Engineering, E-commerce at scale](https://shopify.engineering/e-commerce-at-scale-inside-shopifys-tech-stack)                                       | 2018-08-08   | page           |
| GitLab         | Ruby, Rails                                          | [GitLab architecture overview](https://docs.gitlab.com/development/architecture/)                                                                            | current      | page           |
| Wikipedia      | PHP, MediaWiki                                       | [MediaWiki architecture manual](https://www.mediawiki.org/wiki/Manual:MediaWiki_architecture)                                                                | 2026-08-31   | page           |
| Uber           | Go for most back end services                        | [Uber blog, Go monorepo with Bazel](https://www.uber.com/blog/go-monorepo-bazel/)                                                                            | 2020-05-13   | page           |
| Reddit         | Python monolith, comments moved to Go                | [InfoQ, Reddit comments migration](https://infoq.com/news/2025/11/reddit-comments-go-migration/)                                                             | 2025-11      | search summary |
| Stack Overflow | C#, ASP.NET MVC                                      | [Nick Craver, Stack Overflow architecture 2016](https://nickcraver.com/blog/2016/02/17/stack-overflow-the-architecture-2016-edition/)                        | 2016-02-17   | page           |
| Instagram      | Python, Django                                       | [Instagram Engineering, Web service efficiency with Python](https://instagram-engineering.com/web-service-efficiency-at-instagram-with-python-4976d078e366)  | 2016         | search summary |
| Netflix        | Java, Spring Boot                                    | [InfoQ, How Netflix really uses Java, talk by Paul Bakker of Netflix](https://www.infoq.com/presentations/netflix-java)                                      | 2023         | search summary |
| Slack          | Hack on HHVM                                         | [Slack Engineering, posts tagged HHVM](https://slack.engineering/tags/hhvm)                                                                                  | 2016 to 2020 | search summary |
| Discord        | Elixir for real time messaging, also Rust and Python | [Elixir blog, Real time communication at scale at Discord](https://elixir-lang.org/blog/2020/10/08/real-time-communication-at-scale-with-elixir-at-discord/) | 2020-10-08   | search summary |

Notes:

- GitHub states that the application is nearly two million lines of code and that
  more than 1,000 engineers work on it daily.
- Reddit served comments, accounts, posts and subreddits from one Python service.
  In 2024 it started to move them to Go services, comments first.
- Several entries are older than five years. A site can change its stack after the
  date in the row.

## Wikipedia table

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

## Share by traffic rank

W3Techs splits the server side language share by traffic rank. The page shows only
the top three languages. Values are percent, read on 2026-10-03.

| Language   | Top 1,000 | Top 10,000 | Top 100,000 | Top 1,000,000 | All sites |
| ---------- | --------: | ---------: | ----------: | ------------: | --------: |
| PHP        |      58.8 |       60.0 |        61.3 |          64.8 |      69.8 |
| JavaScript |      30.6 |       27.3 |        20.1 |          12.7 |       7.6 |
| Ruby       |       8.1 |        8.4 |         9.2 |          12.5 |       7.1 |

The share of JavaScript grows with traffic and the share of PHP falls.
