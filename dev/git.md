# Git Cheatsheet

> Distributed version control system for tracking code changes.
> Last verified: May 2026 | Version: 2.45

---

## Quick Reference

| Command | Description |
|---|---|
| `git init` | Initialize a new repository |
| `git clone <url>` | Clone a remote repository |
| `git status` | Show working tree status |
| `git add <file>` | Stage a file |
| `git add .` | Stage all changes |
| `git commit -m "msg"` | Commit with message |
| `git push origin main` | Push to remote |
| `git pull` | Fetch and merge remote changes |
| `git branch` | List local branches |
| `git checkout -b <name>` | Create and switch to branch |
| `git merge <branch>` | Merge branch into current |
| `git rebase <branch>` | Rebase onto branch |
| `git stash` | Stash uncommitted changes |
| `git log --oneline` | Compact commit history |
| `git diff` | Show unstaged changes |
| `git reset HEAD~1` | Undo last commit (keep changes) |
| `git revert <sha>` | Create undo commit |
| `git tag v1.0` | Create a tag |
| `git remote -v` | List remotes |
| `git fetch --all` | Fetch all remotes |
| `git cherry-pick <sha>` | Apply a specific commit |
| `git bisect start` | Start binary search for bug |

---

## Setup & Configuration

### Global Config

```bash
# Set identity (required before first commit)
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Set default editor
git config --global core.editor "vim"
git config --global core.editor "code --wait"   # VS Code

# Set default branch name
git config --global init.defaultBranch main

# Enable color output
git config --global color.ui auto

# Set line ending handling
git config --global core.autocrlf input    # macOS/Linux
git config --global core.autocrlf true     # Windows

# View all config
git config --list
git config --global --list

# Edit config file directly
git config --global --edit
```

### SSH Key Setup

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "you@example.com"

# Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Test GitHub connection
ssh -T git@github.com
```

### Aliases

```bash
# Common useful aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.lg "log --oneline --graph --decorate --all"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.undo "reset HEAD~1 --mixed"
git config --global alias.aliases "config --get-regexp alias"

# Usage
git st
git lg
```

---

## Initializing & Cloning

```bash
# Initialize new repository
git init
git init my-project          # create new dir

# Clone repository
git clone https://github.com/user/repo.git
git clone git@github.com:user/repo.git     # via SSH
git clone <url> my-folder                  # clone into specific folder
git clone --depth 1 <url>                  # shallow clone (latest only)
git clone --branch develop <url>           # clone specific branch
git clone --recurse-submodules <url>       # include submodules
```

---

## Staging & Committing

### Staging Files

```bash
# Stage specific file
git add file.txt

# Stage all changes in current directory
git add .

# Stage all tracked files (even in subdirs above cwd)
git add -A

# Stage parts of a file interactively (hunk-by-hunk)
git add -p file.txt

# Unstage a file (keep changes)
git reset HEAD file.txt
git restore --staged file.txt    # Git 2.23+

# Discard changes in working directory
git restore file.txt             # Git 2.23+
git checkout -- file.txt         # older syntax
```

### Committing

```bash
# Commit with inline message
git commit -m "feat: add login page"

# Stage tracked files and commit in one step
git commit -am "fix: correct typo"

# Open editor for commit message
git commit

# Amend last commit (message or staged files)
git commit --amend -m "new message"
git commit --amend --no-edit     # keep same message, add staged changes

# Empty commit (useful for triggering CI)
git commit --allow-empty -m "trigger deploy"

# Commit with co-author
git commit -m "feat: thing
Co-authored-by: Name <email@example.com>"
```

### Conventional Commits

```bash
# Common prefixes (Conventional Commits spec)
git commit -m "feat: add new feature"
git commit -m "fix: resolve null pointer error"
git commit -m "docs: update README"
git commit -m "style: format code"
git commit -m "refactor: extract helper function"
git commit -m "test: add unit tests for auth"
git commit -m "chore: update dependencies"
git commit -m "perf: optimize database query"
git commit -m "ci: add GitHub Actions workflow"
```

---

## Branching

```bash
# List branches
git branch              # local
git branch -r           # remote
git branch -a           # all

# Create branch
git branch feature/login

# Switch branch
git checkout feature/login
git switch feature/login        # Git 2.23+

# Create and switch in one step
git checkout -b feature/login
git switch -c feature/login     # Git 2.23+

# Rename branch
git branch -m old-name new-name
git branch -m new-name          # rename current branch

# Delete branch
git branch -d feature/done      # safe delete (merged only)
git branch -D feature/abandon   # force delete

# Delete remote branch
git push origin --delete feature/done

# Track a remote branch
git checkout --track origin/feature
git branch --set-upstream-to=origin/main main
```

---

## Merging

```bash
# Merge branch into current branch
git merge feature/login

# Merge with commit message (no fast-forward)
git merge --no-ff feature/login -m "Merge feature/login"

# Fast-forward only (fails if not possible)
git merge --ff-only feature/login

# Squash all branch commits into one staged change
git merge --squash feature/login
git commit -m "feat: add login feature"

# Abort a merge in progress
git merge --abort

# Check if branch is merged
git branch --merged
git branch --no-merged
```

---

## Rebasing

```bash
# Rebase current branch onto main
git rebase main

# Interactive rebase (last 3 commits)
git rebase -i HEAD~3
# Commands in interactive mode:
# pick   = use commit as-is
# reword = use commit but edit message
# edit   = use commit but stop to amend
# squash = meld into previous commit
# fixup  = like squash but discard message
# drop   = remove commit

# Continue after resolving conflicts
git rebase --continue

# Abort rebase
git rebase --abort

# Rebase onto a specific commit
git rebase --onto main feature~3 feature

# Pull with rebase instead of merge
git pull --rebase
git config --global pull.rebase true   # make it default
```

---

## Remote Operations

```bash
# List remotes
git remote -v

# Add remote
git remote add origin https://github.com/user/repo.git
git remote add upstream https://github.com/original/repo.git

# Remove remote
git remote remove origin

# Rename remote
git remote rename origin old-origin

# Fetch (download without merging)
git fetch origin
git fetch --all
git fetch --prune        # remove deleted remote branches

# Pull (fetch + merge)
git pull
git pull origin main
git pull --rebase        # fetch + rebase

# Push
git push origin main
git push -u origin main  # set upstream and push
git push --force-with-lease   # safe force push
git push --force              # force push (dangerous!)
git push --tags               # push all tags
git push origin --delete branch-name  # delete remote branch
```

---

## Stashing

```bash
# Save current changes to stash
git stash
git stash push -m "work in progress: login"

# Include untracked files
git stash -u
git stash --include-untracked

# List stashes
git stash list

# Apply most recent stash (keep in stash list)
git stash apply

# Apply and remove from stash list
git stash pop

# Apply specific stash
git stash apply stash@{2}

# Delete a stash
git stash drop stash@{0}

# Delete all stashes
git stash clear

# Show stash contents
git stash show
git stash show -p stash@{1}    # show as diff

# Create branch from stash
git stash branch feature/from-stash stash@{0}
```

---

## Tagging

```bash
# List tags
git tag
git tag -l "v1.*"       # filter by pattern

# Create lightweight tag
git tag v1.0.0

# Create annotated tag (recommended)
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag a specific commit
git tag -a v1.0.0 abc1234 -m "Tag old commit"

# Push a tag
git push origin v1.0.0

# Push all tags
git push origin --tags

# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0

# Checkout a tag (detached HEAD)
git checkout v1.0.0
```

---

## Undoing Changes

```bash
# Unstage changes (keep in working dir)
git reset HEAD <file>
git restore --staged <file>

# Discard working directory changes
git restore <file>
git checkout -- <file>

# Undo last commit (keep changes staged)
git reset --soft HEAD~1

# Undo last commit (keep changes unstaged)
git reset --mixed HEAD~1   # default
git reset HEAD~1

# Undo last commit (discard all changes)
git reset --hard HEAD~1

# Revert a commit (creates new undo commit)
git revert HEAD
git revert abc1234

# Revert multiple commits
git revert HEAD~3..HEAD

# Recover deleted branch (find hash in reflog)
git reflog
git checkout -b recovered-branch abc1234

# Reset to remote state (discard all local changes)
git fetch origin
git reset --hard origin/main
```

---

## Git Log & History

```bash
# Basic log
git log
git log --oneline
git log --oneline --graph --decorate --all

# Limit output
git log -5                  # last 5 commits
git log --since="2 weeks ago"
git log --until="2024-01-01"
git log --author="Alice"

# Search commit messages
git log --grep="fix:"

# Search changes in code
git log -S "function login"     # pickaxe search
git log -G "regex pattern"

# Show commits in branch but not main
git log main..feature

# Show commits that touched a file
git log -- path/to/file.txt
git log -p -- path/to/file.txt   # with diffs

# Pretty formats
git log --pretty=format:"%h %an %ar %s"
git log --pretty=format:"%C(yellow)%h%Creset %s %C(blue)(%an)%Creset"

# Show file change stats
git log --stat
git log --shortstat

# Show who changed each line
git blame file.txt
git blame -L 10,20 file.txt    # lines 10-20
```

---

## Git Diff

```bash
# Show unstaged changes
git diff

# Show staged changes (ready to commit)
git diff --staged
git diff --cached           # same as --staged

# Compare branches
git diff main feature/login

# Compare commits
git diff abc1234 def5678

# Compare specific file
git diff main -- file.txt

# Summary of what changed (no line details)
git diff --stat

# Show only file names that changed
git diff --name-only
git diff --name-status      # with status letter (A/M/D)

# Word-level diff (more readable)
git diff --word-diff
```

---

## Searching

```bash
# Search file content (like grep but for git repo)
git grep "TODO"
git grep -n "function login"      # with line numbers
git grep -i "error"               # case insensitive

# Search across commits
git log -S "search_term" --source --all

# Find which commit introduced a bug (binary search)
git bisect start
git bisect bad                    # current commit is bad
git bisect good v1.0              # v1.0 was good
# Git checks out midpoint; test and mark:
git bisect good
git bisect bad
# Repeat until git identifies the culprit
git bisect reset                  # end bisect session
```

---

## Submodules

```bash
# Add submodule
git submodule add https://github.com/user/lib.git libs/lib

# Initialize submodules after clone
git submodule init
git submodule update

# Clone with submodules
git clone --recurse-submodules <url>

# Update all submodules to latest
git submodule update --remote

# Remove submodule
git submodule deinit libs/lib
git rm libs/lib
rm -rf .git/modules/libs/lib
```

---

## .gitignore Patterns

```bash
# Ignore specific file
secrets.env

# Ignore by extension
*.log
*.tmp
*.pyc

# Ignore directory
node_modules/
dist/
.venv/
__pycache__/

# Ignore everywhere (double star)
**/.DS_Store
**/Thumbs.db

# Negate (do NOT ignore)
!important.log

# Ignore in specific directory only
/build/

# Ignore files with pattern
doc/*.txt        # doc/notes.txt but not doc/sub/notes.txt
doc/**/*.txt     # any .txt in doc/ recursively

# Apply gitignore to already-tracked files
git rm --cached file.txt
git rm -r --cached node_modules/
```

---

## Advanced Workflows

### Cherry-Pick

```bash
# Apply a specific commit to current branch
git cherry-pick abc1234

# Cherry-pick a range of commits
git cherry-pick abc1234..def5678

# Cherry-pick without committing
git cherry-pick -n abc1234

# Abort cherry-pick on conflict
git cherry-pick --abort
```

### Worktrees

```bash
# Create a new worktree (multiple branches checked out at once)
git worktree add ../hotfix hotfix/issue-123
git worktree list
git worktree remove ../hotfix
```

### Clean

```bash
# Show what would be deleted
git clean -n

# Remove untracked files
git clean -f

# Remove untracked files and directories
git clean -fd

# Remove ignored files too
git clean -fdx
```

---

## Tips & Tricks

- Use `git commit --fixup=HEAD` then `git rebase -i --autosquash` to cleanly fix up commits.
- `git log --all --full-history -- "**/file.txt"` finds a deleted file's history.
- `git reflog` is your safety net — it records every HEAD movement for 90 days.
- Use `git push --force-with-lease` instead of `--force`; it fails if someone else pushed.
- `git diff --check` catches whitespace errors before committing.
- Set `git config --global rerere.enabled true` to reuse recorded conflict resolutions.
- `git shortlog -sn` shows commit counts per author — great for contributor stats.
- Use `.git/hooks/` for pre-commit linting; or use the `pre-commit` tool.
- `GIT_TRACE=1 git push` enables verbose tracing for debugging git operations.
- Tag your releases with annotated tags (`-a`) — they store tagger, date, and message.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
