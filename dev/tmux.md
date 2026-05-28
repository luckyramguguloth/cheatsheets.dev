# Tmux Cheatsheet

> Terminal multiplexer — multiple terminals in one window, persistent sessions.
> Last verified: May 2026 | Version: tmux 3.4

---

## Quick Reference

| Key / Command | Description |
|---|---|
| `tmux` | Start new session |
| `tmux new -s name` | New named session |
| `tmux ls` | List sessions |
| `tmux attach -t name` | Attach to session |
| `Prefix c` | New window |
| `Prefix %` | Split vertically |
| `Prefix "` | Split horizontally |
| `Prefix arrow` | Navigate panes |
| `Prefix d` | Detach from session |
| `Prefix [` | Enter copy mode |
| `Prefix z` | Zoom/unzoom pane |
| `Prefix x` | Kill pane |
| `Prefix &` | Kill window |
| `Prefix $` | Rename session |
| `Prefix ,` | Rename window |
| `Prefix s` | Choose session interactively |
| `Prefix w` | Choose window interactively |
| `Prefix ?` | List all key bindings |

> **Default prefix key: `Ctrl+b`** (commonly remapped to `Ctrl+a`)

---

## Sessions

### Command Line

```bash
# Start tmux
tmux

# New named session
tmux new-session -s mysession
tmux new -s mysession           # shorthand

# New session with window name
tmux new -s mysession -n mywindow

# List sessions
tmux list-sessions
tmux ls

# Attach to a session
tmux attach-session -t mysession
tmux attach -t mysession        # shorthand
tmux a -t mysession             # shortest
tmux a                          # attach to most recent

# Detach from session
tmux detach

# Kill a session
tmux kill-session -t mysession
tmux kill-server                # kill ALL sessions and tmux server

# Switch to session by name
tmux switch-client -t mysession

# Rename session
tmux rename-session -t old new
```

### Key Bindings (prefix = Ctrl+b)

```
Prefix d            Detach from current session
Prefix $            Rename current session
Prefix s            Interactive session chooser
Prefix (            Switch to previous session
Prefix )            Switch to next session
Prefix L            Switch to last (previously used) session
```

---

## Windows

### Command Line

```bash
# Create new window
tmux new-window -t mysession

# Create named window
tmux new-window -t mysession -n mywindow

# List windows
tmux list-windows

# Select window by index
tmux select-window -t mysession:1

# Rename window
tmux rename-window -t mysession:1 newname

# Kill window
tmux kill-window -t mysession:1
```

### Key Bindings

```
Prefix c            Create new window
Prefix ,            Rename current window
Prefix &            Kill current window (with confirm)
Prefix p            Previous window
Prefix n            Next window
Prefix 0-9          Switch to window by number
Prefix '            Prompt for window number to switch
Prefix l            Last (previously used) window
Prefix w            Interactive window chooser
Prefix f            Find window by name
Prefix .            Move window (prompt for index)
```

---

## Panes

### Key Bindings

```
Prefix %            Split horizontally (left/right panes)
Prefix "            Split vertically (top/bottom panes)
Prefix arrow        Navigate panes (left/down/up/right)
Prefix o            Cycle through panes
Prefix ;            Toggle between last two panes
Prefix x            Kill current pane (with confirm)
Prefix z            Zoom/unzoom current pane (fullscreen)
Prefix !            Break pane into its own window
Prefix {            Swap pane with the previous one
Prefix }            Swap pane with the next one
Prefix Ctrl+arrow   Resize pane (hold to repeat)
Prefix Alt+arrow    Resize pane in larger steps
Prefix q            Show pane numbers briefly
Prefix q 0-9        Switch to pane by number
Prefix Space        Cycle through layout presets
```

### Layouts

```
Prefix Alt+1        Even horizontal
Prefix Alt+2        Even vertical
Prefix Alt+3        Main horizontal
Prefix Alt+4        Main vertical
Prefix Alt+5        Tiled
Prefix Space        Cycle through layouts
```

### Command Line

```bash
# Split current window
tmux split-window -h         # horizontal split
tmux split-window -v         # vertical split
tmux split-window -h -p 30  # split, take 30% width

# Select pane
tmux select-pane -t :.+     # next pane
tmux select-pane -t :.-     # previous pane
tmux select-pane -U/-D/-L/-R  # by direction

# Resize pane
tmux resize-pane -D 5        # down 5 lines
tmux resize-pane -U 5        # up 5 lines
tmux resize-pane -L 5        # left 5 columns
tmux resize-pane -R 5        # right 5 columns
tmux resize-pane -Z          # toggle zoom
```

---

## Copy Mode

```
Prefix [            Enter copy mode (vi-style navigation)
Prefix ]            Paste from buffer
Prefix #            List all paste buffers
Prefix -            Delete most recent paste buffer

" Inside copy mode (vi keys):
q / Esc             Exit copy mode
h j k l             Move cursor
w / b               Word forward/backward
0 / $               Start/end of line
g / G               First/last line
Ctrl+f / Ctrl+b     Page down/up
/                   Search forward
?                   Search backward
n / N               Next/previous match
Space               Start selection
Enter               Copy selection and exit
v                   Start selection (if vi mode configured)
y                   Copy selection (if vi mode configured)
```

**Enable vi-style copy mode in `.tmux.conf`:**

```bash
setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel

# Copy to system clipboard (requires xclip or xsel on Linux)
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
# macOS:
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
```

---

## Configuration (.tmux.conf)

```bash
# ~/.tmux.conf

# Change prefix from Ctrl+b to Ctrl+a (screen-like)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Enable mouse support
set -g mouse on

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on       # renumber when window closed

# Increase history
set -g history-limit 50000

# Faster key repetition
set -s escape-time 0

# Enable 256 colors and true color
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Status bar
set -g status-position bottom
set -g status-bg colour234
set -g status-fg colour137
set -g status-left '#[fg=colour233,bg=colour241,bold] #S '
set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
set -g status-right-length 50
set -g status-left-length 20

# Window status
setw -g window-status-current-format '#[fg=colour81,bg=colour238,bold] #I:#W '
setw -g window-status-format '#[fg=colour138,bg=colour235] #I:#W '

# Pane borders
set -g pane-border-style fg=colour238
set -g pane-active-border-style fg=colour51

# Split panes with | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# New window in current path
bind c new-window -c "#{pane_current_path}"

# Vim-style pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize panes
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Vi copy mode
setw -g mode-keys vi

# Double tap prefix to go to last window
bind C-a last-window

# Toggle synchronize panes (type in all panes at once)
bind S setw synchronize-panes
```

---

## Scripting Tmux

### Create a Dev Environment

```bash
#!/usr/bin/env bash
# start-dev.sh — launch a full dev environment

SESSION="dev"

# Kill existing session
tmux kill-session -t $SESSION 2>/dev/null

# Create new session with first window
tmux new-session -d -s $SESSION -n "editor" -x 220 -y 50

# Second window: terminal
tmux new-window -t $SESSION -n "terminal"

# Third window: server
tmux new-window -t $SESSION -n "server"

# Setup editor window with splits
tmux select-window -t $SESSION:editor
tmux split-window -h -t $SESSION:editor    # right pane: 50%
tmux select-pane -t $SESSION:editor.left

# Setup server window
tmux select-window -t $SESSION:server
tmux send-keys -t $SESSION:server "npm run dev" Enter

# Attach to session
tmux select-window -t $SESSION:editor
tmux attach-session -t $SESSION
```

### Send Commands to Panes

```bash
# Send command to a specific pane (no Enter)
tmux send-keys -t session:window.pane "command" 

# Send command with Enter
tmux send-keys -t mydev:1.2 "ls -la" Enter

# Send to all panes in window (sync trick)
tmux set-window-option synchronize-panes on

# Run command in a new detached pane
tmux split-window -d -t mydev:1.1 "top"

# Run command in background pane, capture output
tmux new-window -d -n "bg-task" "python script.py > output.log 2>&1"
```

---

## Common Workflows

### Persistent SSH Session

```bash
# SSH into server and start a tmux session
ssh user@server
tmux new -s work

# Disconnect (tmux persists on server)
Prefix d

# Reconnect later
ssh user@server
tmux attach -t work
```

### Pair Programming

```bash
# Host: share session
tmux new -s shared

# Guest: attach to shared session (read-only)
tmux attach -t shared -r

# Guest: attach with full control (same session)
tmux attach -t shared
```

### Synchronize Panes (Type in All at Once)

```bash
# Enable
tmux setw synchronize-panes on

# Disable
tmux setw synchronize-panes off

# Toggle with binding (if configured)
Prefix S
```

---

## Plugin Manager (TPM)

```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Add to .tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'     # save/restore sessions
set -g @plugin 'tmux-plugins/tmux-continuum'     # auto-save sessions
set -g @plugin 'tmux-plugins/tmux-yank'          # system clipboard yank
set -g @plugin 'christoomey/vim-tmux-navigator'  # unified vim+tmux nav

run '~/.tmux/plugins/tpm/tpm'

# Install plugins: Prefix + I
# Update plugins:  Prefix + U
# Remove plugins:  Prefix + Alt+u
```

---

## Tips & Tricks

- Use `tmux new -s project -d` to create a detached session from a script.
- `Prefix z` to zoom a pane to fullscreen — press again to unzoom.
- `Prefix q` shows pane numbers for a few seconds — press the number to jump.
- `Prefix {` and `}` swap panes without re-creating splits.
- Use `tmux-resurrect` plugin to save and restore sessions across reboots.
- `set -g mouse on` enables scroll, click-to-focus, and resize-by-drag.
- `Prefix :setw synchronize-panes` lets you type the same command in all panes.
- Run `tmux show-options -g` to see all global options and their current values.
- Add `alias ta="tmux attach -t"` and `alias tl="tmux ls"` to your `.bashrc`.
- `tmux pipe-pane -o "cat >> ~/session.log"` logs all pane output to a file.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
