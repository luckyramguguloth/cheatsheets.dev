# Nginx Cheatsheet

> Nginx — high-performance HTTP server, reverse proxy, and load balancer.
> Last verified: May 2026 | Version: 1.26.x (Stable)

---

## Quick Reference

| Command | Description |
|---|---|
| `nginx -t` | Test configuration syntax |
| `nginx -T` | Test and dump full config |
| `nginx -s reload` | Reload config (graceful) |
| `nginx -s stop` | Fast shutdown |
| `nginx -s quit` | Graceful shutdown |
| `systemctl reload nginx` | Reload via systemd |
| `systemctl status nginx` | Check status |
| `nginx -V` | Show compile options |

---

## Configuration Structure

```nginx
# /etc/nginx/nginx.conf

# Main context (global settings)
user www-data;
worker_processes auto;              # 1 per CPU core
worker_rlimit_nofile 65535;        # max file descriptors
pid /run/nginx.pid;

error_log /var/log/nginx/error.log warn;

# Events context
events {
    worker_connections 1024;        # max connections per worker
    use epoll;                      # Linux event method
    multi_accept on;
}

# HTTP context
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # Logging
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
    access_log /var/log/nginx/access.log main;

    # Performance
    sendfile        on;
    tcp_nopush      on;
    tcp_nodelay     on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    # Include virtual host configs
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

---

## Server Blocks (Virtual Hosts)

```nginx
# /etc/nginx/sites-available/example.com

server {
    listen 80;
    listen [::]:80;                 # IPv6
    server_name example.com www.example.com;
    root /var/www/example.com/html;
    index index.html index.htm;

    # Logs
    access_log /var/log/nginx/example.access.log;
    error_log  /var/log/nginx/example.error.log;

    location / {
        try_files $uri $uri/ =404;
    }
}

# Enable site (Debian/Ubuntu)
ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
```

---

## Location Blocks

```nginx
server {
    # Exact match (highest priority)
    location = /favicon.ico { }

    # Prefix match (starts with)
    location /images/ { }

    # Case-insensitive regex (~* lower priority than ^~)
    location ~* \.(jpg|jpeg|png|gif|ico|svg)$ {
        expires 30d;
    }

    # Case-sensitive regex
    location ~ \.php$ { }

    # Prefix (stop searching if matched — higher priority than regex)
    location ^~ /static/ {
        root /var/www;
    }

    # Named location (for internal redirects)
    location @fallback {
        return 302 /index.html;
    }
}

# Location priority order (highest to lowest):
# 1. = (exact)
# 2. ^~ (prefix, stops regex search)
# 3. ~ and ~* (regex, first match wins)
# 4. (prefix, longest match wins)
```

---

## Reverse Proxy

```nginx
# Basic reverse proxy to upstream app
server {
    listen 80;
    server_name app.example.com;

    location / {
        proxy_pass http://localhost:3000;

        # Pass headers to upstream
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Timeouts
        proxy_connect_timeout  60s;
        proxy_send_timeout     60s;
        proxy_read_timeout     60s;

        # Buffer settings
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
        proxy_busy_buffers_size 8k;

        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade    $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

---

## Upstream (Load Balancing)

```nginx
http {
    # Round-robin (default)
    upstream backend {
        server 10.0.0.1:3000;
        server 10.0.0.2:3000;
        server 10.0.0.3:3000;
    }

    # Weighted
    upstream backend {
        server 10.0.0.1:3000 weight=3;
        server 10.0.0.2:3000 weight=1;
    }

    # Least connections
    upstream backend {
        least_conn;
        server 10.0.0.1:3000;
        server 10.0.0.2:3000;
    }

    # IP hash (sticky sessions)
    upstream backend {
        ip_hash;
        server 10.0.0.1:3000;
        server 10.0.0.2:3000;
    }

    # Backup servers
    upstream backend {
        server 10.0.0.1:3000;
        server 10.0.0.2:3000;
        server 10.0.0.3:3000 backup;    # only used if others fail
    }

    # Mark server as down
    upstream backend {
        server 10.0.0.1:3000;
        server 10.0.0.2:3000 down;      # temporary out of rotation
    }

    # With health checks (Nginx Plus only; open-source: use proxy_next_upstream)
    upstream backend {
        server 10.0.0.1:3000 max_fails=3 fail_timeout=30s;
        server 10.0.0.2:3000 max_fails=3 fail_timeout=30s;
    }

    server {
        location / {
            proxy_pass http://backend;
            proxy_next_upstream error timeout http_500 http_502 http_503;
        }
    }
}
```

---

## SSL / TLS Setup

```nginx
# HTTP → HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name example.com www.example.com;
    return 301 https://$host$request_uri;
}

# HTTPS server
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name example.com www.example.com;

    # Certificate (Let's Encrypt)
    ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # Modern SSL configuration (from Mozilla SSL Config Generator)
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    # Session
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 1d;
    ssl_session_tickets off;

    # OCSP stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;
    resolver 1.1.1.1 8.8.8.8 valid=300s;

    # HSTS (1 year, include subdomains)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Content-Security-Policy "default-src 'self'" always;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

### Let's Encrypt with Certbot

```bash
# Install certbot
apt install certbot python3-certbot-nginx

# Obtain certificate and configure nginx automatically
certbot --nginx -d example.com -d www.example.com

# Obtain certificate only (no nginx config change)
certbot certonly --webroot -w /var/www/html -d example.com

# Renew all certificates
certbot renew

# Test renewal
certbot renew --dry-run

# Auto-renew via cron/systemd timer (certbot usually sets this up)
0 12 * * * /usr/bin/certbot renew --quiet
```

---

## Gzip Compression

```nginx
http {
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;             # 1 (fastest) - 9 (best compression)
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_min_length 256;           # don't compress tiny responses
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml
        application/rss+xml
        application/atom+xml
        application/geo+json
        image/svg+xml
        font/woff2;
}
```

---

## Caching

```nginx
http {
    # Define proxy cache zone
    proxy_cache_path /var/cache/nginx
        levels=1:2
        keys_zone=my_cache:10m
        max_size=10g
        inactive=60m
        use_temp_path=off;

    server {
        location / {
            proxy_cache my_cache;
            proxy_cache_valid 200 301 302 1d;
            proxy_cache_valid 404 1m;
            proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
            proxy_cache_background_update on;
            proxy_cache_lock on;

            # Add cache status header for debugging
            add_header X-Cache-Status $upstream_cache_status;

            proxy_pass http://backend;
        }

        # Static file caching (browser)
        location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff2)$ {
            expires 30d;
            add_header Cache-Control "public, max-age=2592000, immutable";
            access_log off;
        }

        # No-cache for HTML
        location ~* \.html$ {
            add_header Cache-Control "no-cache, no-store, must-revalidate";
            add_header Pragma "no-cache";
            expires 0;
        }
    }
}
```

---

## URL Rewrites

```nginx
server {
    # Permanent redirect
    rewrite ^/old-page$ /new-page permanent;

    # Regex rewrite
    rewrite ^/blog/(\d+)/(.*)$ /posts/$2?id=$1 permanent;

    # Remove trailing slash
    rewrite ^/(.*)/$ /$1 permanent;

    # Return (faster than rewrite for simple redirects)
    location /old {
        return 301 /new;
    }

    # Redirect non-www to www
    server_name example.com;
    return 301 https://www.example.com$request_uri;

    # Redirect www to non-www
    server_name www.example.com;
    return 301 https://example.com$request_uri;

    # try_files — attempt files in order
    location / {
        try_files $uri $uri/ /index.html;    # SPA fallback
        try_files $uri $uri/ =404;           # standard 404
    }
}
```

---

## Common Patterns

### Static File Server

```nginx
server {
    listen 80;
    server_name static.example.com;
    root /var/www/static;
    autoindex off;

    location / {
        try_files $uri $uri/ =404;
    }

    # Immutable versioned assets
    location ~* \.(js|css)$ {
        expires max;
        add_header Cache-Control "public, immutable";
    }

    # Images with long cache
    location ~* \.(jpg|jpeg|png|gif|webp|avif|ico|svg)$ {
        expires 30d;
    }

    # Block hidden files
    location ~ /\. {
        deny all;
    }
}
```

### Node.js Application

```nginx
upstream nodejs {
    server 127.0.0.1:3000;
    keepalive 32;                   # keep persistent connections
}

server {
    listen 443 ssl;
    server_name app.example.com;

    location / {
        proxy_pass http://nodejs;
        proxy_http_version 1.1;
        proxy_set_header Connection "";  # clear for keepalive
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Serve static files directly (bypass Node.js)
    location /public/ {
        root /var/www/app;
        expires 30d;
    }
}
```

### PHP-FPM (WordPress)

```nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$args;  # WordPress permalink support
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
    }

    # Block sensitive files
    location ~* /(?:uploads|files)/.*\.php$ { deny all; }
    location ~ /\.ht { deny all; }
    location ~ /wp-config.php { deny all; }
}
```

### WebSocket Proxy

```nginx
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    location /ws/ {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade    $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host       $host;
        proxy_read_timeout 86400s;  # long timeout for WS
    }
}
```

### Rate Limiting

```nginx
http {
    # Define rate limit zone (10MB can hold ~160,000 IP states)
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;

    server {
        # API rate limiting (burst of 20 requests)
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            limit_req_status 429;
            proxy_pass http://backend;
        }

        # Strict login rate limiting
        location /login {
            limit_req zone=login burst=2;
            limit_req_status 429;
            proxy_pass http://backend;
        }
    }
}
```

### Basic Auth

```nginx
location /admin {
    auth_basic "Restricted Area";
    auth_basic_user_file /etc/nginx/.htpasswd;
}

# Generate password file
# apt install apache2-utils
# htpasswd -c /etc/nginx/.htpasswd username
```

### IP Allowlist / Blocklist

```nginx
location /admin {
    allow 192.168.1.0/24;
    allow 10.0.0.5;
    deny all;
}

# Block specific IPs
location / {
    deny 192.168.1.100;
    deny 10.0.0.0/8;
    allow all;
}
```

---

## Useful Variables

| Variable | Value |
|---|---|
| `$host` | Request host header |
| `$request_uri` | Full URI with query string |
| `$uri` | Current URI (rewritten) |
| `$args` | Query string |
| `$remote_addr` | Client IP |
| `$server_name` | Matched server_name |
| `$scheme` | `http` or `https` |
| `$http_upgrade` | Upgrade header value |
| `$http_x_forwarded_for` | X-Forwarded-For header |
| `$upstream_cache_status` | Cache HIT/MISS/BYPASS |
| `$request_time` | Request processing time |
| `$upstream_response_time` | Upstream response time |

---

## Testing & Debugging

```bash
# Test configuration
nginx -t

# Test and dump full merged config
nginx -T

# Test specific config file
nginx -t -c /path/to/nginx.conf

# Check nginx version and compile options
nginx -V

# View error log in real-time
tail -f /var/log/nginx/error.log

# View access log
tail -f /var/log/nginx/access.log

# View last 100 lines
tail -n 100 /var/log/nginx/error.log

# Reload gracefully
systemctl reload nginx
nginx -s reload

# Full restart
systemctl restart nginx
```

---

## Tips & Tricks

- Always run `nginx -t` before reloading — a bad config breaks the site
- Use `return` instead of `rewrite` for simple redirects (faster)
- Enable `http2 on;` for HTTP/2 support (modern nginx syntax)
- Set `server_tokens off;` to hide nginx version in error pages
- Use `$binary_remote_addr` (not `$remote_addr`) for rate limit zones — smaller
- `try_files $uri $uri/ /index.html;` is the standard SPA config
- Separate `server` blocks per site in `/etc/nginx/sites-available/`
- Use Mozilla's SSL Config Generator for current TLS best practices
- `proxy_cache_use_stale` serves cached content on upstream errors (high availability)
- `keepalive 32` on upstream blocks keeps connections pooled to Node.js/PHP
- Add `access_log off;` for static assets to reduce log noise
- Use `map` directive to define complex variable logic cleanly

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
