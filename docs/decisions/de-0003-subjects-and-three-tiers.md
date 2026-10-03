# DE-0003. Twelve subjects in three tiers

Date: 2026-10-03

## Question

Which implementations of the DE-0001 languages enter the comparison, how many tiers
does each one run, and which library or framework fills each tier?

## Data

From docs/research/subjects-and-tiers.md.

Standard libraries, read from the documentation of each language.

| Subject            | Production server in the standard library                                              | JSON in the standard library     |
| ------------------ | -------------------------------------------------------------------------------------- | -------------------------------- |
| Go                 | yes                                                                                    | yes                              |
| Node.js, Bun, Deno | yes                                                                                    | yes                              |
| C#                 | no. Microsoft advises against `HttpListener` for new development                       | yes                              |
| Python             | no. The docs say `http.server` is not recommended for production                       | yes                              |
| PHP                | no. The built-in server is not for production, and php-fpm needs a web server in front | yes                              |
| Java               | basic server only                                                                      | no, until an incubator in JDK 28 |
| Ruby               | no, since Ruby 3.0                                                                     | yes                              |
| Rust, C++          | no                                                                                     | no                               |

The .NET glossary calls the base class library "a general purpose, lower-level
framework that higher-level application frameworks, such as ASP.NET Core, build
on".

Library data, under HY-0011. The research document lists every candidate with its
Stack Overflow share, community survey and GitHub stars. The leaders per subject:

- Go. Gin, used by 48 percent of Go developers.
- JavaScript. Express leads usage, NestJS is second.
- C#. Microsoft recommends minimal APIs for new projects.
- Python. Django on the full side. FastAPI leads usage but sits on the boundary
  between micro library and full framework.
- PHP. Laravel, used by 64 percent of PHP developers.
- Ruby. Rails.
- Java. Spring Boot, the only Java entry in the Stack Overflow list.
- Rust. axum, by crates.io downloads.
- C++. No survey. Drogon has the most stars. GCC is the most used compiler.

## Reasoning

A base language is a language together with its implementation. A second
implementation counts as its own subject when the community uses it as a separate
choice for production web work. JavaScript has three such runtimes. Java on
HotSpot and Java as a GraalVM native image differ in compilation and in deployment
form, the split in HY-0002. For the other languages, variants such as Native AOT,
YJIT or the PHP JIT are configurations of one implementation.

A whole application makes a bare tier uneven, because not every standard library
holds a server and JSON. Hand-written replacements would measure the implementer,
the risk in HY-0003. A tier of lightweight libraries lets every subject run the
same application with minimal help. A standard library tier can then stay strict
and admit only what the language distribution supports for production. ASP.NET
Core is an application framework on top of the base class library, by Microsoft's
own definition, so C# does not enter that tier.

The micro library tier and the full framework tier sort by kind first. A micro
library gives routing, request parsing and response helpers. A full framework adds
structure such as dependency injection, conventions or an ORM. Within a kind, the
library with the most use in the closest community survey wins. Where no survey
exists, the Stack Overflow list decides, and after that GitHub stars. FastAPI leads
Python usage, but its dependency injection and validation put it on the full side
of the boundary, so Flask fills the Python micro tier.

The server follows the tier. Choosing between servers within one language is a
non-goal in docs/objective.md, in the same way as choosing between frameworks.

## Decision

The comparison has 12 subjects.

| Language                 | Subjects                      |
| ------------------------ | ----------------------------- |
| JavaScript or TypeScript | Node.js, Bun, Deno            |
| Java                     | HotSpot, GraalVM native image |
| Python                   | CPython                       |
| C#                       | .NET                          |
| PHP                      | Zend Engine                   |
| Go                       | gc toolchain                  |
| Rust                     | rustc                         |
| C++                      | GCC                           |
| Ruby                     | CRuby                         |

JavaScript and TypeScript count as one language. The implementations are written
in TypeScript.

Each subject runs the DE-0002 application in up to three tiers.

1. **Standard library.** Only subjects whose standard library holds a server that
   its maintainers support for production, and JSON. These are Go, Node.js, Bun
   and Deno.
2. **Micro library.** One lightweight library per subject.
3. **Full framework.** One framework per subject, on the server the framework
   uses by default.

| Subject                        | Micro library             | Full framework   |
| ------------------------------ | ------------------------- | ---------------- |
| Go                             | Gin                       | none             |
| Node.js                        | Express                   | NestJS           |
| Bun                            | Hono                      | NestJS           |
| Deno                           | Hono                      | NestJS           |
| Java, HotSpot and native image | Javalin                   | Spring Boot      |
| C#                             | ASP.NET Core minimal APIs | ASP.NET Core MVC |
| Python                         | Flask                     | Django           |
| PHP                            | Slim                      | Laravel          |
| Ruby                           | Sinatra                   | Rails            |
| Rust                           | axum                      | none             |
| C++                            | Drogon                    | none             |

Bun and Deno use Hono in the micro tier because Hono is built for both. Express
runs on them only through their Node.js compatibility, and the results say so. The
same remark applies to NestJS on Bun and Deno.

PHP runs on php-fpm behind nginx in every tier where it appears.

## Consequences

- The comparison holds 4 standard library, 12 micro library and 9 full framework
  implementations, 25 in total. That raises the weight of HY-0003.
- Go, Rust and C++ have no full framework tier. Their results leave that tier
  empty.
- nginx sits in the measured path for PHP. The results name it.
- Every library must run on both Java subjects. If one does not build as a native
  image, the results record the gap per PR-0011.
- Every campaign applies the library rule again to current data.
- The library choice rests on HY-0011.
- docs/objective.md and docs/glossary.md change from two tiers to three.
  HY-0001 and HY-0004 now refer to the three tiers.
