# DE-0002. The workload is a small marketplace driven by user flows

Date: 2026-10-03

## Question

What does the workload contain, and what does representative mean for it?

## Data

From docs/research/workload.md.

- The existing suites agree on a small core without a connector. It holds a minimal
  request, JSON serialization and reading a request body. Each suite tests these
  parts one endpoint at a time.
- No source found gives the request mix or the response sizes of real web
  applications.
- Two fleet studies report that most server CPU goes to work around the
  application logic, such as serialization, compression and allocation. This
  project relies on that claim under HY-0010.
- HttpArena replaces the database call with a timer wait, to measure what a server
  does while a request waits. This project borrows that under HY-0009.

## Reasoning

An isolated endpoint measures one part of a request. A real request passes through
all parts in sequence. These are HTTP parsing, routing, session lookup, input
parsing and validation, a call to the data store, the business rules, and JSON or
HTML rendering. How a language implementation handles that sequence, with allocations
across layers and a wait in the middle, is the property the comparison asks about.
A set of isolated endpoints cannot show it.

Real users also produce requests in sessions. They register, log in, read pages,
write, and log out. Sessions bring cookies, state per user and a store that grows
during the run. A load made of user flows keeps that.

No source gives a request mix, so the workload cannot copy a measured one. It can
require that every request passes through the parts a web application runs in
its own process. That is the definition of representative below.

The domain combines a shop, a community and a task board, three common kinds of
site. Together they give reads and writes, JSON and HTML, anonymous and logged in
users, and flows that depend on each other. Each part stays thin, because a larger
spec widens the gap between implementers, see HY-0003.

PR-0007 keeps connectors out of the measured path, and docs/objective.md excludes
authentication libraries. Stand-ins keep the work of both in the request path. The
store is in-process and waits on a timer, and the password check waits on a timer
in place of a hash.

## Decision

The workload is representative when each request passes through the parts that a
web application runs in its own process, and when the requests arrive in the order
that users produce them, in sessions. The parts are HTTP parsing, routing, session
lookup, input parsing and validation, a call to the data store, the business rules,
and JSON or HTML rendering.

The workload is one application that meets that definition.

1. **Domain.** A small marketplace for a maker community, with three parts. The
   shop has a catalogue, product pages, a cart and a checkout. The community has
   threads and product reviews with comments and likes. The seller desk turns
   each order into tasks that the seller moves through states. There is no admin
   area and no search.
2. **Load.** Scripted user sessions in four flows. A visitor browses without an
   account. A shopper registers or logs in, buys and reviews. A community member
   reads, posts and replies. A seller works through the tasks that orders create.
3. **Stand-ins.** The store is in-process, behind a repository interface, and
   each call waits a fixed time on a timer. Login issues a session token in a
   cookie, and each later request finds the session in the store. The password
   check waits a fixed time on a timer. No connector, no authentication library
   and no hashing library is in the measured path.
4. **Fixtures.** A deterministic seed dataset that lets every flow start at once,
   the flow scripts with their weights, the expected responses, and a reset of the
   store between runs.
5. **Specification.** SP-0001 defines the routes, pages, rules, data, flows and
   wait times. The conformance suite of PR-0009 runs the flows once and checks
   every response.

## Consequences

- The load generator must keep cookies and run a script per user. Tools that send
  one fixed request, such as wrk, do not fit. HY-0005 has to be settled with a tool
  that runs scripts.
- No source gives the flow weights or the wait times. SP-0001 sets them and
  registers each one as a hypothesis.
- The rate model, the HTTP version, TLS and response compression belong to the
  measurement method. This decision does not settle them.
- Every subject implements the whole application once per tier. The tiers and the
  subjects are still open, see docs/research/subjects-and-tiers.md.
- A whole application gives an implementer more room than an endpoint. That raises
  the weight of HY-0003.
- This decision answers the first open question in docs/objective.md.
  docs/glossary.md now defines workload and representative through it.
