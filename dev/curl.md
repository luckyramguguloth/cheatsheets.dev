# curl Cheatsheet

> curl — transfer data to/from servers supporting HTTP, HTTPS, FTP, and more.
> Last verified: May 2026 | Version: 8.x

---

## Quick Reference

| Command | Description |
|---|---|
| `curl https://example.com` | Simple GET request |
| `curl -X POST -d '{"k":"v"}' -H 'Content-Type: application/json' URL` | POST JSON |
| `curl -u user:pass URL` | Basic authentication |
| `curl -H 'Authorization: Bearer TOKEN' URL` | Bearer token auth |
| `curl -o file.zip URL` | Save output to file |
| `curl -O URL` | Save with remote filename |
| `curl -L URL` | Follow redirects |
| `curl -v URL` | Verbose output |
| `curl -s URL` | Silent (no progress) |
| `curl -I URL` | HEAD request only |

---

## Basic Requests

### GET

```bash
# Simple GET
curl https://api.example.com/users

# With query parameters
curl "https://api.example.com/users?page=2&limit=10"

# Follow redirects (-L)
curl -L https://example.com

# Show response headers and body
curl -i https://api.example.com/users

# Show only response headers (HEAD request)
curl -I https://api.example.com/users

# Show only HTTP status code
curl -o /dev/null -s -w "%{http_code}" https://api.example.com/health

# Verbose output (headers, request info)
curl -v https://api.example.com/users

# Very verbose (SSL details)
curl --trace - https://api.example.com/users

# Specify HTTP version
curl --http1.1 https://api.example.com/users
curl --http2   https://api.example.com/users
curl --http3   https://api.example.com/users
```

---

## HTTP Methods

### POST

```bash
# POST with form data (application/x-www-form-urlencoded)
curl -X POST https://api.example.com/login \
  -d "username=alice&password=secret"

# POST with JSON body
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice", "email": "alice@example.com"}'

# POST JSON from file
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d @payload.json

# POST with multipart form data
curl -X POST https://api.example.com/upload \
  -F "file=@/path/to/photo.jpg" \
  -F "name=My Photo" \
  -F "description=A test upload"

# POST with raw body
curl -X POST https://api.example.com/data \
  -H "Content-Type: text/plain" \
  --data-raw "raw string data here"
```

### PUT & PATCH

```bash
# PUT (full resource update)
curl -X PUT https://api.example.com/users/42 \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice Updated", "email": "alice@example.com"}'

# PATCH (partial resource update)
curl -X PATCH https://api.example.com/users/42 \
  -H "Content-Type: application/json" \
  -d '{"email": "new@example.com"}'
```

### DELETE

```bash
# DELETE request
curl -X DELETE https://api.example.com/users/42

# DELETE with body (rare but valid)
curl -X DELETE https://api.example.com/users/42 \
  -H "Content-Type: application/json" \
  -d '{"reason": "account closed"}'
```

### OPTIONS & HEAD

```bash
# Check allowed methods (CORS preflight)
curl -X OPTIONS https://api.example.com/users \
  -H "Origin: https://app.example.com" \
  -H "Access-Control-Request-Method: POST" \
  -v

# HEAD — get headers without body
curl -X HEAD https://api.example.com/users/42 -I
```

---

## Headers

```bash
# Single header
curl -H "Content-Type: application/json" https://api.example.com

# Multiple headers
curl \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "X-Request-ID: abc-123" \
  https://api.example.com/users

# Override User-Agent
curl -H "User-Agent: MyApp/1.0" https://api.example.com

# Custom Accept header
curl -H "Accept: application/xml" https://api.example.com

# Remove a default header (empty value)
curl -H "Accept:" https://api.example.com

# Send raw headers
curl --header "X-Custom-Header: value" https://api.example.com

# View request and response headers
curl -v https://api.example.com 2>&1 | grep -E "^[<>]"
```

---

## Authentication

### Basic Auth

```bash
# Basic authentication (user:pass)
curl -u username:password https://api.example.com/profile

# Basic auth with -H header
curl -H "Authorization: Basic $(echo -n 'user:pass' | base64)" \
  https://api.example.com/profile

# Interactive password prompt (don't put password in command)
curl -u username https://api.example.com/profile
```

### Bearer Token

```bash
# Bearer token
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9..." \
  https://api.example.com/profile

# Using a variable
TOKEN="eyJhbGciOiJIUzI1NiJ9..."
curl -H "Authorization: Bearer $TOKEN" https://api.example.com/profile
```

### API Key

```bash
# API key in header
curl -H "X-API-Key: your-api-key-here" https://api.example.com/data

# API key as query parameter
curl "https://api.example.com/data?api_key=your-api-key-here"

# API key with Authorization header
curl -H "Authorization: ApiKey your-key-here" https://api.example.com/data
```

### OAuth 2.0

```bash
# Get access token (client credentials flow)
curl -X POST https://auth.example.com/oauth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials&client_id=CLIENT_ID&client_secret=CLIENT_SECRET&scope=read"

# Use access token
ACCESS_TOKEN=$(curl -s -X POST ... | jq -r '.access_token')
curl -H "Authorization: Bearer $ACCESS_TOKEN" https://api.example.com/data

# Digest authentication
curl --digest -u user:pass https://api.example.com/secure
```

### Client Certificate Auth

```bash
# mTLS with client certificate
curl --cert client.crt --key client.key https://api.example.com

# With CA bundle
curl --cert client.pem --cacert ca.pem https://api.example.com
```

---

## Output Options

```bash
# Save to a specific file
curl -o output.json https://api.example.com/data

# Save with the remote filename
curl -O https://example.com/archive.zip

# Save multiple files
curl -O https://example.com/file1.zip \
     -O https://example.com/file2.zip

# Download with progress bar
curl --progress-bar -o file.zip https://example.com/large.zip

# Resume interrupted download
curl -C - -O https://example.com/large.zip

# Silent mode (no output)
curl -s https://api.example.com/data

# Silent mode, show errors
curl -sS https://api.example.com/data

# Write output format (response code, timing)
curl -s -o /dev/null -w "HTTP %{http_code} | Time: %{time_total}s | Size: %{size_download} bytes\n" \
  https://api.example.com/data

# All write-out variables
curl -w "@curl-format.txt" -o /dev/null -s URL

# Redirect output
curl -s https://api.example.com/data > response.json
```

### Useful `-w` Format Variables

```bash
curl -w "\n
http_code:        %{http_code}
time_namelookup:  %{time_namelookup}
time_connect:     %{time_connect}
time_appconnect:  %{time_appconnect}
time_pretransfer: %{time_pretransfer}
time_starttransfer: %{time_starttransfer}
time_total:       %{time_total}
size_download:    %{size_download}
speed_download:   %{speed_download}
content_type:     %{content_type}
" -s -o /dev/null https://api.example.com
```

---

## File Upload

```bash
# Upload single file
curl -X POST https://api.example.com/upload \
  -F "file=@/path/to/document.pdf"

# Upload with custom field name and filename
curl -X POST https://api.example.com/upload \
  -F "attachment=@report.pdf;type=application/pdf;filename=Q1-Report.pdf"

# Upload multiple files
curl -X POST https://api.example.com/upload \
  -F "files[]=@photo1.jpg" \
  -F "files[]=@photo2.jpg" \
  -F "album=vacation"

# PUT file upload (binary stream)
curl -X PUT https://storage.example.com/my-object \
  -H "Content-Type: application/octet-stream" \
  --data-binary @/path/to/file.bin

# Upload with progress
curl -# -X POST https://api.example.com/upload \
  -F "file=@large-file.zip"
```

---

## Cookies

```bash
# Send a cookie
curl -b "session=abc123; theme=dark" https://example.com

# Save cookies to file
curl -c cookies.txt https://example.com/login \
  -d "user=alice&pass=secret"

# Load cookies from file
curl -b cookies.txt https://example.com/dashboard

# Save and load cookies in one session
curl -b cookies.txt -c cookies.txt https://example.com/

# Clear a cookie by sending empty value
curl -b "session=" https://example.com/logout
```

---

## SSL / TLS Options

```bash
# Skip SSL certificate verification (insecure!)
curl -k https://self-signed.example.com
curl --insecure https://self-signed.example.com

# Specify CA certificate bundle
curl --cacert /path/to/ca-bundle.crt https://internal.example.com

# Add custom CA
curl --capath /etc/ssl/certs/ https://example.com

# Specify TLS version
curl --tls-max 1.2 https://example.com
curl --tlsv1.3 https://example.com

# Client certificate (mTLS)
curl --cert client.crt --key client.key https://api.example.com

# Client certificate in PEM format (cert+key in one file)
curl --cert combined.pem https://api.example.com

# Show SSL certificate info
curl -v https://example.com 2>&1 | grep -A 20 "SSL"
curl --cert-status https://example.com

# Pin certificate
curl --pinnedpubkey sha256//HASH= https://example.com
```

---

## Request Timing & Rate Limiting

```bash
# Set connection timeout (seconds)
curl --connect-timeout 10 https://api.example.com

# Set max total time
curl --max-time 30 https://api.example.com

# Limit download speed
curl --limit-rate 1M -O https://example.com/large.zip

# Retry on failure
curl --retry 3 https://api.example.com/data

# Retry with delay
curl --retry 3 --retry-delay 5 https://api.example.com/data

# Retry on specific errors
curl --retry 3 --retry-connrefused https://api.example.com

# Max number of redirects
curl --max-redirs 5 -L https://example.com
```

---

## Proxies

```bash
# HTTP proxy
curl -x http://proxy.example.com:8080 https://api.example.com

# HTTPS proxy
curl -x https://proxy.example.com:8080 https://api.example.com

# SOCKS5 proxy
curl --socks5 127.0.0.1:1080 https://api.example.com

# SOCKS5 with DNS via proxy
curl --socks5-hostname 127.0.0.1:1080 https://api.example.com

# Proxy authentication
curl -x http://user:pass@proxy.example.com:8080 https://api.example.com

# Bypass proxy for specific hosts
curl --noproxy "internal.example.com,*.local" -x proxy:8080 https://api.example.com
```

---

## Common API Patterns

### REST API with JSON

```bash
# GET with auth and JSON accept
curl -s \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json" \
  https://api.example.com/users | jq .

# POST JSON resource
curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice", "role": "admin"}' \
  https://api.example.com/users | jq .

# PATCH (partial update)
curl -s -X PATCH \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"email": "newemail@example.com"}' \
  https://api.example.com/users/42 | jq .

# DELETE
curl -s -X DELETE \
  -H "Authorization: Bearer $TOKEN" \
  https://api.example.com/users/42 \
  -o /dev/null -w "%{http_code}\n"
```

### GraphQL

```bash
# GraphQL query
curl -X POST https://api.example.com/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "query GetUser($id: ID!) { user(id: $id) { id name email } }",
    "variables": {"id": "42"}
  }'

# GraphQL mutation
curl -X POST https://api.example.com/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { createUser(name: \"Alice\") { id } }"
  }'
```

### Health Check / Monitoring

```bash
# Quick health check (exit code 0 = success, 1 = failure)
curl -fsS https://api.example.com/health > /dev/null && echo "UP" || echo "DOWN"

# Health check with timeout
curl -fs --max-time 5 https://api.example.com/health

# Check specific HTTP status
STATUS=$(curl -o /dev/null -s -w "%{http_code}" https://api.example.com/health)
[ "$STATUS" = "200" ] && echo "Healthy" || echo "Unhealthy: $STATUS"
```

### Downloading

```bash
# Download latest GitHub release
curl -sL "https://api.github.com/repos/owner/repo/releases/latest" \
  | jq -r '.assets[0].browser_download_url' \
  | xargs curl -LO

# Download with authentication
curl -L -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/owner/private-repo/zipball/main \
  -o repo.zip

# Get public IP
curl -s https://api.ipify.org

# Get weather
curl wttr.in/London
```

---

## Verbose & Debugging

```bash
# Verbose (-v): shows request/response headers
curl -v https://api.example.com/data

# Trace all bytes sent and received
curl --trace - https://api.example.com/data
curl --trace-ascii - https://api.example.com/data

# Include response headers in output
curl -i https://api.example.com/data

# Silent with only errors shown
curl -sSf https://api.example.com/data    # -f: fail on 4xx/5xx

# Fail on HTTP error (exit 1 on 4xx/5xx)
curl -f https://api.example.com/data
curl --fail-with-body https://api.example.com/data   # curl 7.76+

# Dry run (don't send, just show)
# Use --trace with /dev/null to see what would be sent
```

---

## Config File (~/.curlrc)

```bash
# ~/.curlrc — default options for all curl commands
# Useful for setting defaults

# Always follow redirects
location

# Always show errors in silent mode
show-error

# Set connect timeout
connect-timeout = 10

# Set max time
max-time = 30

# Use compressed transfer
compressed

# Default headers
header = "User-Agent: MyTool/1.0"
```

---

## Tips & Tricks

- Use `jq` to parse JSON responses: `curl -s URL | jq '.key'`
- Store API tokens in environment variables, never hardcode them
- Use `--netrc` or `~/.netrc` for credential management
- `curl -sS` is the best default: silent but shows errors
- Use `-f` (fail) to detect HTTP errors in scripts: exit non-zero on 4xx/5xx
- `--parallel` sends multiple URLs concurrently: `curl --parallel -O url1 -O url2`
- Use `--compressed` to accept gzip responses and auto-decompress
- `curl -w "%{http_code}"` is great for scripted health checks
- The `-K` flag reads options from a config file for complex requests
- Test APIs without SSL warnings in dev: `curl -k`, but never in production scripts
- `--resolve hostname:port:IP` overrides DNS for testing specific servers
- Use `--data-urlencode` to URL-encode individual POST fields

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
