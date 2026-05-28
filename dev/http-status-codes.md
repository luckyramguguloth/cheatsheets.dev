# HTTP Status Codes Cheatsheet

> Complete reference for HTTP status codes, meanings, and usage scenarios.
> Last verified: May 2026 | Version: HTTP/1.1 + HTTP/2 (RFC 9110)

---

## Quick Reference

| Range | Category | Use When |
|---|---|---|
| `1xx` | Informational | Request received, continuing |
| `2xx` | Success | Request was received and accepted |
| `3xx` | Redirection | Further action needed |
| `4xx` | Client Error | Client made a bad request |
| `5xx` | Server Error | Server failed to process |

---

## 1xx — Informational

| Code | Name | Description |
|---|---|---|
| `100` | Continue | Client should continue sending request body |
| `101` | Switching Protocols | Server agrees to protocol upgrade (e.g., WebSocket) |
| `102` | Processing | Server received request, still processing (WebDAV) |
| `103` | Early Hints | Preload headers before final response |

### Usage

```http
# 101 — WebSocket upgrade
GET /chat HTTP/1.1
Host: example.com
Upgrade: websocket
Connection: Upgrade

HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade

# 103 — Early Hints (speed up asset loading)
HTTP/1.1 103 Early Hints
Link: </style.css>; rel=preload; as=style
Link: </script.js>; rel=preload; as=script
```

---

## 2xx — Success

| Code | Name | When to Use |
|---|---|---|
| `200` | OK | Standard successful response |
| `201` | Created | Resource created (POST/PUT) |
| `202` | Accepted | Request accepted, processing async |
| `203` | Non-Authoritative Information | Response from cache/proxy |
| `204` | No Content | Success with no response body |
| `205` | Reset Content | Success, client should reset form/view |
| `206` | Partial Content | Range request (file download resume) |
| `207` | Multi-Status | Multiple sub-responses (WebDAV) |
| `208` | Already Reported | Members already reported (WebDAV) |
| `226` | IM Used | Delta encoding applied |

### Detailed Usage

```http
# 200 OK — GET, general success
GET /users/42 HTTP/1.1

HTTP/1.1 200 OK
Content-Type: application/json
Cache-Control: max-age=3600

{"id": 42, "name": "Alice"}

# 201 Created — POST created a resource
POST /users HTTP/1.1
Content-Type: application/json

{"name": "Bob", "email": "bob@example.com"}

HTTP/1.1 201 Created
Location: /users/43        ← include Location header
Content-Type: application/json

{"id": 43, "name": "Bob"}

# 204 No Content — DELETE, or PATCH with no body returned
DELETE /users/42 HTTP/1.1

HTTP/1.1 204 No Content

# 202 Accepted — Long-running async job
POST /reports/generate HTTP/1.1

HTTP/1.1 202 Accepted
Location: /reports/status/abc123

{"job_id": "abc123", "status": "queued"}

# 206 Partial Content — File resume / streaming
GET /video.mp4 HTTP/1.1
Range: bytes=1048576-

HTTP/1.1 206 Partial Content
Content-Range: bytes 1048576-2097152/5242880
Content-Type: video/mp4
Accept-Ranges: bytes
```

### Which 2xx to Return

| Scenario | Code |
|---|---|
| GET request returns data | 200 |
| POST creates a new resource | 201 |
| PUT/PATCH updates (body returned) | 200 |
| PUT/PATCH updates (no body) | 204 |
| DELETE successful | 204 |
| Async operation queued | 202 |
| Form submission, no redirect | 204 |

---

## 3xx — Redirection

| Code | Name | When to Use |
|---|---|---|
| `300` | Multiple Choices | Multiple representations available |
| `301` | Moved Permanently | URL permanently changed (SEO: passes link juice) |
| `302` | Found | Temporary redirect (legacy) |
| `303` | See Other | Redirect after POST to GET (PRG pattern) |
| `304` | Not Modified | Cached version is still valid |
| `307` | Temporary Redirect | Temporary, preserve HTTP method |
| `308` | Permanent Redirect | Permanent, preserve HTTP method |

### Detailed Usage

```http
# 301 Moved Permanently — domain change, old URLs
GET /old-page HTTP/1.1

HTTP/1.1 301 Moved Permanently
Location: https://example.com/new-page

# 302 Found — temporary redirect (but browser treats as GET)
HTTP/1.1 302 Found
Location: /maintenance

# 303 See Other — after POST, redirect to success page
POST /checkout HTTP/1.1

HTTP/1.1 303 See Other
Location: /order-confirmation/12345

# 304 Not Modified — conditional GET (ETag/Last-Modified)
GET /style.css HTTP/1.1
If-None-Match: "abc123"

HTTP/1.1 304 Not Modified
ETag: "abc123"
Cache-Control: max-age=86400

# 307 Temporary Redirect — preserve POST method
POST /api/submit HTTP/1.1

HTTP/1.1 307 Temporary Redirect
Location: https://api.example.com/submit

# 308 Permanent Redirect — preserve method permanently
POST /api/old HTTP/1.1

HTTP/1.1 308 Permanent Redirect
Location: https://api.example.com/new
```

### 301 vs 302 vs 307 vs 308

| Code | Permanent? | Method Preserved? | Use Case |
|---|---|---|---|
| `301` | ✅ Yes | ❌ No (becomes GET) | Old URL → new URL (SEO) |
| `302` | ❌ No | ❌ No (becomes GET) | Temporary redirect (avoid) |
| `303` | ❌ No | ❌ No (always GET) | After POST, show result |
| `307` | ❌ No | ✅ Yes | Temp redirect, keep method |
| `308` | ✅ Yes | ✅ Yes | Perm redirect, keep method |

---

## 4xx — Client Errors

| Code | Name | When to Use |
|---|---|---|
| `400` | Bad Request | Malformed syntax, invalid data |
| `401` | Unauthorized | Authentication required |
| `402` | Payment Required | Reserved, used for payment walls |
| `403` | Forbidden | Authenticated but not authorized |
| `404` | Not Found | Resource doesn't exist |
| `405` | Method Not Allowed | HTTP method not supported |
| `406` | Not Acceptable | Can't serve requested content type |
| `407` | Proxy Authentication Required | Must auth with proxy |
| `408` | Request Timeout | Client too slow to send request |
| `409` | Conflict | State conflict (duplicate, version mismatch) |
| `410` | Gone | Resource permanently deleted |
| `411` | Length Required | Content-Length header missing |
| `412` | Precondition Failed | Conditional request failed |
| `413` | Content Too Large | Request body too large |
| `414` | URI Too Long | URL exceeds server limit |
| `415` | Unsupported Media Type | Wrong Content-Type |
| `416` | Range Not Satisfiable | Invalid byte range request |
| `417` | Expectation Failed | Expect header can't be met |
| `418` | I'm a Teapot | Easter egg (RFC 2324) |
| `421` | Misdirected Request | Request sent to wrong server |
| `422` | Unprocessable Entity | Valid syntax but semantic errors |
| `423` | Locked | Resource locked (WebDAV) |
| `424` | Failed Dependency | Dependency failed (WebDAV) |
| `425` | Too Early | Replay attack risk |
| `426` | Upgrade Required | Client must upgrade protocol |
| `428` | Precondition Required | Must send conditional request |
| `429` | Too Many Requests | Rate limit exceeded |
| `431` | Request Header Fields Too Large | Headers too large |
| `451` | Unavailable For Legal Reasons | Legal restriction |

### Detailed Usage

```http
# 400 Bad Request — validation failed, malformed JSON
POST /users HTTP/1.1
Content-Type: application/json

{"email": "not-an-email"}

HTTP/1.1 400 Bad Request
Content-Type: application/problem+json

{
  "type": "https://example.com/probs/validation-error",
  "title": "Validation Error",
  "status": 400,
  "detail": "The 'email' field must be a valid email address.",
  "errors": {
    "email": ["Invalid email format"]
  }
}

# 401 Unauthorized — no/invalid credentials
GET /api/profile HTTP/1.1

HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer realm="api"

{"error": "Authentication required"}

# 403 Forbidden — authenticated but lacks permission
GET /admin/users HTTP/1.1
Authorization: Bearer user-token

HTTP/1.1 403 Forbidden

{"error": "Insufficient permissions"}

# 404 Not Found — resource doesn't exist
GET /users/99999 HTTP/1.1

HTTP/1.1 404 Not Found

{"error": "User not found"}

# 405 Method Not Allowed — use POST, not GET
GET /users HTTP/1.1  (only POST allowed)

HTTP/1.1 405 Method Not Allowed
Allow: GET, POST        ← always include this header

# 409 Conflict — email already exists
POST /users HTTP/1.1

HTTP/1.1 409 Conflict

{"error": "Email already in use"}

# 410 Gone — resource was deleted, will never return
GET /blog/old-post HTTP/1.1

HTTP/1.1 410 Gone

# 415 Unsupported Media Type — wrong Content-Type
POST /api/users HTTP/1.1
Content-Type: text/plain    ← should be application/json

HTTP/1.1 415 Unsupported Media Type
Accept: application/json

# 422 Unprocessable Entity — valid JSON, but business logic error
POST /orders HTTP/1.1
Content-Type: application/json

{"quantity": -5}

HTTP/1.1 422 Unprocessable Entity

{"error": "Quantity must be positive"}

# 429 Too Many Requests — rate limiting
GET /api/search HTTP/1.1

HTTP/1.1 429 Too Many Requests
Retry-After: 60
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1748428800

{"error": "Rate limit exceeded. Try again in 60 seconds."}
```

### 401 vs 403

| Code | Meaning | Example |
|---|---|---|
| `401` | Who are you? (no/bad credentials) | Not logged in |
| `403` | I know who you are, but no. (no permission) | User can't access admin |

### 404 vs 410

| Code | Meaning | Use Case |
|---|---|---|
| `404` | Unknown if ever existed | Random bad URL |
| `410` | Definitely existed, now gone | Deleted content, expired links |

---

## 5xx — Server Errors

| Code | Name | When to Use |
|---|---|---|
| `500` | Internal Server Error | Generic unhandled exception |
| `501` | Not Implemented | Feature/method not supported |
| `502` | Bad Gateway | Upstream server bad response |
| `503` | Service Unavailable | Down for maintenance / overloaded |
| `504` | Gateway Timeout | Upstream server timed out |
| `505` | HTTP Version Not Supported | HTTP version not supported |
| `506` | Variant Also Negotiates | Content negotiation loop |
| `507` | Insufficient Storage | Server out of disk space (WebDAV) |
| `508` | Loop Detected | Infinite redirect loop (WebDAV) |
| `510` | Not Extended | Extension required |
| `511` | Network Authentication Required | Captive portal (WiFi login) |

### Detailed Usage

```http
# 500 Internal Server Error — unhandled exception
GET /api/data HTTP/1.1

HTTP/1.1 500 Internal Server Error
Content-Type: application/json

{
  "error": "Internal Server Error",
  "request_id": "req_abc123"   ← helpful for debugging
}

# 502 Bad Gateway — reverse proxy can't reach upstream
# (Nginx can't connect to Node.js app)
HTTP/1.1 502 Bad Gateway

# 503 Service Unavailable — maintenance or overloaded
HTTP/1.1 503 Service Unavailable
Retry-After: 3600

{"error": "Service temporarily unavailable. Retry after 1 hour."}

# 504 Gateway Timeout — upstream too slow
# (DB query takes too long, Nginx times out)
HTTP/1.1 504 Gateway Timeout
```

### 500 vs 502 vs 503 vs 504

| Code | Who Failed? | Example |
|---|---|---|
| `500` | Your own app code | Unhandled exception |
| `502` | Upstream returned garbage | App crashed, proxy got garbage |
| `503` | Service not ready | Maintenance, overload |
| `504` | Upstream too slow | DB timeout, slow microservice |

---

## Common Headers by Status

| Status | Common Headers |
|---|---|
| `201 Created` | `Location: /resource/id` |
| `204 No Content` | (no body, no Content-Type) |
| `301/302/307/308` | `Location: /new-url` |
| `304 Not Modified` | `ETag`, `Cache-Control`, `Last-Modified` |
| `401 Unauthorized` | `WWW-Authenticate: Bearer realm="..."` |
| `405 Method Not Allowed` | `Allow: GET, POST, OPTIONS` |
| `429 Too Many Requests` | `Retry-After: 60`, `X-RateLimit-*` |
| `503 Service Unavailable` | `Retry-After: 3600` |
| All errors | `Content-Type: application/problem+json` |

---

## REST API Design Guide

```
GET    /resources       → 200 OK
GET    /resources/:id   → 200 OK or 404 Not Found
POST   /resources       → 201 Created + Location header
PUT    /resources/:id   → 200 OK or 204 No Content
PATCH  /resources/:id   → 200 OK or 204 No Content
DELETE /resources/:id   → 204 No Content or 404 Not Found

Authentication missing   → 401 Unauthorized
Permission denied        → 403 Forbidden
Validation failed        → 400 Bad Request or 422 Unprocessable Entity
Duplicate resource       → 409 Conflict
Rate limited             → 429 Too Many Requests
Server crashed           → 500 Internal Server Error
```

---

## Caching Headers

```http
# No caching
Cache-Control: no-store

# Must revalidate
Cache-Control: no-cache

# Cache for 1 hour
Cache-Control: max-age=3600

# Cache publicly for 1 day, privately for 1 hour
Cache-Control: public, max-age=86400, s-maxage=3600

# Immutable (versioned assets like main.abc123.js)
Cache-Control: public, max-age=31536000, immutable

# ETag for conditional requests
ETag: "33a64df551425fcc55e4d42a148795d9f25f89d"

# Last-Modified for conditional requests
Last-Modified: Wed, 28 May 2026 07:00:00 GMT
```

---

## Tips & Tricks

- Return `201 + Location` header on POST creation — never just `200`
- Use `422` for semantic validation errors, `400` for syntax/format errors
- Return `404` for unknown resources, `410` when you know it's deleted
- Include `Retry-After` with all `503` and `429` responses
- Never return `200` with an error body — clients can't detect it
- Use `problem+json` (RFC 9457) content type for structured error responses
- Include a `request_id` in `500` responses for server-side debugging
- The `Allow` header is required with `405 Method Not Allowed`
- Prefer `308` over `301` for permanent redirects when method must be preserved
- `204` must have no response body (some clients break if it does)
- Use `Cache-Control: immutable` on content-hashed static assets

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
