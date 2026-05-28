# 🔒 Security Policy

## Supported Versions

We maintain security fixes for the following versions of this project:

| Version / Branch | Supported |
|---|---|
| `main` (latest) | ✅ Yes |
| Older branches | ❌ No — please update to `main` |

Since cheatsheets.dev is primarily a content repository, "versions" refer to the state of the `main` branch. We do not maintain separate release branches.

---

## What to Report

Even though this is a Markdown content repository, there are real security concerns we take seriously:

### 🟥 High Priority — Please Report These

| Issue Type | Example |
|---|---|
| **Malicious code in scripts** | `search.sh` or any `.sh` / `.ps1` file with injected malicious commands |
| **Shell injection vulnerabilities** | `search.sh` not sanitizing user input, allowing arbitrary command execution |
| **Dangerous commands in cheatsheets** | A cheatsheet instructing users to pipe `curl` output to `sudo sh` without warning |
| **Supply chain attacks** | Compromised GitHub Actions workflows or CI/CD scripts |
| **Credential exposure** | Cheatsheet examples using real API keys, passwords, or tokens |
| **Misleading security advice** | Commands that appear to harden a system but actually weaken it |

### 🟨 Medium Priority — Please Report These

| Issue Type | Example |
|---|---|
| **Outdated security guidance** | Commands that were once safe but are now known to be dangerous |
| **Missing security warnings** | A dangerous `rm -rf` variant with no warning label |
| **Typosquatted tool names** | Cheatsheets linking to look-alike malicious packages |

### 🟩 Low Priority / Not a Security Issue

| Issue | What to do instead |
|---|---|
| A command that doesn't work | Open a regular [GitHub Issue](https://github.com/yourusername/cheatsheets.dev/issues) |
| Outdated software version info | Open a regular PR or Issue |
| Typos or grammar | Open a regular PR |

---

## 🚨 Responsible Disclosure Process

We ask that you follow responsible disclosure practices:

### Step 1 — Do NOT open a public GitHub Issue

Public issues are visible to everyone immediately. For security concerns, please use a private channel first.

### Step 2 — Report Privately

**Option A (Preferred): GitHub Private Security Advisory**

1. Go to the [Security tab](https://github.com/yourusername/cheatsheets.dev/security) of this repository.
2. Click **"Report a vulnerability"**.
3. Fill in the form with as much detail as possible.

**Option B: Email**

Send an email to: **security@cheatsheets.dev**

Include the following information in your report:

```
Subject: [SECURITY] Brief description of the issue

1. Type of vulnerability or concern
2. Location: which file(s) are affected (include the exact path)
3. Description: what the issue is and why it is a security concern
4. Steps to reproduce: how someone could trigger or exploit this
5. Impact: what an attacker could achieve
6. Suggested fix (optional but appreciated)
7. Your GitHub username or contact info (optional, for credit)
```

### Step 3 — Wait for Acknowledgment

We will acknowledge your report within **48 hours** and provide a timeline for investigation and remediation.

### Step 4 — Coordinated Disclosure

We ask that you give us **7 days** to investigate and prepare a fix before any public disclosure. For critical vulnerabilities in scripts, we will act within **24 hours**.

---

## 🏆 Recognition

We believe in recognizing security researchers who help make this project safer:

- Your name (or GitHub handle) will be added to the **Security Hall of Fame** section below with your permission.
- For critical vulnerabilities, we will give you a shout-out in the release notes.

We do not currently offer a bug bounty program, but we are deeply grateful for responsible disclosures.

---

## ⚠️ Scope: What We Control

This repository contains:

| Component | In Scope? |
|---|---|
| `search.sh` — shell script with user input | ✅ Yes |
| Markdown cheatsheet content | ✅ Yes (for misleading/dangerous commands) |
| GitHub Actions workflows (`.github/workflows/`) | ✅ Yes |
| Third-party tools described in cheatsheets | ❌ No — report to that tool's maintainers |
| GitHub's own infrastructure | ❌ No — report to [GitHub Security](https://bounty.github.com/) |

---

## 🛡️ Security Best Practices for Contributors

If you're contributing scripts or automation:

```bash
# Always quote variables to prevent word splitting and globbing
grep -r "$query" ./   # ✅
grep -r $query ./     # ❌

# Validate input before using it
if [[ -z "$1" ]]; then
  echo "Error: no query provided" >&2
  exit 1
fi

# Avoid eval with user input
eval "$user_input"    # ❌ Never do this

# Use -- to separate flags from arguments (prevents flag injection)
grep -r -- "$query" ./   # ✅
```

---

## Security Hall of Fame

*No vulnerabilities have been reported yet. Be the first responsible discloser!*

---

*This policy was last updated: May 2026.*
