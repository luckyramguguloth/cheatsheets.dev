# Docker Compose Cheatsheet

> Define and run multi-container Docker applications declaratively.
> Last verified: May 2026 | Version: Docker Compose v2.27

---

## Quick Reference

| Command | Description |
|---|---|
| `docker compose up` | Create and start services |
| `docker compose up -d` | Start in detached mode |
| `docker compose down` | Stop and remove containers |
| `docker compose down -v` | Also remove volumes |
| `docker compose ps` | List running services |
| `docker compose logs` | View service logs |
| `docker compose logs -f web` | Follow a service's logs |
| `docker compose exec web bash` | Shell into service |
| `docker compose build` | Build images |
| `docker compose pull` | Pull latest images |
| `docker compose restart web` | Restart a service |
| `docker compose stop web` | Stop a service |
| `docker compose run web npm test` | Run one-off command |
| `docker compose config` | Validate and view config |
| `docker compose scale web=3` | Scale service replicas |

---

## compose.yaml Structure

```yaml
# compose.yaml (preferred) or docker-compose.yml
# Version key is obsolete in Compose v2 — omit it

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"

  app:
    build: .
    depends_on:
      - db
    environment:
      - DATABASE_URL=postgres://user:pass@db/mydb
    volumes:
      - .:/app

  db:
    image: postgres:16
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass

volumes:
  pgdata:

networks:
  default:
    driver: bridge
```

---

## Services

### Image & Build

```yaml
services:
  web:
    # Use pre-built image
    image: nginx:1.25
    image: ubuntu:22.04
    image: myregistry.com/myapp:v1.0

  app:
    # Build from Dockerfile in current directory
    build: .

    # Build with options
    build:
      context: ./app
      dockerfile: Dockerfile.prod
      args:
        NODE_ENV: production
        BUILD_VERSION: "1.2.3"
      target: production          # multi-stage target
      cache_from:
        - myapp:cache
      labels:
        - "com.example.version=1.0"

    # Platform
    platform: linux/amd64
```

### Ports & Networking

```yaml
services:
  web:
    ports:
      - "8080:80"                  # host:container
      - "443:443"
      - "127.0.0.1:8080:80"       # bind to specific IP
      - "8080-8090:8080-8090"     # range

    expose:
      - "3000"                     # expose to other services only

    networks:
      - frontend
      - backend

    network_mode: host             # use host networking
    network_mode: "service:web"   # share network with another service

    hostname: myapp
    domainname: example.com
    dns:
      - 8.8.8.8
      - 8.8.4.4
    extra_hosts:
      - "myhost:192.168.1.100"
```

### Volumes & Bind Mounts

```yaml
services:
  app:
    volumes:
      # Bind mount (host:container)
      - .:/app
      - /host/path:/container/path
      - /host/path:/container/path:ro    # read-only

      # Named volume
      - mydata:/var/lib/data

      # Anonymous volume
      - /var/log/app

      # Long syntax (more options)
      - type: bind
        source: ./config
        target: /etc/config
        read_only: true

      - type: volume
        source: mydata
        target: /data
        volume:
          nocopy: true

volumes:
  mydata:                            # basic named volume
  mydata:
    driver: local
    driver_opts:
      type: nfs
      o: addr=192.168.1.100,rw
      device: ":/path/to/dir"
  external_vol:
    external: true                   # use pre-existing volume
    name: actual_volume_name
```

### Environment Variables

```yaml
services:
  app:
    # List form
    environment:
      - NODE_ENV=production
      - PORT=3000
      - DEBUG=false

    # Map form (clearer)
    environment:
      NODE_ENV: production
      PORT: "3000"
      DATABASE_URL: postgres://user:pass@db/mydb

    # Pass host env variable (no value = use host's)
    environment:
      - API_KEY         # value from host environment

    # From file
    env_file:
      - .env
      - .env.local
      - path: ./secrets.env
        required: false             # optional file
```

### Dependencies & Startup Order

```yaml
services:
  app:
    depends_on:
      - db
      - redis

    # With condition (recommended)
    depends_on:
      db:
        condition: service_healthy
        restart: true
      redis:
        condition: service_started  # default

  db:
    image: postgres
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s
```

### Resource Limits

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.1'
          memory: 128M
    # For standalone (non-swarm) use:
    mem_limit: 512m
    cpus: 0.5
```

### Health Checks

```yaml
services:
  web:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      test: ["CMD-SHELL", "curl -f http://localhost || exit 1"]
      interval: 30s          # how often to check
      timeout: 10s           # how long to wait
      retries: 3             # failures before unhealthy
      start_period: 40s      # grace period on startup
      disable: false

  db:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5
```

### Restart Policies

```yaml
services:
  app:
    restart: no              # never restart (default)
    restart: always          # always restart
    restart: on-failure      # only on non-zero exit
    restart: unless-stopped  # restart unless manually stopped
```

### Other Service Options

```yaml
services:
  app:
    container_name: my_app          # fixed container name (not scalable)
    working_dir: /app
    user: "1000:1000"
    command: ["npm", "start"]
    command: npm start
    entrypoint: ["/docker-entrypoint.sh"]
    entrypoint: /start.sh

    # Labels
    labels:
      - "traefik.enable=true"
      - "com.example.version=1.0"

    # Logging
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"

    # Profiles (only started when --profile is specified)
    profiles:
      - debug
      - testing

    # Secrets (from Docker secrets store)
    secrets:
      - db_password
    
    # Extra capabilities
    cap_add:
      - SYS_PTRACE
    cap_drop:
      - ALL
    
    privileged: false
    read_only: true
    
    # Shared memory
    shm_size: '256mb'
    
    # Stdin / TTY
    stdin_open: true     # -i
    tty: true            # -t
```

---

## Networks

```yaml
networks:
  frontend:
    driver: bridge

  backend:
    driver: bridge
    internal: true         # no external internet access
    attachable: true       # other containers can attach

  mynet:
    driver: bridge
    driver_opts:
      com.docker.network.bridge.name: my_bridge
    ipam:
      driver: default
      config:
        - subnet: 172.20.0.0/16
          gateway: 172.20.0.1

  external_net:
    external: true          # use pre-existing network
    name: actual_net_name
```

---

## Compose Commands

### Lifecycle

```bash
# Start services (create and start)
docker compose up
docker compose up -d                   # detached (background)
docker compose up web db               # start specific services
docker compose up --build              # rebuild images first
docker compose up --force-recreate     # recreate containers
docker compose up --no-deps web        # ignore dependencies
docker compose up --scale web=3        # start 3 web instances

# Stop and remove
docker compose down                    # stop + remove containers + networks
docker compose down -v                 # also remove volumes
docker compose down --rmi all          # also remove images

# Stop (keep containers)
docker compose stop
docker compose stop web

# Start stopped services
docker compose start
docker compose start web

# Restart
docker compose restart
docker compose restart web

# Pause/unpause
docker compose pause
docker compose unpause
```

### Build & Pull

```bash
# Build images
docker compose build
docker compose build web              # specific service
docker compose build --no-cache       # no cache
docker compose build --parallel       # build in parallel

# Pull images
docker compose pull
docker compose pull db                # specific service
docker compose pull --ignore-pull-failures

# Push images
docker compose push
docker compose push web
```

### Inspection & Debugging

```bash
# List running services
docker compose ps
docker compose ps --all               # include stopped

# Logs
docker compose logs
docker compose logs web               # specific service
docker compose logs -f                # follow
docker compose logs -f web            # follow specific service
docker compose logs --tail=100        # last 100 lines
docker compose logs -f --no-log-prefix web   # no service prefix

# Execute command in running service
docker compose exec web bash
docker compose exec web sh
docker compose exec -it web bash
docker compose exec -u root web bash
docker compose exec db psql -U postgres

# Run one-off command (creates new container)
docker compose run web npm install
docker compose run --rm web npm test
docker compose run -e DEBUG=true web bash

# View top processes
docker compose top
docker compose top web

# Config validation
docker compose config             # validate and print merged config
docker compose config --services  # list services only
docker compose config --volumes   # list volumes only

# Events
docker compose events
docker compose events web
```

---

## Multiple Compose Files & Overrides

```bash
# Default: reads compose.yaml + compose.override.yaml automatically
docker compose up

# Specify files explicitly
docker compose -f compose.yaml -f compose.prod.yaml up

# Common pattern: base + environment-specific
docker compose -f compose.yaml -f compose.dev.yaml up
docker compose -f compose.yaml -f compose.prod.yaml up -d
```

**compose.yaml** (base):
```yaml
services:
  app:
    build: .
    environment:
      - NODE_ENV=development
```

**compose.prod.yaml** (override):
```yaml
services:
  app:
    image: myregistry/myapp:latest    # use prebuilt image
    environment:
      - NODE_ENV=production
    restart: always
    deploy:
      replicas: 3
```

---

## .env File Integration

```bash
# .env file in same directory as compose.yaml is auto-loaded
# Override with: docker compose --env-file .env.prod up

# .env file
POSTGRES_VERSION=16
APP_PORT=8080
NODE_ENV=production
```

```yaml
# compose.yaml
services:
  db:
    image: postgres:${POSTGRES_VERSION:-15}    # with default
  web:
    ports:
      - "${APP_PORT}:3000"
```

---

## Common Patterns

### Full-Stack App (Node + Postgres + Redis)

```yaml
services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://user:pass@db:5432/mydb
      REDIS_URL: redis://redis:6379
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    volumes:
      - .:/app
      - /app/node_modules

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d mydb"]
      interval: 10s
      retries: 5

  redis:
    image: redis:7-alpine
    volumes:
      - redisdata:/data

volumes:
  pgdata:
  redisdata:
```

---

## Tips & Tricks

- Use `docker compose up --build` during development to rebuild on each start.
- Override specific services with `docker compose up web` (starts only web + its deps).
- `docker compose run --rm web npm install` is great for running install commands.
- Use `depends_on: condition: service_healthy` with a `healthcheck` to ensure proper startup order.
- The `extend` key lets services inherit configuration from other services or files.
- Use profiles to group optional services: `docker compose --profile debug up`.
- `docker compose exec web env` quickly shows a service's environment variables.
- `docker compose pause` is useful for debugging — freezes processes without stopping them.
- Named volumes persist across `docker compose down`; use `-v` to also remove them.
- Keep secrets out of compose files — use `env_file` pointing to a `.env` not in version control.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
