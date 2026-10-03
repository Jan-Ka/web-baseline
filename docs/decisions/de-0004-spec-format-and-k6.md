# DE-0004. The spec is prose, OpenAPI and k6 flows

Date: 2026-10-03

## Question

How is SP-0001 structured, and which tool runs its flows as conformance checks and
as load?

## Data

From docs/research/spec-format.md.

- RealWorld and HttpArena split their specs into an OpenAPI contract and prose.
  RealWorld keeps its executable tests as the source of truth and generates a
  second test collection from them, with a CI check that the two match.
- OpenAPI does not describe what an HTML page holds. RealWorld lists the elements
  its tests look for in a separate file.
- Hurl, Bruno and Newman run checks but no load. vegeta runs load but no session.
- k6 runs checks and load from one script, under HY-0012. It keeps a cookie jar
  per virtual user and resets it after each iteration. It parses HTML with a
  jQuery-like API. Its arrival rate executors implement the open model. It runs
  TypeScript files directly since v0.57, and it strips the types without checking
  them.
- Gatling offers checks and load as well, on the JVM. Locust needs more CPU per
  request on the load generator side.

## Reasoning

The flows serve the conformance suite and the load generator. One copy of the flows
for both removes the risk that the two drift apart. A check tool such as Hurl
would need a second tool and a generator for the load. k6 runs the same script
with one user as a check and with many users as load.

A k6 iteration with its own cookie jar is one user session. That matches the flows
of DE-0002 without extra code. The open model executors fit a measurement at a
fixed rate. k6 is a Go binary and needs less CPU per request than Locust, which
matters for HY-0005. Gatling would also work, but it adds a JVM to the load
generator and has a smaller community.

The flow scripts state their steps and expectations in code. Named groups and
named checks make each script read as the user's session. A prose copy of the
flows would repeat the code and could drift from it. The prose part of the spec
therefore holds only what the flows do not express. These are the data model, the
business rules, the session, the stand-ins and the wait times.

Each subject reads the same seed data. A static file serves that without asking
every language to reproduce one random generator. The store is in-process, so a
restart of the server returns it to the seed state.

## Decision

SP-0001 lives in `specs/sp-0001-marketplace/` with this layout.

| Path           | Contents                                                                                                            |
| -------------- | ------------------------------------------------------------------------------------------------------------------- |
| `README.md`    | The rules, written with the BCP 14 keywords of RFC 8174. Data model, business rules, session, stand-ins, wait times |
| `openapi.yaml` | The JSON routes, with request and response schemas                                                                  |
| `pages.md`     | The HTML page contract. Each required element carries a stable attribute that this file names                       |
| `flows/`       | One k6 script in TypeScript per user flow. The source for conformance and for load                                  |
| `checks/`      | k6 scripts in TypeScript for error and validation cases outside the flows                                           |
| `fixtures/`    | The seed dataset as a static file                                                                                   |

The rules are as follows.

1. The flow scripts are the only description of the flows. The prose does not
   repeat them.
2. The conformance suite runs every flow with one virtual user for one iteration
   and every script in `checks/`. An implementation passes when every check
   passes.
3. The load runs the same flow scripts with many virtual users, weighted per flow.
4. Each run starts a fresh server process, which loads the seed file. No reset
   route exists.

## Consequences

- k6 is the load generator. HY-0005 now concerns k6, and every run records the CPU
  and memory of the k6 process.
- k6 uses the AGPL-3.0 license. The project runs it without changes and does not
  ship it.
- TypeScript in k6 is not type checked. A type check of the flow scripts, if
  wanted, needs a separate step.
- Every implementation must read the seed file at startup and must mark its HTML
  pages with the attributes in `pages.md`.
- The measurement method still sets the rate model, the HTTP version and TLS.
- This decision answers the open points in docs/research/spec-format.md.
