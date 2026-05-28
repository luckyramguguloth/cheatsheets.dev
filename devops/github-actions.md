# GitHub Actions Cheatsheet

> CI/CD automation platform built directly into GitHub repositories.
> Last verified: May 2026 | Version: Actions v4

---

## Quick Reference

| Concept | Description |
|---|---|
| `on: push` | Trigger workflow on push |
| `on: pull_request` | Trigger on PR events |
| `jobs.<id>.runs-on` | Specifies runner OS |
| `steps[].uses` | Use a marketplace action |
| `steps[].run` | Run shell commands |
| `secrets.MY_SECRET` | Access repository secret |
| `env.MY_VAR` | Access environment variable |
| `needs: [job-id]` | Job dependency |
| `strategy.matrix` | Parallel matrix builds |
| `if: github.ref == 'refs/heads/main'` | Conditional step |

---

## Workflow File Structure

```yaml
# .github/workflows/ci.yml
name: CI Pipeline                     # Display name in GitHub UI

on:                                   # Triggers (when to run)
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:                                  # Global env vars for all jobs
  NODE_VERSION: '20'
  REGISTRY: ghcr.io

jobs:                                 # Jobs to run in parallel by default
  build:                              # Job ID (used for dependencies)
    name: Build and Test              # Display name
    runs-on: ubuntu-latest            # Runner OS

    steps:                            # Steps run sequentially
      - name: Checkout code
        uses: actions/checkout@v4     # Use a marketplace action

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}

      - name: Install dependencies
        run: npm ci                   # Shell command

      - name: Run tests
        run: npm test
```

---

## Triggers (on:)

### Push & PR Triggers

```yaml
on:
  # Trigger on push to specific branches
  push:
    branches:
      - main
      - 'release/**'       # Glob pattern
    branches-ignore:
      - 'feature/**'
    paths:
      - 'src/**'           # Only trigger if these paths change
      - '**.ts'
    paths-ignore:
      - 'docs/**'
      - '**.md'
    tags:
      - 'v*.*.*'           # Trigger on version tags

  # Trigger on pull request events
  pull_request:
    branches: [main]
    types: [opened, synchronize, reopened, labeled]

  # Trigger on PR targeting specific base
  pull_request_target:
    branches: [main]
```

### Schedule & Manual Triggers

```yaml
on:
  # Scheduled trigger (cron syntax)
  schedule:
    - cron: '0 2 * * 1'    # Every Monday at 2 AM UTC
    - cron: '*/30 * * * *' # Every 30 minutes

  # Manual trigger (Run workflow button in GitHub UI)
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        default: 'staging'
        type: choice
        options: [staging, production]
      debug:
        description: 'Enable debug mode'
        type: boolean
        default: false

  # Triggered by another workflow
  workflow_call:
    inputs:
      version:
        type: string
        required: true
    secrets:
      deploy_key:
        required: true

  # Trigger on GitHub release
  release:
    types: [published, created]
```

---

## Jobs & Steps

### Job Configuration

```yaml
jobs:
  test:
    name: Run Tests
    runs-on: ubuntu-latest       # or windows-latest, macos-latest

    # Job-level environment variables
    env:
      DATABASE_URL: postgres://localhost:5432/testdb

    # Timeout in minutes (default: 360)
    timeout-minutes: 30

    # Concurrency: cancel in-progress runs
    concurrency:
      group: ${{ github.workflow }}-${{ github.ref }}
      cancel-in-progress: true

    # Permissions for GITHUB_TOKEN
    permissions:
      contents: read
      packages: write
      id-token: write    # For OIDC auth

    steps:
      - uses: actions/checkout@v4

  deploy:
    name: Deploy
    runs-on: ubuntu-latest
    needs: [test]           # Wait for test job to pass
    if: github.ref == 'refs/heads/main'   # Conditional job

    environment:            # GitHub Environments (with protection rules)
      name: production
      url: https://myapp.com
```

### Step Options

```yaml
steps:
  - name: My Step
    id: my-step              # Reference this step's outputs later
    uses: some/action@v1
    with:                    # Action inputs
      key: value
    env:                     # Step-level env vars
      API_KEY: ${{ secrets.API_KEY }}
    if: success()            # Conditional: only if previous steps passed
    continue-on-error: true  # Don't fail the job if this step fails
    timeout-minutes: 5
    working-directory: ./app # Run in subdirectory

  # Use output from previous step
  - name: Use Step Output
    run: echo "${{ steps.my-step.outputs.result }}"
```

---

## Environment Variables & Secrets

### Accessing Variables

```yaml
env:
  MY_VAR: "hello"

steps:
  # Environment variables
  - run: echo "$MY_VAR"                      # Shell variable
  - run: echo "${{ env.MY_VAR }}"            # Expression syntax

  # GitHub context variables
  - run: |
      echo "Repository: ${{ github.repository }}"
      echo "Branch: ${{ github.ref_name }}"
      echo "Commit SHA: ${{ github.sha }}"
      echo "Actor: ${{ github.actor }}"
      echo "Event: ${{ github.event_name }}"
      echo "Run ID: ${{ github.run_id }}"
      echo "Workflow: ${{ github.workflow }}"

  # Repository secrets
  - run: echo "${{ secrets.MY_SECRET }}"
  - run: docker login -u user -p ${{ secrets.DOCKER_PASSWORD }}

  # Built-in secrets
  - run: curl -H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}" ...

  # Setting env vars dynamically (GITHUB_ENV)
  - name: Set dynamic env var
    run: echo "VERSION=1.2.3" >> $GITHUB_ENV

  - name: Use dynamic env var
    run: echo "$VERSION"   # Available in subsequent steps
```

### Output Variables

```yaml
steps:
  - name: Set output
    id: version-step
    run: echo "version=1.2.3" >> $GITHUB_OUTPUT

  - name: Use output
    run: echo "${{ steps.version-step.outputs.version }}"
```

---

## Matrix Builds

```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false        # Don't cancel others if one fails
      max-parallel: 4         # Limit concurrent jobs
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: [18, 20, 22]
        exclude:
          - os: windows-latest
            node-version: 18
        include:
          - os: ubuntu-latest
            node-version: 20
            experimental: true

    steps:
      - uses: actions/checkout@v4
      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm test
```

---

## Artifacts

```yaml
steps:
  # Upload build artifacts
  - name: Upload test results
    uses: actions/upload-artifact@v4
    if: always()              # Upload even if tests failed
    with:
      name: test-results
      path: |
        coverage/
        test-results.xml
      retention-days: 7

  # Upload a single file
  - name: Upload binary
    uses: actions/upload-artifact@v4
    with:
      name: my-app-${{ github.sha }}
      path: dist/my-app

# Download artifacts in another job
  - name: Download test results
    uses: actions/download-artifact@v4
    with:
      name: test-results
      path: ./test-results

  # Download all artifacts
  - uses: actions/download-artifact@v4
    with:
      path: all-artifacts   # All artifacts downloaded here in subdirs
```

---

## Caching

```yaml
steps:
  # Cache node_modules
  - name: Cache Node modules
    uses: actions/cache@v4
    with:
      path: ~/.npm
      key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
      restore-keys: |
        ${{ runner.os }}-node-

  # Cache Python packages
  - name: Cache pip
    uses: actions/cache@v4
    with:
      path: ~/.cache/pip
      key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements*.txt') }}
      restore-keys: |
        ${{ runner.os }}-pip-

  # Cache Gradle
  - uses: actions/cache@v4
    with:
      path: |
        ~/.gradle/caches
        ~/.gradle/wrapper
      key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*', '**/gradle-wrapper.properties') }}
```

---

## Common Workflow Patterns

### CI Pipeline (Node.js)

```yaml
name: CI
on: [push, pull_request]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'           # Built-in caching shortcut

      - run: npm ci
      - run: npm run lint
      - run: npm run build
      - run: npm test -- --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          token: ${{ secrets.CODECOV_TOKEN }}
```

### Docker Build & Push

```yaml
name: Docker
on:
  push:
    tags: ['v*']

jobs:
  docker:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ghcr.io/${{ github.repository }}
          tags: |
            type=semver,pattern={{version}}
            type=sha

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

### Deploy to AWS

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write   # Required for OIDC
      contents: read

    steps:
      - uses: actions/checkout@v4

      # OIDC-based auth (no long-lived keys!)
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
          aws-region: us-east-1

      - name: Deploy to ECS
        run: |
          aws ecs update-service \
            --cluster my-cluster \
            --service my-service \
            --force-new-deployment
```

### Reusable Workflow

```yaml
# .github/workflows/reusable-test.yml
name: Reusable Test Workflow
on:
  workflow_call:
    inputs:
      environment:
        type: string
        required: true
    secrets:
      API_KEY:
        required: true

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Testing in ${{ inputs.environment }}"
        env:
          API_KEY: ${{ secrets.API_KEY }}

---

# Calling the reusable workflow
jobs:
  run-tests:
    uses: ./.github/workflows/reusable-test.yml
    with:
      environment: staging
    secrets:
      API_KEY: ${{ secrets.API_KEY }}
```

---

## Expressions & Contexts

```yaml
# Conditionals
if: github.event_name == 'push'
if: github.ref == 'refs/heads/main'
if: contains(github.ref, 'tags')
if: failure()          # Only if previous step failed
if: success()          # Only if all previous steps passed
if: always()           # Always run (even on failure)
if: cancelled()        # Only if workflow was cancelled

# Functions
${{ contains('hello world', 'hello') }}
${{ startsWith(github.ref, 'refs/tags/') }}
${{ endsWith(github.actor, '[bot]') }}
${{ format('Hello, {0}!', github.actor) }}
${{ join(matrix.os, ', ') }}
${{ toJSON(github.event) }}
${{ fromJSON(steps.my-step.outputs.data) }}
${{ hashFiles('**/package-lock.json') }}

# Status functions
${{ success() }}
${{ failure() }}
${{ always() }}
${{ cancelled() }}

# Ternary-like
${{ github.ref == 'refs/heads/main' && 'production' || 'staging' }}
```

---

## Runner Types

```yaml
# GitHub-hosted runners
runs-on: ubuntu-latest       # Ubuntu 22.04
runs-on: ubuntu-22.04        # Pinned version
runs-on: windows-latest
runs-on: windows-2022
runs-on: macos-latest
runs-on: macos-14            # Apple Silicon

# Self-hosted runners
runs-on: self-hosted
runs-on: [self-hosted, linux, x64]
runs-on: [self-hosted, windows, gpu]

# Larger hosted runners (paid)
runs-on: ubuntu-latest-4-cores
runs-on: ubuntu-latest-8-cores
```

---

## Services (Sidecars)

```yaml
jobs:
  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: testpass
          POSTGRES_DB: testdb
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

      redis:
        image: redis:7
        ports:
          - 6379:6379

    steps:
      - uses: actions/checkout@v4
      - run: npm test
        env:
          DATABASE_URL: postgres://postgres:testpass@localhost:5432/testdb
          REDIS_URL: redis://localhost:6379
```

---

## Tips & Tricks

- Pin action versions to SHA (`uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683`) for security
- Use `github.event.pull_request.head.sha` for PR-triggered workflows to get the exact commit SHA
- `act` is a tool to run GitHub Actions locally for faster iteration
- Use `workflow_dispatch` with `inputs` to create parameterized manual deploy workflows
- Secrets are masked in logs automatically; never echo them directly as they may be partially exposed via substrings
- Use GitHub Environments with required reviewers for production deployments as an approval gate
- The `concurrency` key prevents parallel runs of the same workflow (useful for deploys)
- OIDC authentication (using `id-token: write`) eliminates the need for long-lived AWS/GCP/Azure credentials
- `actions/cache@v4` hit rate is visible in the step output — track it to improve build times
- Composite actions (`action.yml` in a repo) let you share step sequences across workflows

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
