# Subjects and tiers

Last revised: 2026-10-03

This document records how the language list from DE-0001 changes when each
language has to run a whole application. It covers which implementations become
separate subjects, where the HTTP server fits, and how the tiers change. DE-0003
settles it.

The status rule in docs/prior-art.md applies. The table of standard libraries cites
its sources. Lines without a source are not checked yet.

## Implementation and server

The implementation and the server are different things, and the comparison
treats them differently.

- The **implementation** runs the code. Examples are Node.js, Bun, Deno, HotSpot,
  GraalVM native image, CPython and the Zend Engine. docs/glossary.md already says
  that two implementations of one language are two subjects.
- The **server** accepts HTTP and hands requests to the code. Examples are php-fpm,
  FrankenPHP, Tomcat, JBoss, Kestrel and uvicorn. A server is not a new subject. Each
  tier uses one server, chosen by the tier's rule.

Choosing between servers within one language, for example FrankenPHP over php-fpm
or JBoss over Tomcat, is the same kind of question as choosing between frameworks
within one language. docs/objective.md lists that as a non-goal. If the default
server has a large effect, the question belongs to the side question on essential
changes that improve a language's result.

## Subjects

A language runs on its reference implementation. A second implementation enters
when the community treats it as a real choice for production web work.

| Language                 | Subjects                               | Reason                                                                                |
| ------------------------ | -------------------------------------- | ------------------------------------------------------------------------------------- |
| JavaScript or TypeScript | Node.js, Bun, Deno                     | Three runtimes in production use, each with its own server API                        |
| Java                     | HotSpot, GraalVM native image          | A JIT on a JVM against an ahead of time compiled binary. This is the split in HY-0002 |
| Python                   | CPython                                | Reference implementation                                                              |
| C#                       | .NET                                   | Reference implementation. Native AOT is a configuration of the same implementation    |
| PHP                      | Zend Engine                            | Reference implementation. The JIT is a configuration                                  |
| Go                       | gc toolchain                           | Reference implementation                                                              |
| Rust                     | rustc                                  | Reference implementation                                                              |
| C++                      | to be chosen, for example GCC or Clang | Two compilers of similar standing. The choice is still open                           |
| Ruby                     | CRuby                                  | Reference implementation. YJIT is a configuration                                     |

This gives 12 subjects.

JavaScript and TypeScript count as one language. Bun and Deno run TypeScript
directly. Node.js strips the types by default since v22.18.0 and v23.6.0, and the
feature is stable since v24.12.0 and v25.2.0, according to the
[Node.js docs](https://nodejs.org/api/typescript.html). At run time the code is
JavaScript in all three, so the implementations are written in TypeScript.

## Tiers

The objective has two tiers, the bare language and the framework. A whole
application makes the bare tier uneven, because not every standard library has an
HTTP server and JSON. The proposal is three tiers.

1. **Standard library.** The language distribution alone.
2. **Micro library.** One lightweight library per subject that gives routing,
   request parsing and response helpers, without the structure of a full
   framework. Every subject enters here, Rust and C++ included. Go uses a library
   such as Gin here, not its standard library build.
3. **Full framework.** The opinionated framework the community treats as
   essential, on the server the framework uses by default. A full framework adds
   structure such as dependency injection, conventions or an ORM. Spring Boot
   embeds Tomcat, for example.

The micro library tier carries the comparison across all subjects with minimal
help. The standard library tier can therefore stay strict at little cost.

The section on library candidates below gives the data per subject.

### What the standard libraries hold

| Subject             | HTTP server in the standard library                                                                                                                                                                                                                                                                                                       | JSON in the standard library                                                                            |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Go                  | `net/http`                                                                                                                                                                                                                                                                                                                                | `encoding/json`                                                                                         |
| C#                  | `HttpListener`. Microsoft writes "We recommend that you don't use the HttpListener class for new development" and points to ASP.NET Core ([.NET docs](https://learn.microsoft.com/en-us/dotnet/api/system.net.httplistener)). ASP.NET Core and its server Kestrel ship with the .NET SDK as a shared framework, not with the base library | `System.Text.Json`                                                                                      |
| Node.js             | `node:http`                                                                                                                                                                                                                                                                                                                               | yes                                                                                                     |
| Bun                 | `Bun.serve`                                                                                                                                                                                                                                                                                                                               | yes                                                                                                     |
| Deno                | `Deno.serve`                                                                                                                                                                                                                                                                                                                              | yes                                                                                                     |
| Java, both subjects | `com.sun.net.httpserver`, a basic server                                                                                                                                                                                                                                                                                                  | none. [JEP 540](https://openjdk.org/jeps/540) adds an incubator module, `jdk.incubator.json`, in JDK 28 |
| Python              | `http.server`, which "is not recommended for production" ([Python docs](https://docs.python.org/3/library/http.server.html))                                                                                                                                                                                                              | `json`                                                                                                  |
| PHP                 | The built-in server "is not intended for production usage" ([PHP docs](https://www.php.net/manual/en/features.commandline.webserver.php)). php-fpm ships with PHP and needs a web server in front                                                                                                                                         | yes                                                                                                     |
| Ruby                | none. WEBrick left the standard library in Ruby 3.0 ([release notes](https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/))                                                                                                                                                                                                  | `json`, a default gem                                                                                   |
| Rust                | none                                                                                                                                                                                                                                                                                                                                      | none                                                                                                    |
| C++                 | none                                                                                                                                                                                                                                                                                                                                      | none                                                                                                    |

The gap is not limited to Rust and C++. Java has no JSON, Ruby has no server, and
the docs of C#, Python and PHP rule out their built-in servers for production. For PHP
the standard library tier would run on php-fpm, which puts a web server such as
nginx into the measured path.

## Library candidates

Read on 2026-10-03. The Stack Overflow values are percent of professional
developers in the 2025 survey, from the
[web frameworks list](https://survey.stackoverflow.co/2025/technology). The
community surveys are the closest source per language. Stars are GitHub stars of
the main repository on 2026-10-03, read through the GitHub API. Stars measure
attention, not use, and the repository that holds the stars differs per project.
Laravel, for example, splits its stars between the framework and the application
skeleton.

| Subject             | Library                   | Kind     | Stack Overflow       | Community survey                                   | Stars   |
| ------------------- | ------------------------- | -------- | -------------------- | -------------------------------------------------- | ------- |
| Go                  | Gin                       | micro    | -                    | 48 percent of Go developers                        | 89,277  |
| Go                  | Echo                      | micro    | -                    | 16 percent                                         | 32,750  |
| Go                  | chi                       | micro    | -                    | about 12 percent                                   | 22,918  |
| Go                  | Fiber                     | micro    | -                    | 11 percent                                         | 40,195  |
| Node.js, Bun, Deno  | Express                   | micro    | 20.3                 | leads usage in State of JS 2025                    | 69,502  |
| Node.js, Bun, Deno  | Fastify                   | micro    | 3.1                  | listed in State of JS 2025                         | 37,226  |
| Node.js, Bun, Deno  | Hono                      | micro    | -                    | listed in State of JS 2025                         | 32,405  |
| Bun                 | Elysia                    | micro    | -                    | listed in State of JS 2025                         | 19,216  |
| Node.js, Bun, Deno  | NestJS                    | full     | 7.4                  | second in usage in State of JS 2025                | 76,783  |
| Java, both subjects | Javalin                   | micro    | -                    | none found                                         | 8,357   |
| Java, both subjects | Helidon                   | micro    | -                    | none found                                         | 3,833   |
| Java, both subjects | Spring Boot               | full     | 15.6                 | none found for 2025                                | 81,547  |
| Java, both subjects | Quarkus                   | full     | -                    | none found                                         | 15,918  |
| C#                  | ASP.NET Core minimal APIs | micro    | 21.3 as ASP.NET Core | Microsoft recommends minimal APIs for new projects | -       |
| C#                  | ASP.NET Core MVC          | full     | 21.3 as ASP.NET Core | -                                                  | -       |
| Python              | FastAPI                   | boundary | 15.1                 | 38 percent in JetBrains 2025                       | 102,790 |
| Python              | Flask                     | micro    | 13.2                 | 33 percent in JetBrains 2023                       | 74,816  |
| Python              | Django                    | full     | 11.7                 | 33 percent in JetBrains 2023                       | 91,238  |
| PHP                 | Slim                      | micro    | -                    | none found                                         | 12,277  |
| PHP                 | Laravel                   | full     | 9.3                  | 64 percent in JetBrains 2025                       | 34,949  |
| PHP                 | Symfony                   | full     | 4.3                  | 23 percent in JetBrains 2025                       | 31,170  |
| Ruby                | Sinatra                   | micro    | -                    | none found                                         | 12,454  |
| Ruby                | Roda                      | micro    | -                    | none found                                         | 2,234   |
| Ruby                | Rails                     | full     | 6.2                  | -                                                  | 58,798  |
| Rust                | axum                      | micro    | 2.7                  | leads crates.io downloads                          | 27,341  |
| Rust                | actix-web                 | micro    | -                    | -                                                  | 24,851  |
| Rust                | Rocket                    | micro    | -                    | -                                                  | 25,780  |
| Rust                | Loco                      | full     | -                    | -                                                  | 9,385   |
| C++                 | Drogon                    | micro    | -                    | none found                                         | 14,313  |
| C++                 | Crow                      | micro    | -                    | none found                                         | 4,991   |

Sources for the community surveys:

- Go. The JetBrains State of Developer Ecosystem 2025, as reported in
  [The Go Ecosystem in 2025](https://blog.jetbrains.com/go/2025/11/10/go-language-trends-ecosystem-2025/),
  read from the page.
- JavaScript. [State of JS 2025, back-end frameworks](https://2025.stateofjs.com/en-US/libraries/back-end-frameworks/).
  The page states that Express leads in usage and that NestJS grows. The values
  sit in a chart and were not read.
- C#. The [ASP.NET Core APIs overview](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/apis)
  says "For new projects, we recommend using Minimal APIs". Read from the page.
- Python. JetBrains State of Python 2025 for FastAPI, and the JetBrains Python
  Developers Survey 2023 for Flask and Django, from search summaries.
- PHP. [JetBrains State of PHP 2025](https://blog.jetbrains.com/phpstorm/2025/10/state-of-php-2025/),
  from a search summary.
- Rust. crates.io downloads, from a search summary.

No survey with framework shares was found for Java in 2025, for Ruby frameworks
other than Rails, or for C++.

Observations on the libraries:

1. Several subjects have one clear choice. Go has Gin on the micro side. PHP has
   Laravel, Ruby has Rails and Python has Django on the full side. For C#,
   Microsoft recommends minimal APIs.
2. Python's FastAPI leads both the Stack Overflow list and the JetBrains survey. It
   sits on the boundary between micro library and full framework.
3. Express leads usage across JavaScript. Hono runs on all three JavaScript
   runtimes. Elysia runs on Bun only.
4. Go, Rust and C++ have no full framework with clear use. Loco is the only Rust
   candidate, and it has little attention.
5. Java has no current survey. Spring Boot is the only Java entry in the Stack
   Overflow list.

## ASP.NET Core and the standard library

The [.NET glossary](https://learn.microsoft.com/en-us/dotnet/standard/glossary)
calls the base class library "a general purpose, lower-level framework that
higher-level application frameworks, such as ASP.NET Core, build on". It lists
ASP.NET Core as an example of an application framework. The ASP.NET Core shared
framework "includes the BCL plus additional APIs for use by web apps". By this
definition ASP.NET Core is not part of the standard library of C#, although the
.NET SDK installs it. Read from the page.

## C++ compiler

The JetBrains State of C++ 2025 reports GCC at 70 percent, Clang at 45 percent and
MSVC at 27 percent of C++ developers. This comes from a search summary of the
[survey page](https://lp.jetbrains.com/the-state-of-cpp-2025/).

## Web server in front of php-fpm

W3Techs reports on 2026-10-03 that nginx serves 30.8 percent and Apache 21.9
percent of websites. This was read from the
[web server overview](https://w3techs.com/technologies/overview/web_server).

## Open points

- **How strict the standard library tier is.** Three readings are possible.
  1. A subject enters only if its standard library has both a server and JSON.
     That leaves Go, C#, Node.js, Bun, Deno and Python.
  2. Every subject enters, and anything missing is hand-written on the standard
     library. Each hand-written part is recorded and flagged. This measures the
     implementer for those parts, the risk in HY-0003.
  3. Only standard libraries that can serve production traffic count. That leaves
     Go, Node.js, Bun and Deno. C# enters only if ASP.NET Core counts as part of
     the .NET distribution, because the SDK ships it.
- **The rule that picks the library per subject** for the micro library and the
  full framework tier, in the way DE-0001 picks the languages.
- **The boundary between micro library and full framework.** FastAPI and ASP.NET
  Core minimal APIs sit close to it.
- **Subjects without a clear full framework,** such as Go and C++. They may have no
  third tier, or the same library in tiers 2 and 3.
- **The C++ compiler.** GCC has the larger share, see below.
- **The web server in front of php-fpm,** and whether it counts as part of PHP.
  nginx has the larger share, see below.

## Where this leads

- A decision on subjects and tiers. It turns the DE-0001 languages into 12
  subjects and the two tiers of docs/objective.md into three.
- Changes to docs/glossary.md. The server needs a term, and the tier needs a new
  definition with three values.
- Three tiers across 12 subjects mean up to 36 implementations of the application.
  That raises the weight of HY-0003, one implementer per subject.
