# Environment Variables Cheatsheet

> Reference guide for system-wide and user-specific environment variables in Linux, macOS, and Windows.
> Last verified: May 2026 | Version: Core Shell

---

## Quick Reference

| Action | Linux / macOS (Bash/Zsh) | Windows (PowerShell) |
|---|---|---|
| List all variables | `printenv` or `env` | `Get-ChildItem Env:` |
| Print specific variable | `echo $PATH` | `echo $env:PATH` |
| Set temporary variable | `export APP_ENV=production` | `$env:APP_ENV="production"` |
| Unset variable | `unset APP_ENV` | `Remove-Item Env:\APP_ENV` |
| Set persistent user var | Add `export VAR=val` to `~/.bashrc` | `[System.Environment]::SetEnvironmentVariable(...)` |

---

## Configuration Files Lifecycle (Linux / macOS)

### Profile vs RC Files
- **Login Shells** (e.g., SSH connection, initial GUI terminal login):
  - Parses `/etc/profile` → `~/.bash_profile` or `~/.profile` or `~/.zprofile`
- **Interactive Non-Login Shells** (e.g., opening a new tab in terminal):
  - Parses `~/.bashrc` or `~/.zshrc`

```bash
# Load changes to shell profile immediately without reconnecting
source ~/.bashrc
```

---

## Tips & Tricks

- **Inline Execution:** You can set an environment variable temporarily for a single command execution: `API_KEY="secret" python app.py`. This doesn't persist in the terminal session afterward.
- **Exporting variables:** Simply typing `VAR=val` makes it a shell variable available to the current shell only. You MUST run `export VAR=val` for child processes (scripts, programs) to inherit it.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
