# Subjects and tiers

Last revised: 2026-10-03

This document records how the language list from DE-0001 changes when each
language has to run a whole application. It covers which implementations become
separate subjects, where the HTTP server fits, and how the tiers change. A decision
under docs/decisions/ will settle it.

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

The table lists candidates per subject. They are not yet researched.

| Subject             | Micro library                  | Full framework       |
| ------------------- | ------------------------------ | -------------------- |
| Go                  | Gin, chi, Echo                 | no clear candidate   |
| Node.js, Bun, Deno  | Express, Fastify, Hono, Elysia | NestJS, Next.js      |
| Java, both subjects | Javalin, Helidon SE            | Spring Boot, Quarkus |
| C#                  | ASP.NET Core minimal APIs      | ASP.NET Core MVC     |
| Python              | Flask, FastAPI, Starlette      | Django               |
| PHP                 | Slim                           | Laravel, Symfony     |
| Ruby                | Sinatra, Roda                  | Rails                |
| Rust                | axum, actix-web                | Loco                 |
| C++                 | Crow, Drogon                   | no common candidate  |

### What the standard libraries hold

| Subject             | HTTP server in the standard library                                                                                                                                                               | JSON in the standard library                                                                            |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Go                  | `net/http`                                                                                                                                                                                        | `encoding/json`                                                                                         |
| C#                  | `HttpListener`. Kestrel ships with ASP.NET Core, not with the base library                                                                                                                        | `System.Text.Json`                                                                                      |
| Node.js             | `node:http`                                                                                                                                                                                       | yes                                                                                                     |
| Bun                 | `Bun.serve`                                                                                                                                                                                       | yes                                                                                                     |
| Deno                | `Deno.serve`                                                                                                                                                                                      | yes                                                                                                     |
| Java, both subjects | `com.sun.net.httpserver`, a basic server                                                                                                                                                          | none. [JEP 540](https://openjdk.org/jeps/540) adds an incubator module, `jdk.incubator.json`, in JDK 28 |
| Python              | `http.server`, which "is not recommended for production" ([Python docs](https://docs.python.org/3/library/http.server.html))                                                                      | `json`                                                                                                  |
| PHP                 | The built-in server "is not intended for production usage" ([PHP docs](https://www.php.net/manual/en/features.commandline.webserver.php)). php-fpm ships with PHP and needs a web server in front | yes                                                                                                     |
| Ruby                | none. WEBrick left the standard library in Ruby 3.0 ([release notes](https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/))                                                          | `json`, a default gem                                                                                   |
| Rust                | none                                                                                                                                                                                              | none                                                                                                    |
| C++                 | none                                                                                                                                                                                              | none                                                                                                    |

The gap is not limited to Rust and C++. Java has no JSON, Ruby has no server, and
the docs of Python and PHP rule out their built-in servers for production. For PHP
the standard library tier would run on php-fpm, which puts a web server such as
nginx into the measured path.

## Open points

- **How strict the standard library tier is.** Three readings are possible.
  1. A subject enters only if its standard library has both a server and JSON.
     That leaves Go, C#, Node.js, Bun, Deno and Python.
  2. Every subject enters, and anything missing is hand-written on the standard
     library. Each hand-written part is recorded and flagged. This measures the
     implementer for those parts, the risk in HY-0003.
  3. Only standard libraries that can serve production traffic count. That leaves
     roughly Go, C#, Node.js, Bun and Deno.
- **The rule that picks the library per subject** for the micro library and the
  full framework tier, in the way DE-0001 picks the languages.
- **The boundary between micro library and full framework.** FastAPI and ASP.NET
  Core minimal APIs sit close to it.
- **Subjects without a clear full framework,** such as Go and C++. They may have no
  third tier, or the same library in tiers 2 and 3.
- **The C++ compiler.**
- **The web server in front of php-fpm,** and whether it counts as part of PHP.

## Where this leads

- A decision on subjects and tiers. It turns the DE-0001 languages into 12
  subjects and the two tiers of docs/objective.md into three.
- Changes to docs/glossary.md. The server needs a term, and the tier needs a new
  definition with three values.
- Three tiers across 12 subjects mean up to 36 implementations of the application.
  That raises the weight of HY-0003, one implementer per subject.
