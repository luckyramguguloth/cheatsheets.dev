# Docker Cheatsheet

> Container platform for building, shipping, and running applications.
> Last verified: May 2026 | Version: Docker 27.x

---

## Quick Reference

| Command | Description |
|---|---|
| `docker run -it ubuntu bash` | Run container interactively |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker images` | List images |
| `docker pull ubuntu` | Pull image from registry |
| `docker build -t name .` | Build image from Dockerfile |
| `docker stop <id>` | Stop running container |
| `docker rm <id>` | Remove container |
| `docker rmi <image>` | Remove image |
| `docker logs <id>` | Show container logs |
| `docker exec -it <id> bash` | Shell into running container |
| `docker inspect <id>` | Detailed container info |
| `docker stats` | Live resource usage |
| `docker volume ls` | List volumes |
| `docker network ls` | List networks |
| `docker system prune` | Remove unused resources |
| `docker-compose up -d` | Start compose services |
| `docker cp <id>:/path .` | Copy file from container |

---

## Images

### Pulling & Managing Images

```bash
# Pull an image
docker pull ubuntu
docker pull ubuntu:22.04          # specific tag
docker pull nginx:alpine
docker pull ghcr.io/user/image:tag   # from GitHub Container Registry

# List images
docker images
docker image ls
docker images --filter "dangling=true"    # untagged images
docker images ubuntu                       # filter by name

# Tag an image
docker tag myapp:latest myapp:v1.2.3
docker tag myapp registry.example.com/myapp:v1.0

# Remove image
docker rmi nginx
docker rmi nginx:1.25
docker rmi $(docker images -q)            # remove all images

# Image info
docker inspect ubuntu:22.04
docker history nginx                       # layer history
docker image inspect --format='{{.Config.Env}}' nginx

# Save/load images
docker save nginx > nginx.tar
docker save -o nginx.tar nginx:latest
docker load < nginx.tar
docker load -i nginx.tar
```

### Building Images

```bash
# Build from Dockerfile in current directory
docker build -t myapp .
docker build -t myapp:v1.0 .

# Build from specific Dockerfile
docker build -f Dockerfile.prod -t myapp:prod .

# Build with build args
docker build --build-arg NODE_ENV=production -t myapp .

# Build without cache
docker build --no-cache -t myapp .

# Build and push
docker buildx build --platform linux/amd64,linux/arm64 \
    -t myregistry/myapp:latest --push .

# Multi-stage build target
docker build --target builder -t myapp:builder .

# Show build context size
du -sh .
```

---

## Dockerfile Reference

```dockerfile
# Base image
FROM ubuntu:22.04
FROM node:20-alpine AS builder     # named stage

# Metadata
LABEL maintainer="you@example.com"
LABEL version="1.0"
LABEL description="My App"

# Set working directory
WORKDIR /app

# Copy files
COPY . .                           # copy everything
COPY package*.json ./              # copy specific files
COPY --from=builder /app/dist ./dist   # from another stage
ADD archive.tar.gz /app/           # ADD also extracts archives

# Run commands (creates new layer)
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV DB_HOST=localhost DB_PORT=5432

# Build arguments (available during build only)
ARG BUILD_VERSION=latest
ARG NODE_ENV

# Expose port (documentation only, doesn't publish)
EXPOSE 3000
EXPOSE 3000/tcp
EXPOSE 53/udp

# Volume mount point
VOLUME ["/data"]
VOLUME /var/log/myapp

# User
RUN useradd -m appuser
USER appuser
USER 1001:1001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1
HEALTHCHECK NONE     # disable inherited health check

# Entrypoint (not overridden by docker run args)
ENTRYPOINT ["node", "server.js"]
ENTRYPOINT ["/docker-entrypoint.sh"]

# Default command (can be overridden)
CMD ["npm", "start"]
CMD ["--port", "3000"]     # args to ENTRYPOINT

# Shell form (runs in /bin/sh -c)
CMD npm start
RUN echo "hello"

# Exec form (preferred — no shell interpolation)
CMD ["npm", "start"]
RUN ["apt-get", "install", "-y", "curl"]
```

---

## Containers

### Running Containers

```bash
# Basic run
docker run ubuntu
docker run ubuntu echo "hello"

# Interactive with TTY
docker run -it ubuntu bash

# Detached (background)
docker run -d nginx

# Named container
docker run --name myapp nginx

# Auto-remove when stopped
docker run --rm ubuntu echo "hello"

# Port mapping
docker run -p 8080:80 nginx          # host:container
docker run -p 127.0.0.1:8080:80 nginx  # bind to localhost
docker run -P nginx                  # publish all EXPOSE ports

# Environment variables
docker run -e NODE_ENV=production myapp
docker run -e DB_HOST -e DB_PORT myapp    # from host env
docker run --env-file .env myapp

# Volume mounts
docker run -v /host/path:/container/path nginx
docker run -v $(pwd):/app node              # mount current dir
docker run -v myvolume:/data postgres       # named volume
docker run --mount type=bind,source=$(pwd),target=/app node
docker run --mount type=volume,source=mydata,target=/data postgres

# Resource limits
docker run --memory=512m myapp
docker run --cpus=2.0 myapp
docker run --memory=512m --memory-swap=1g myapp

# Network
docker run --network mynetwork myapp
docker run --network host nginx          # host networking
docker run --network none myapp          # no networking

# Restart policy
docker run --restart unless-stopped nginx
docker run --restart always nginx
docker run --restart on-failure:5 myapp  # restart up to 5 times

# Privileged
docker run --privileged myapp
docker run --cap-add SYS_PTRACE myapp
docker run --cap-drop ALL --cap-add NET_ADMIN myapp

# Hostname and DNS
docker run --hostname myhost myapp
docker run --dns 8.8.8.8 myapp
docker run --add-host myhost:192.168.1.100 myapp
```

### Managing Containers

```bash
# List containers
docker ps
docker ps -a                 # all (including stopped)
docker ps -q                 # IDs only
docker ps --filter "status=running"
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"

# Start/stop/restart
docker start myapp
docker stop myapp
docker stop -t 30 myapp      # 30s timeout before SIGKILL
docker restart myapp
docker pause myapp
docker unpause myapp

# Remove containers
docker rm myapp
docker rm -f myapp           # force remove running container
docker rm $(docker ps -aq)   # remove all stopped containers
docker container prune       # remove all stopped containers

# Execute commands in running container
docker exec myapp ls /app
docker exec -it myapp bash
docker exec -it -u root myapp bash    # as root
docker exec -e VAR=value myapp env

# Copy files
docker cp myapp:/app/config.json ./config.json
docker cp ./config.json myapp:/app/config.json

# Logs
docker logs myapp
docker logs --tail 100 myapp
docker logs -f myapp              # follow (live)
docker logs --since 1h myapp      # last hour
docker logs --since "2024-01-01T12:00:00" myapp
docker logs 2>&1 | grep error

# Inspect & stats
docker inspect myapp
docker inspect --format='{{.NetworkSettings.IPAddress}}' myapp
docker inspect --format='{{json .Config.Env}}' myapp
docker stats                      # live stats for all containers
docker stats myapp --no-stream    # one-time snapshot
docker top myapp                  # processes inside container

# Port info
docker port myapp
docker port myapp 80
```

---

## Volumes

```bash
# Create volume
docker volume create mydata

# List volumes
docker volume ls

# Inspect volume
docker volume inspect mydata

# Remove volume
docker volume rm mydata
docker volume prune              # remove unused volumes

# Use volume
docker run -v mydata:/data postgres
docker run --mount type=volume,source=mydata,target=/data postgres

# Backup a volume
docker run --rm \
    -v mydata:/data \
    -v $(pwd):/backup \
    ubuntu tar czf /backup/backup.tar.gz /data

# Restore a volume
docker run --rm \
    -v mydata:/data \
    -v $(pwd):/backup \
    ubuntu bash -c "cd /data && tar xzf /backup/backup.tar.gz --strip 1"
```

---

## Networks

```bash
# Create network
docker network create mynet
docker network create --driver bridge mynet
docker network create --subnet 172.20.0.0/16 mynet

# List networks
docker network ls

# Inspect network
docker network inspect mynet

# Connect container to network
docker network connect mynet myapp
docker network disconnect mynet myapp

# Run container on network
docker run --network mynet myapp

# Network types
docker run --network bridge myapp     # default isolated bridge
docker run --network host myapp       # host network (no isolation)
docker run --network none myapp       # no network access

# Remove network
docker network rm mynet
docker network prune                  # remove unused networks
```

---

## Registry Operations

```bash
# Login to Docker Hub
docker login
docker login -u username

# Login to private registry
docker login registry.example.com
docker login ghcr.io

# Tag image for registry
docker tag myapp:latest registry.example.com/myapp:v1.0
docker tag myapp:latest username/myapp:latest

# Push image
docker push username/myapp:latest
docker push registry.example.com/myapp:v1.0

# Pull from private registry
docker pull registry.example.com/myapp:v1.0

# Search Docker Hub
docker search nginx
docker search --limit 5 postgres

# Logout
docker logout
```

---

## Cleanup

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune                 # dangling (untagged) only
docker image prune -a              # all unused images

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Remove ALL unused resources (containers + images + networks)
docker system prune
docker system prune -a             # include unused images too
docker system prune --volumes      # also remove volumes

# Check disk usage
docker system df
docker system df -v                # verbose breakdown
```

---

## Debugging

```bash
# Get shell in running container
docker exec -it myapp bash
docker exec -it myapp sh           # Alpine containers use sh

# Run ephemeral debug container
docker run --rm -it ubuntu bash
docker run --rm -it --network host nicolaka/netshoot   # network debug

# Inspect networking
docker exec myapp curl http://other-container:3000
docker exec myapp ping other-container
docker exec myapp nslookup postgres

# Check container filesystem
docker exec myapp ls -la /app
docker diff myapp                  # show filesystem changes

# Events
docker events                      # stream real-time events
docker events --since "1h"

# Container processes
docker top myapp
docker stats myapp

# Run container with everything from a running container (debugging)
docker commit myapp myapp-debug
docker run -it --entrypoint bash myapp-debug
```

---

## Tips & Tricks

- Use `.dockerignore` (like `.gitignore`) to exclude files from the build context.
- Chain `RUN` commands with `&&` to minimize layers and image size.
- Put infrequently changing instructions (like `apt-get install`) before frequently changing ones (like `COPY . .`) to maximize layer cache usage.
- Use `--rm` flag during development to auto-clean containers on exit.
- `docker exec -it $(docker ps -q --filter name=myapp) bash` — exec into a container by name without knowing the full ID.
- Use multi-stage builds to keep production images small — build in one stage, copy artifacts to a minimal base image.
- `docker run --read-only` mounts the filesystem as read-only for security.
- Use `COPY --chown=user:group` instead of separate `RUN chown` to save a layer.
- Always tag images with version numbers, not just `latest`, in production.
- `docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"` for a formatted snapshot.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
