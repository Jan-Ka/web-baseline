# Spec format

Last revised: 2026-10-03

This document collects the data for how SP-0001, the application spec from DE-0002,
is structured and written. It covers how comparable projects define their specs,
which standard formats exist, and which tools can run a spec as a test. DE-0004 settles
it.

The status rule in docs/prior-art.md applies. Each source says whether it was read
from the page or from a search summary.

## What the spec has to cover

DE-0002 lists the content. Each part has a different shape.

1. **Rules.** The data model, the business rules such as checkout and task states,
   the session and the stand-ins. This is prose.
2. **JSON routes.** Method, path, input, validation, response body and status
   codes. This is an API contract.
3. **HTML pages.** Which elements a page holds, so that a check can find them.
   This is a page contract.
4. **Flows.** The sequence of requests per user flow, with values passed from one
   response to the next request, and the session cookie.
5. **Fixtures.** The seed dataset and the reset between runs.
6. **Conformance.** The checks that every implementation passes before
   measurement, per PR-0009.

## How comparable projects do it

### RealWorld

Read from the repository [gothinkster/realworld](https://github.com/gothinkster/realworld)
on 2026-10-03.

- `specs/api/openapi.yml` holds the API contract.
- `specs/api/hurl/` holds one Hurl file per area, such as auth, articles,
  comments, and one file per area for error cases. The README says "The Hurl files
  are the source of truth".
- `specs/api/bruno/` holds a Bruno collection. A script generates it from the Hurl
  files, and CI checks that the two stay in sync.
- `specs/e2e/` holds Playwright tests for the frontend and a file
  `SELECTORS.md`, which names the elements the tests look for.
- Prose pages under `docs/` describe endpoints, the response format and error
  handling.

### HttpArena

Read from the repository on 2026-10-03, see docs/prior-art.md.

- An OpenAPI 3.0 file covers every endpoint, with request and response schemas.
- Each test profile has an implementation page and a validation page in prose.
  The implementation page gives the contract, the parameters and the rules for
  the standard and tuned types.
- A validation script checks each implementation before the benchmark.

### TodoMVC

Read from [app-spec.md](https://github.com/tastejs/todomvc/blob/master/app-spec.md)
through a page summary. The spec is prose with sections for structure and for each
feature. It has no keywords for requirement levels and no automatic check.
Maintainers check implementations by hand.

## Formats

| Part        | Format                        | What it does                                                                                                                                          | Source                                                                                                     | Read from      |
| ----------- | ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | -------------- |
| Rules       | Markdown with BCP 14 keywords | MUST, SHOULD and MAY carry a defined meaning "when, and only when, they appear in all capitals"                                                       | [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174)                                                         | page           |
| JSON routes | OpenAPI 3                     | Paths, methods, parameters, request and response schemas. Used by RealWorld and HttpArena                                                             | RealWorld and HttpArena repositories                                                                       | page           |
| Flows       | Arazzo 1.0                    | An OpenAPI Initiative standard for "sequences of calls" and "the dependencies between them", with steps, runtime expressions and success criteria     | [Arazzo 1.0.1](https://spec.openapis.org/arazzo/v1.0)                                                      | search summary |
| Flows       | Hurl                          | Plain text files of HTTP requests with asserts and captures. Asserts can use JSONPath and XPath. Requests in one file share a cookie store by default | [Hurl manual](https://hurl.dev/docs/manual.html), [asserts](https://hurl.dev/docs/asserting-response.html) | page           |
| HTML pages  | Selector list                 | A list of stable element names that tests look for. RealWorld uses `SELECTORS.md`                                                                     | RealWorld repository                                                                                       | page           |

Two tools run these formats.

- Hurl runs its own files and reports pass or fail per assert. XPath 1.0 works on
  HTML responses.
- Redocly Respect runs Arazzo files against a server and checks the success
  criteria and the response schemas from the linked OpenAPI file. Read from a
  search summary of the [Redocly docs](https://redocly.com/docs/cli/commands/respect.md).
  Whether it handles cookies and HTML responses was not found.

## Tools for flows, conformance and load

The flows serve two purposes. The conformance suite runs each flow once and checks
every response. The load generator runs the flows many times in parallel. A tool
that does both from one source keeps the two from drifting apart.

GitHub data read through the API on 2026-10-03.

| Tool      | Kind                  | Language of the tool | Flow scripts in                             | License    | Stars  | Last push  |
| --------- | --------------------- | -------------------- | ------------------------------------------- | ---------- | ------ | ---------- |
| k6        | load and checks       | Go                   | JavaScript, TypeScript                      | AGPL-3.0   | 31,767 | 2026-10-02 |
| Gatling   | load and checks       | Scala, on the JVM    | Java, Kotlin, Scala, JavaScript, TypeScript | Apache-2.0 | 6,955  | 2026-09-29 |
| Locust    | load                  | Python               | Python                                      | MIT        | 28,196 | 2026-10-03 |
| Artillery | load and checks       | TypeScript, Node.js  | YAML, JavaScript                            | MPL-2.0    | 9,087  | 2026-09-23 |
| Hurl      | checks                | Rust                 | Hurl text format                            | Apache-2.0 | 19,234 | 2026-10-03 |
| Bruno     | API client and checks | JavaScript           | Bruno text format                           | MIT        | 47,330 | 2026-10-01 |
| Newman    | runs Postman checks   | JavaScript           | Postman collections                         | Apache-2.0 | 7,257  | 2026-09-30 |
| Step CI   | checks                | TypeScript           | YAML                                        | MPL-2.0    | 1,868  | 2024-08-03 |
| vegeta    | load, one request     | Go                   | request lists                               | MIT        | 25,215 | 2026-09-24 |

The candidates compare as follows for this project.

- **k6.** "By default, k6 has a cookie jar for each VU", and the jar resets after
  each iteration unless `noCookiesReset` is set. One iteration can therefore be
  one user session. `k6/html` parses HTML with "a jQuery-like API", and checks
  cover JSON and HTML. The executors `constant-arrival-rate` and
  `ramping-arrival-rate` implement the open model, which avoids the coordinated
  omission of a closed model. Read from the
  [k6 docs](https://grafana.com/docs/k6/latest/using-k6/cookies/).
- **Gatling.** Checks support CSS selectors, XPath and JSONPath. Injection
  supports both open and closed models. The SDKs cover Java, Kotlin, Scala and
  JavaScript or TypeScript. Read from the
  [Gatling docs](https://docs.gatling.io/concepts/checks/). Cookie handling per
  virtual user was not found on the pages read.
- **Locust.** Flows are Python code. The docs report about 16,000 requests per
  second with `FastHttpUser` and 4,000 with `HttpUser` on a 2021 MacBook Pro, so
  the load generator itself needs more CPU than a Go or JVM tool. Read from the
  [Locust docs](https://docs.locust.io/en/stable/increase-performance.html).
- **Artillery.** Scenarios in YAML with captures. This survey did not read its
  docs in detail.
- **Hurl, Bruno, Newman and Step CI** run checks, not load. A second tool would
  run the load, from a second copy of the flows or from a generator. Step CI has
  had no push since 2024.
- **vegeta** sends a fixed list of requests and cannot run a session.

## Observations

1. Both projects with automatic checks split the spec into a machine readable
   contract and prose. RealWorld adds executable tests as the source of truth.
2. OpenAPI covers the JSON routes well. It does not describe what an HTML page
   holds. RealWorld fills that gap with a selector list.
3. Hurl covers the flows and the conformance checks in one file per flow, but it
   does not generate load.
4. Arazzo is the standard format for flows, but it targets JSON APIs. Its support
   for cookies and HTML pages is not checked yet.
5. The load generator also needs the flows. If the conformance suite and the load
   scripts hold the flows separately, the two can drift apart. RealWorld solves the
   same problem for Hurl and Bruno with one source and a generator that CI checks.
   k6 and Gatling avoid the problem, because one script runs as a check with one
   user and as load with many.
6. k6 matches the flows closely. One iteration is one session with its own cookie
   jar, and the open model executors fit the fixed rate measurement that
   HttpArena uses. The choice of load generator belongs to the measurement method
   and to HY-0005, so a choice here commits that method in advance.
7. BCP 14 keywords give each rule a defined strength. That fits the strict mode of
   ASD-STE100 for instructions.

## Open points

- Which tool holds the flows. One tool for checks and load, such as k6 or
  Gatling, or a check tool such as Hurl with a generator for the load scripts.
- How the HTML pages are made checkable, for example with stable attributes on
  the required elements.
- How the seed dataset is stored, as a static file or as a generator with a fixed
  seed.
- Whether the spec uses BCP 14 keywords.
- The layout of specs/ in the repository.
