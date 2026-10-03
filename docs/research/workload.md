# Workload

Last revised: 2026-10-03

This document collects the data for the workload decision, DE-0002. It covers what
the existing suites test, what real web traffic looks like, and where a server
spends its time on a request.

All data comes from desk research on 2026-10-03 and none of it is checked yet. The
status rule in docs/prior-art.md applies.

## What the existing suites test

| Suite                 | Endpoints without a database                                                                                                            | Endpoints with a database or other connector                   |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| TechEmpower, archived | plaintext, JSON serialization                                                                                                           | single query, multiple queries, fortunes, updates              |
| the-benchmarker       | `GET /` with an empty body, `GET /user/:id`, `POST /user` with an empty body                                                            | none                                                           |
| HttpArena             | baseline, JSON with compression, JSON over TLS, 10 KB echo, async delay, static files, short-lived connections, fixed-rate CPU profiles | async database, fortunes, production stack with auth and cache |
| Viitanen 2025         | a static OpenAPI file                                                                                                                   | a report over 1,000 rows                                       |

docs/prior-art.md has the details for each suite. HttpArena is the closest to this
project. Its profiles without a database cover these parts of a request.

- **Baseline.** `GET` and `POST /baseline11?a=13&b=42`, with a body sent with
  Content-Length or chunked. The response is the sum of the values. It exercises
  request parsing, the query string, body reading and the response path.
- **JSON.** `GET /json/{count}?m={multiplier}` takes the first 25, 40 or 50 items of
  a 50 item dataset loaded at startup, computes a total per item, and serializes
  the result. A variant compresses it with gzip or Brotli.
- **Echo.** A 10 KB body posted over TLS and returned unchanged, at a fixed rate.
- **Async delay.** `GET /delay/{ms}` waits 10 ms on a timer and answers, with 32,000
  connections held open. The docs say it measures "what a framework does with a
  request it cannot answer yet", with "no database, no network hop, no
  serialization, no I/O of any kind".
- **Fixed rate.** The baseline endpoint at a paced one million or ten thousand
  requests per second. The metric is CPU time per request, read from the cgroup.

## What real traffic looks like

| Finding                                                                                    | Source                                                                                                                 | Read from      |
| ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- | -------------- |
| API requests are 57 percent of dynamic HTTP traffic at Cloudflare                          | [Cloudflare API Security and Management Report](https://www.cloudflare.com/2024-api-security-management-report/), 2024 | search summary |
| REST is used by 93 percent of respondents, webhooks 50, WebSockets 35, GraphQL 33, gRPC 14 | Postman State of the API 2025, 5,700 respondents                                                                       | search summary |
| HTTP/2 carries about 50 percent and HTTP/3 about 21 percent of web requests                | [Cloudflare Radar Year in Review 2025](https://radar.cloudflare.com/year-in-review)                                    | search summary |
| The median HTML document of a home page is 21.9 KB compressed and 101.5 KB uncompressed    | HTTP Archive Web Almanac 2024, page weight chapter                                                                     | search summary |

No source found gives the size of a typical JSON API response from measured
traffic.

The HTTP version share is measured at the Cloudflare edge, between client and
proxy. It does not say which protocol the application server behind the proxy
speaks.

## Where a server spends its time

| Finding                                                                                                            | Source                                                                                                                                            | Read from      |
| ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| The "datacenter tax", the work that is not application logic, is nearly 30 percent of cycles across Google's fleet | Kanev et al., [Profiling a warehouse-scale computer](https://research.google/pubs/retrospective-profiling-a-warehouse-scale-computer/), ISCA 2015 | search summary |
| Facebook's top seven microservices spend as few as 18 percent of CPU cycles on core application logic              | Sriraman and Dhanotia, [Accelerometer](https://akshithasriraman.eecs.umich.edu/publication/asplos/accelerometer.pdf), ASPLOS 2020                 | search summary |

Both papers name serialization, compression, memory allocation and RPC handling as
parts of that overhead. The share of each part was not read.

## Observations

1. The suites agree on a small core without a connector. It holds a minimal
   request, JSON serialization, and reading a request body.
2. Only HttpArena keeps the waiting of a real request without the connector. Its
   delay endpoint replaces the database call with a timer.
3. Only HttpArena measures cost at a fixed rate. The other suites report the
   highest throughput a server reaches.
4. Real traffic is mostly APIs, and REST is the dominant style.
5. The two fleet studies say that most server CPU goes to work around the
   application logic, such as serialization and compression. A workload made of
   that work measures what a server spends most of its time on.
6. No source says what a typical request contains in detail. A definition of
   representative has to rest on the parts every request shares, not on a measured
   request mix.

## From endpoints to an application

Isolated endpoints test one part of a request each. A real request passes through
all parts in sequence. The direction taken on 2026-10-03 is an application that
users work through in end to end flows, with the waiting and the session handling
of a real site but without a connector.

### Domain

A small marketplace for a maker community, in three parts.

- **Shop.** A catalogue, product pages, a cart and a checkout. The checkout checks
  stock, computes totals and creates an order.
- **Community.** Discussion threads and product reviews, with comments and likes.
- **Seller desk.** Each order turns into tasks for the seller, such as pack, ship
  and answer a question. The seller moves tasks through states and comments on
  them.

Each part stays thin, with a few routes and simple rules. There is no admin area
and no search. The aim is a realistic mix of request types, not a complete
product. A larger spec widens the gap between implementers, see HY-0003.

### Flows

The load generator runs scripted user sessions, not single requests.

1. **Visitor.** Browses catalogue and forum pages without logging in.
2. **Shopper.** Registers or logs in, browses, adds to the cart, checks out,
   writes a review, logs out.
3. **Community member.** Logs in, reads threads, posts, replies, likes, logs out.
4. **Seller.** Logs in, opens the task board, advances orders, comments, logs
   out.

The flows depend on each other. A shopper's checkout creates the tasks a seller
works on.

### Stand-ins for the database and authentication

PR-0007 keeps connectors out of the measured path, and docs/objective.md excludes
authentication libraries. The application keeps the work of both in the request
path, without a connector or a library.

- **Database.** An in-process store behind a repository interface. Each call waits
  a fixed time on a timer, the way HttpArena's delay endpoint does.
- **Authentication.** Registration stores the user in the store. Login checks the
  password and issues a session token in a cookie. Each later request finds the
  session in the store. Logout deletes it. The password check waits a fixed time
  on a timer in place of a password hash, so that no hashing library enters the
  comparison.

### Fixtures

- A deterministic seed dataset, the same for every subject. It holds users in
  each role, products with stock, threads, and open orders. Every flow can start
  in the first second of a run.
- The flow scripts and their weights.
- The expected responses, so that the conformance suite runs the same flows once
  and checks each response.
- A reset of the store between runs, because the flows write to it.

## Open points

- The routes of each part and the pages each flow visits.
- The flow weights. No source gives a mix, so the weights become a hypothesis.
- The wait times for the store and for the password check.
- Whether the measurement runs at the highest reachable rate, at a fixed rate, or
  both.
- Which HTTP version and whether TLS is in the measured path.
- Whether response compression enters the workload.

## Where this leads

- DE-0002 sets the application, the flows, the stand-ins and the fixtures.
- The load generator must keep cookies and run a script per user. Tools that send
  one fixed request, such as wrk, do not fit. That affects HY-0005.
- The conformance suite of PR-0009 becomes the same flows, run once with checks.
- The application spec becomes the first SP- document under specs/.
