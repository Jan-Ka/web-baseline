# SP-0001. Marketplace

Status: draft

This spec defines the application that every implementation builds, per DE-0002.
DE-0004 sets its layout. This file holds the rules. `openapi.yaml` holds the JSON
routes, `pages.md` holds the HTML pages, `flows/` and `checks/` hold the k6 scripts,
and `fixtures/` holds the seed data.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in BCP 14 (RFC 2119, RFC 8174) when, and
only when, they appear in all capitals, as shown here.

## Scope

The application is a small marketplace for a maker community. It has three parts.

1. **Shop.** Products, a cart and a checkout.
2. **Community.** Threads, posts, likes and product reviews.
3. **Seller desk.** One task per order and seller, which the seller advances.

The application serves HTML pages for reading and a JSON API for actions. It has no
admin area, no search, no file upload and no email.

## Server

1. The server MUST listen on the port in the environment variable `PORT`.
2. The server MUST speak HTTP/1.1 with keep-alive.
3. The server MUST read the seed file named in the environment variable
   `SEED_FILE` at startup, before it accepts a connection.
4. The server MUST hold all state in its own process. It MUST NOT use a database,
   a cache server or any other process.
5. The server MUST answer `GET /health` with status 200, the body `ok` and the
   content type `text/plain`. This route MUST NOT call the store and MUST NOT read
   the session.

## Data model

All IDs are positive integers. The store assigns the next free ID per entity,
starting after the highest ID in the seed file. All times are UTC in RFC 3339
format with seconds, for example `2026-10-03T12:00:00Z`.

| Entity       | Fields                                                                          |
| ------------ | ------------------------------------------------------------------------------- |
| User         | `id`, `email`, `display_name`, `password`, `role`, `created_at`                 |
| Session      | `token`, `user_id`, `created_at`                                                |
| Product      | `id`, `seller_id`, `title`, `description`, `price_cents`, `stock`, `created_at` |
| Cart item    | `user_id`, `product_id`, `quantity`                                             |
| Order        | `id`, `user_id`, `total_cents`, `created_at`                                    |
| Order line   | `order_id`, `product_id`, `quantity`, `unit_price_cents`                        |
| Task         | `id`, `order_id`, `seller_id`, `state`, `created_at`                            |
| Task comment | `id`, `task_id`, `author_id`, `body`, `created_at`                              |
| Review       | `id`, `product_id`, `user_id`, `rating`, `body`, `created_at`                   |
| Thread       | `id`, `author_id`, `title`, `created_at`                                        |
| Post         | `id`, `thread_id`, `author_id`, `body`, `created_at`                            |
| Like         | `post_id`, `user_id`                                                            |

- `role` is `shopper` or `seller`.
- `state` is `open`, `packed` or `shipped`.
- `rating` is an integer from 1 to 5.
- Money is an integer number of cents. The application does no currency
  conversion and no rounding.
- The first post of a thread holds the text the author wrote when the thread
  started.

## Store

The store stands in for a database, per DE-0002 and PR-0007. It MUST hold the data
in memory, behind one interface. Every operation in the table below is one store
call.

1. Each store call MUST wait `STORE_WAIT_MS` milliseconds on a timer before it
   returns. The wait MUST NOT block other requests.
2. A route MUST make exactly the store calls that `openapi.yaml` and `pages.md`
   list for it, in that order. It MUST NOT make other store calls.
3. A store call that writes MUST be atomic. Concurrent requests MUST NOT see a
   partial write.

| Store call            | Effect                                                                       |
| --------------------- | ---------------------------------------------------------------------------- |
| `user_by_email`       | Returns the user with the email, or nothing                                  |
| `user_create`         | Creates a user. Fails if the email exists                                    |
| `session_create`      | Creates a session for a user                                                 |
| `session_get`         | Returns the session and its user for a token, or nothing                     |
| `session_delete`      | Deletes a session                                                            |
| `products_page`       | Returns one page of products, newest first, and the total count              |
| `product_get`         | Returns one product and its seller                                           |
| `reviews_for_product` | Returns the reviews of a product, newest first, with the author names        |
| `review_create`       | Creates a review. Fails if the user has a review for the product             |
| `user_bought_product` | Returns whether an order line of the user holds the product                  |
| `cart_get`            | Returns the cart items of a user with their products                         |
| `cart_set`            | Sets the quantity of a product in a cart. Quantity 0 deletes the item        |
| `checkout`            | Runs the checkout rule below as one atomic write                             |
| `order_get`           | Returns one order with its lines                                             |
| `threads_page`        | Returns one page of threads, newest activity first, and the total count      |
| `thread_create`       | Creates a thread and its first post                                          |
| `thread_get`          | Returns one thread with its posts, oldest first, and the like count per post |
| `post_create`         | Creates a post in a thread                                                   |
| `like_set`            | Sets or deletes the like of a user on a post                                 |
| `tasks_for_seller`    | Returns the tasks of a seller, filtered by state, oldest first               |
| `task_advance`        | Moves a task to its next state                                               |
| `task_comment_create` | Creates a task comment                                                       |

## Sessions

1. Login and registration MUST create a session and set the cookie `sid` with the
   session token. The cookie MUST carry `HttpOnly`, `SameSite=Lax` and `Path=/`. It
   MUST NOT carry `Secure`, because the measured path has no TLS.
2. The token MUST hold at least 128 bits from the secure random source of the
   platform, encoded as lowercase hexadecimal.
3. A route that needs a user MUST read the cookie and call `session_get`. A JSON
   route without a valid session MUST answer 401. A page without a valid session
   MUST answer 303 with `Location: /login`.
4. Logout MUST call `session_delete` and MUST clear the cookie.
5. Sessions do not expire during a run.

## Password check

The password check stands in for a password hash, per DE-0002.

1. The seed file and registration store the password as plain text.
2. Login MUST do these steps in order.
   1. Call `user_by_email`.
   2. Wait `PASSWORD_WAIT_MS` milliseconds on a timer.
   3. Compare the passwords.
3. The wait MUST also happen when the user does not exist. The wait MUST NOT block
   other requests.
4. Registration MUST wait `PASSWORD_WAIT_MS` milliseconds before `user_create`.

## Business rules

### Validation

A JSON route that receives an invalid body MUST answer 422 with a JSON body that
names each invalid field. It MUST NOT change the store.

| Field          | Rule                                                          |
| -------------- | ------------------------------------------------------------- |
| `email`        | 3 to 254 characters, exactly one `@`, not at the start or end |
| `display_name` | 1 to 50 characters after trimming whitespace                  |
| `password`     | 8 to 128 characters                                           |
| `role`         | `shopper` or `seller`                                         |
| `quantity`     | integer from 0 to 99                                          |
| `rating`       | integer from 1 to 5                                           |
| `title`        | 1 to 120 characters after trimming whitespace                 |
| `body`         | 1 to 5,000 characters after trimming whitespace               |

### Pages of lists

Lists show 20 items per page. The query parameter `page` starts at 1. A page past
the end shows no items and answers 200.

### Cart and checkout

1. Only a user with role `shopper` has a cart.
2. `cart_set` with a quantity above the stock of the product MUST fail with 409.
3. The checkout MUST fail with 409 if the cart is empty or if any quantity exceeds
   the stock at that moment. A failed checkout changes nothing.
4. A successful checkout MUST do these steps as one atomic write.
   1. Lower the stock of each product by its quantity.
   2. Create an order with one line per cart item, at the current price.
   3. Set `total_cents` to the sum of quantity times unit price over all lines.
   4. Create one task in state `open` per seller in the order.
   5. Empty the cart.

### Reviews

1. Only a user who bought the product MAY review it. Otherwise the route MUST
   answer 403.
2. A user MAY review a product once. A second review MUST answer 409.

### Threads, posts and likes

1. Any logged in user MAY start a thread. Any logged in user MAY add a post to a
   thread.
2. A like MUST be unique per user and post. Setting an existing like or deleting a
   missing like MUST answer 204 and change nothing.
3. A thread's activity time is the time of its newest post.

### Seller desk

1. Only the seller of a task MAY see, advance or comment on it. The route MUST
   answer 403 for any other user.
2. `task_advance` moves `open` to `packed` and `packed` to `shipped`. Advancing a
   `shipped` task MUST answer 409.

## Parameters

| Parameter          | Value | Status                                |
| ------------------ | ----- | ------------------------------------- |
| `STORE_WAIT_MS`    | 1     | proposal, to register as a hypothesis |
| `PASSWORD_WAIT_MS` | 50    | proposal, to register as a hypothesis |
| Page size          | 20    | fixed by this spec                    |

## Routes

`openapi.yaml` defines the JSON routes and `pages.md` defines the HTML pages. Both
list the store calls per route. This table gives the overview.

| Method | Path                         | Kind | Needs       |
| ------ | ---------------------------- | ---- | ----------- |
| GET    | `/health`                    | text | nothing     |
| GET    | `/`                          | page | nothing     |
| GET    | `/products`                  | page | nothing     |
| GET    | `/products/{id}`             | page | nothing     |
| GET    | `/threads`                   | page | nothing     |
| GET    | `/threads/{id}`              | page | nothing     |
| GET    | `/login`                     | page | nothing     |
| GET    | `/register`                  | page | nothing     |
| GET    | `/cart`                      | page | shopper     |
| GET    | `/orders/{id}`               | page | order owner |
| GET    | `/desk`                      | page | seller      |
| POST   | `/api/register`              | JSON | nothing     |
| POST   | `/api/login`                 | JSON | nothing     |
| POST   | `/api/logout`                | JSON | session     |
| PUT    | `/api/cart/items/{product}`  | JSON | shopper     |
| POST   | `/api/checkout`              | JSON | shopper     |
| POST   | `/api/products/{id}/reviews` | JSON | buyer       |
| POST   | `/api/threads`               | JSON | session     |
| POST   | `/api/threads/{id}/posts`    | JSON | session     |
| PUT    | `/api/posts/{id}/like`       | JSON | session     |
| DELETE | `/api/posts/{id}/like`       | JSON | session     |
| GET    | `/api/desk/tasks`            | JSON | seller      |
| POST   | `/api/tasks/{id}/advance`    | JSON | task seller |
| POST   | `/api/tasks/{id}/comments`   | JSON | task seller |
