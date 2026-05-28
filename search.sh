#!/usr/bin/env bash
# =============================================================================
# search.sh — Offline search for cheatsheets.dev
# =============================================================================
#
# Usage:
#   ./search.sh <query>           Search all cheatsheets for a term
#   ./search.sh --list            List all available cheatsheets
#   ./search.sh --list <category> List cheatsheets in a specific category
#   ./search.sh --help            Show this help message
#
# Examples:
#   ./search.sh "docker stop"
#   ./search.sh "git rebase"
#   ./search.sh kubectl
#   ./search.sh --list
#   ./search.sh --list devops
#
# Features:
#   - Uses fzf for interactive fuzzy search (if installed)
#   - Falls back to grep with color-highlighted output
#   - Works 100% offline — no internet required
#   - Searches all .md files recursively from the repo root
#   - --list flag shows all available cheatsheets with category
#
# Requirements:
#   - bash 4.0+
#   - grep (standard on all systems)
#   - fzf (optional, for interactive mode) — https://github.com/junegunn/fzf
#
# =============================================================================

set -euo pipefail

# =============================================================================
# Color definitions (ANSI escape codes)
# =============================================================================

# Detect if terminal supports colors
if [ -t 1 ] && [ "${NO_COLOR:-}" = "" ]; then
  COLOR_RESET="\033[0m"
  COLOR_BOLD="\033[1m"
  COLOR_DIM="\033[2m"
  COLOR_RED="\033[31m"
  COLOR_GREEN="\033[32m"
  COLOR_YELLOW="\033[33m"
  COLOR_BLUE="\033[34m"
  COLOR_MAGENTA="\033[35m"
  COLOR_CYAN="\033[36m"
  COLOR_WHITE="\033[37m"
  COLOR_BG_BLUE="\033[44m"
else
  # No color support — define empty strings
  COLOR_RESET=""
  COLOR_BOLD=""
  COLOR_DIM=""
  COLOR_RED=""
  COLOR_GREEN=""
  COLOR_YELLOW=""
  COLOR_BLUE=""
  COLOR_MAGENTA=""
  COLOR_CYAN=""
  COLOR_WHITE=""
  COLOR_BG_BLUE=""
fi

# =============================================================================
# Configuration
# =============================================================================

# Resolve the script's directory so it works from any working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

# Category folders to search (add new folders here as the repo grows)
CATEGORY_DIRS=(
  "dev"
  "devops"
  "gaming"
  "hardware"
)

# Files and patterns to exclude from search
EXCLUDE_PATTERNS=(
  "TEMPLATE.md"
  "README.md"
  "CONTRIBUTING.md"
  "SECURITY.md"
  "CODE_OF_CONDUCT.md"
)

# Max lines of context shown around each match (grep fallback mode)
CONTEXT_LINES=0

# =============================================================================
# Helper functions
# =============================================================================

# Print a styled banner
print_banner() {
  echo ""
  echo -e "${COLOR_BOLD}${COLOR_CYAN} ──────────────────────────────────────────────────────────── ${COLOR_RESET}"
  echo -e "${COLOR_BOLD}${COLOR_CYAN}  📚  cheatsheets.dev — Offline Search                        ${COLOR_RESET}"
  echo -e "${COLOR_BOLD}${COLOR_CYAN} ──────────────────────────────────────────────────────────── ${COLOR_RESET}"
  echo ""
}

# Print a divider line
print_divider() {
  echo -e "${COLOR_DIM} ──────────────────────────────────────────────────────────── ${COLOR_RESET}"
}

# Print the help message
print_help() {
  print_banner
  echo -e "${COLOR_BOLD}USAGE${COLOR_RESET}"
  echo -e "  ${COLOR_GREEN}./search.sh${COLOR_RESET} ${COLOR_YELLOW}<query>${COLOR_RESET}            Search all cheatsheets"
  echo -e "  ${COLOR_GREEN}./search.sh${COLOR_RESET} ${COLOR_YELLOW}--list${COLOR_RESET}             List all available cheatsheets"
  echo -e "  ${COLOR_GREEN}./search.sh${COLOR_RESET} ${COLOR_YELLOW}--list <category>${COLOR_RESET}  List cheatsheets in a category"
  echo -e "  ${COLOR_GREEN}./search.sh${COLOR_RESET} ${COLOR_YELLOW}--help${COLOR_RESET}             Show this help message"
  echo ""
  echo -e "${COLOR_BOLD}EXAMPLES${COLOR_RESET}"
  echo -e "  ${COLOR_DIM}# Search for docker stop commands${COLOR_RESET}"
  echo -e "  ./search.sh \"docker stop\""
  echo ""
  echo -e "  ${COLOR_DIM}# Search for git rebase tips${COLOR_RESET}"
  echo -e "  ./search.sh \"git rebase\""
  echo ""
  echo -e "  ${COLOR_DIM}# List all cheatsheets${COLOR_RESET}"
  echo -e "  ./search.sh --list"
  echo ""
  echo -e "  ${COLOR_DIM}# List only DevOps cheatsheets${COLOR_RESET}"
  echo -e "  ./search.sh --list devops"
  echo ""
  echo -e "${COLOR_BOLD}OPTIONS${COLOR_RESET}"
  echo -e "  ${COLOR_YELLOW}--help${COLOR_RESET}           Show this help message and exit"
  echo -e "  ${COLOR_YELLOW}--list${COLOR_RESET}           List all available cheatsheets"
  echo -e "  ${COLOR_YELLOW}--list <cat>${COLOR_RESET}     List cheatsheets in a category (dev, devops, gaming, hardware)"
  echo -e "  ${COLOR_YELLOW}--no-color${COLOR_RESET}       Disable color output (or set NO_COLOR=1)"
  echo ""
  echo -e "${COLOR_BOLD}MODES${COLOR_RESET}"
  echo -e "  ${COLOR_CYAN}fzf${COLOR_RESET} (interactive)   Launched when fzf is installed and query is empty"
  echo -e "  ${COLOR_CYAN}grep${COLOR_RESET} (standard)     Used when fzf is not available or a query is passed"
  echo ""
  echo -e "${COLOR_BOLD}ENVIRONMENT VARIABLES${COLOR_RESET}"
  echo -e "  ${COLOR_YELLOW}NO_COLOR=1${COLOR_RESET}       Disable all color output"
  echo ""
  print_divider
  echo -e "  ${COLOR_DIM}Tip: Install fzf for interactive search → https://github.com/junegunn/fzf${COLOR_RESET}"
  print_divider
  echo ""
}

# Build the list of all markdown files to search
get_all_cheatsheet_files() {
  local files=()
  local found=false

  for dir in "${CATEGORY_DIRS[@]}"; do
    local full_dir="$REPO_ROOT/$dir"
    if [ -d "$full_dir" ]; then
      found=true
      while IFS= read -r -d '' file; do
        files+=("$file")
      done < <(find "$full_dir" -name "*.md" -type f -print0 2>/dev/null | sort -z)
    fi
  done

  # If no category dirs exist yet, search the whole repo root for .md files
  # (but exclude root-level docs)
  if [ "$found" = false ]; then
    while IFS= read -r -d '' file; do
      local basename
      basename="$(basename "$file")"
      local excluded=false
      for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [ "$basename" = "$pattern" ]; then
          excluded=true
          break
        fi
      done
      if [ "$excluded" = false ]; then
        files+=("$file")
      fi
    done < <(find "$REPO_ROOT" -maxdepth 2 -name "*.md" -type f -print0 2>/dev/null | sort -z)
  fi

  printf '%s\n' "${files[@]}"
}

# Pretty-print a cheatsheet file path relative to the repo root
format_file_path() {
  local file="$1"
  local rel_path="${file#$REPO_ROOT/}"

  # Determine category emoji
  local emoji="📄"
  case "$rel_path" in
    dev/*)      emoji="🖥️ " ;;
    devops/*)   emoji="🚀" ;;
    gaming/*)   emoji="🎮" ;;
    hardware/*) emoji="🔧" ;;
  esac

  echo -e "  ${emoji}  ${COLOR_BOLD}${rel_path}${COLOR_RESET}"
}

# =============================================================================
# List mode
# =============================================================================

cmd_list() {
  local filter="${1:-}"
  print_banner

  local count=0

  for dir in "${CATEGORY_DIRS[@]}"; do
    # If a filter was given, skip non-matching categories
    if [ -n "$filter" ] && [ "$dir" != "$filter" ]; then
      continue
    fi

    local full_dir="$REPO_ROOT/$dir"
    if [ ! -d "$full_dir" ]; then
      continue
    fi

    # Category header
    local emoji="📄"
    local label="$dir"
    case "$dir" in
      dev)      emoji="🖥️ "; label="Dev" ;;
      devops)   emoji="🚀"; label="DevOps" ;;
      gaming)   emoji="🎮"; label="Gaming" ;;
      hardware) emoji="🔧"; label="Hardware" ;;
    esac

    echo -e "${COLOR_BOLD}${COLOR_YELLOW}  $emoji  $label${COLOR_RESET}"
    print_divider

    local found_any=false
    while IFS= read -r file; do
      if [ -z "$file" ]; then continue; fi
      local rel_path="${file#$REPO_ROOT/}"
      local name
      name="$(basename "$file" .md)"
      # Extract the first line (title) from the file
      local title
      title="$(head -n 1 "$file" 2>/dev/null | sed 's/^# //' | sed 's/ Cheatsheet$//')"
      if [ -z "$title" ]; then
        title="$name"
      fi
      echo -e "    ${COLOR_GREEN}•${COLOR_RESET} ${COLOR_CYAN}${name}${COLOR_RESET}${COLOR_DIM} — ${title}${COLOR_RESET}"
      count=$((count + 1))
      found_any=true
    done < <(find "$full_dir" -name "*.md" -type f 2>/dev/null | sort)

    if [ "$found_any" = false ]; then
      echo -e "    ${COLOR_DIM}(no cheatsheets yet — be the first to contribute!)${COLOR_RESET}"
    fi

    echo ""
  done

  print_divider
  echo -e "  ${COLOR_BOLD}${COLOR_GREEN}Total: ${count} cheatsheet(s)${COLOR_RESET}"
  echo -e "  ${COLOR_DIM}Run './search.sh <query>' to search across all of them.${COLOR_RESET}"
  print_divider
  echo ""
}

# =============================================================================
# FZF interactive search mode
# =============================================================================

cmd_fzf_search() {
  print_banner
  echo -e "  ${COLOR_CYAN}${COLOR_BOLD}fzf interactive mode${COLOR_RESET} — type to fuzzy search all cheatsheets"
  echo -e "  ${COLOR_DIM}Press ENTER to open the matched file. Press ESC or Ctrl+C to exit.${COLOR_RESET}"
  echo ""

  # Build a flat list of all lines with file:line format for fzf
  local tmpfile
  tmpfile="$(mktemp)"

  while IFS= read -r file; do
    if [ -z "$file" ]; then continue; fi
    local rel_path="${file#$REPO_ROOT/}"
    grep -n "" "$file" 2>/dev/null | while IFS=: read -r lineno content; do
      printf '%s:%s:\t%s\n' "$rel_path" "$lineno" "$content"
    done
  done < <(get_all_cheatsheet_files) > "$tmpfile"

  # Launch fzf with preview
  local selection
  selection="$(fzf \
    --ansi \
    --delimiter='\t' \
    --with-nth=2 \
    --preview='
      file_line=$(echo {} | cut -d: -f1,2)
      file=$(echo "$file_line" | cut -d: -f1)
      line=$(echo "$file_line" | cut -d: -f2)
      full_path="'"$REPO_ROOT"'/$file"
      if command -v bat &>/dev/null; then
        bat --color=always --style=numbers --highlight-line="$line" "$full_path" 2>/dev/null
      else
        cat "$full_path" 2>/dev/null
      fi
    ' \
    --preview-window=right:60%:wrap \
    --height=80% \
    --border=rounded \
    --prompt="🔍 Search: " \
    --header="cheatsheets.dev | TAB=multi-select | ENTER=open | ESC=quit" \
    --bind "ctrl-/:toggle-preview" \
    < "$tmpfile" || true)"

  rm -f "$tmpfile"

  if [ -n "$selection" ]; then
    local rel_path
    rel_path="$(echo "$selection" | cut -d: -f1)"
    local full_path="$REPO_ROOT/$rel_path"
    echo ""
    echo -e "  ${COLOR_GREEN}Opening:${COLOR_RESET} ${rel_path}"
    echo ""
    # Open in $PAGER, bat, or less
    if command -v bat &>/dev/null; then
      bat --color=always --style=full "$full_path"
    elif [ -n "${PAGER:-}" ]; then
      "$PAGER" "$full_path"
    else
      less -R "$full_path"
    fi
  fi
}

# =============================================================================
# Grep search mode (no fzf)
# =============================================================================

cmd_grep_search() {
  local query="$1"
  print_banner
  echo -e "  ${COLOR_BOLD}🔍  Searching for:${COLOR_RESET} ${COLOR_YELLOW}\"${query}\"${COLOR_RESET}"
  echo ""

  local total_matches=0
  local total_files=0
  local matched_files=()

  # First pass: find all files with matches
  while IFS= read -r file; do
    if [ -z "$file" ]; then continue; fi
    if grep -qi -- "$query" "$file" 2>/dev/null; then
      matched_files+=("$file")
    fi
  done < <(get_all_cheatsheet_files)

  if [ ${#matched_files[@]} -eq 0 ]; then
    print_divider
    echo -e "  ${COLOR_RED}✗${COLOR_RESET}  No matches found for ${COLOR_YELLOW}\"${query}\"${COLOR_RESET}"
    echo ""
    echo -e "  ${COLOR_DIM}Suggestions:${COLOR_RESET}"
    echo -e "  ${COLOR_DIM}  • Try a shorter or different search term${COLOR_RESET}"
    echo -e "  ${COLOR_DIM}  • Run ./search.sh --list to browse all cheatsheets${COLOR_RESET}"
    echo -e "  ${COLOR_DIM}  • The cheatsheet may not exist yet — consider contributing!${COLOR_RESET}"
    print_divider
    echo ""
    return 1
  fi

  # Second pass: display matches with context
  for file in "${matched_files[@]}"; do
    local rel_path="${file#$REPO_ROOT/}"
    local file_matches
    file_matches="$(grep -c -i -- "$query" "$file" 2>/dev/null || true)"
    total_matches=$((total_matches + file_matches))
    total_files=$((total_files + 1))

    echo -e "  ${COLOR_BOLD}${COLOR_MAGENTA}📄 ${rel_path}${COLOR_RESET}  ${COLOR_DIM}(${file_matches} match(es))${COLOR_RESET}"
    print_divider

    # Show matching lines with line numbers and highlighted query
    grep -n -i -- "$query" "$file" 2>/dev/null | while IFS=: read -r lineno content; do
      # Pad line number
      printf "     ${COLOR_DIM}Line %4s${COLOR_RESET} │ " "$lineno"
      # Highlight the query in the line content (case-insensitive)
      echo "$content" | sed "s/$query/${COLOR_YELLOW}${COLOR_BOLD}&${COLOR_RESET}/gI" 2>/dev/null || echo "$content"
    done

    echo ""
  done

  print_divider
  echo -e "  ${COLOR_BOLD}${COLOR_GREEN}✓  Found ${total_matches} match(es)${COLOR_RESET} across ${COLOR_CYAN}${total_files} file(s)${COLOR_RESET} for ${COLOR_YELLOW}\"${query}\"${COLOR_RESET}"
  echo -e "  ${COLOR_DIM}Tip: Run ./search.sh --list to browse all available cheatsheets${COLOR_RESET}"
  print_divider
  echo ""
}

# =============================================================================
# Main entrypoint
# =============================================================================

main() {
  # No arguments — launch fzf if available, else show help
  if [ $# -eq 0 ]; then
    if command -v fzf &>/dev/null; then
      cmd_fzf_search
    else
      print_help
      echo -e "  ${COLOR_YELLOW}Tip:${COLOR_RESET} Install fzf for interactive search, or run:"
      echo -e "  ${COLOR_CYAN}./search.sh <query>${COLOR_RESET}   to search directly"
      echo ""
    fi
    return 0
  fi

  local arg="$1"

  # Handle flags
  case "$arg" in
    --help|-h)
      print_help
      return 0
      ;;
    --list|-l)
      local category="${2:-}"
      cmd_list "$category"
      return 0
      ;;
    --no-color)
      # Unset all color vars and re-run without first arg
      NO_COLOR=1
      shift
      main "$@"
      return 0
      ;;
    --*)
      echo -e "${COLOR_RED}Error:${COLOR_RESET} Unknown flag: ${arg}" >&2
      echo "Run './search.sh --help' for usage." >&2
      return 1
      ;;
  esac

  # Treat remaining args as a search query
  local query="$*"

  # Validate query is not empty after trimming
  query="$(echo "$query" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  if [ -z "$query" ]; then
    echo -e "${COLOR_RED}Error:${COLOR_RESET} Query cannot be empty." >&2
    echo "Run './search.sh --help' for usage." >&2
    return 1
  fi

  # Use fzf with query pre-filled if available, else fall back to grep
  if command -v fzf &>/dev/null && [ -t 1 ] && [ -t 0 ]; then
    # fzf is available and we're in an interactive terminal
    # Build temp file and launch fzf with pre-filled query
    print_banner
    echo -e "  ${COLOR_CYAN}${COLOR_BOLD}fzf mode${COLOR_RESET} — pre-filled with: ${COLOR_YELLOW}\"${query}\"${COLOR_RESET}"
    echo -e "  ${COLOR_DIM}Press ENTER to view file. Press ESC to exit.${COLOR_RESET}"
    echo ""

    local tmpfile
    tmpfile="$(mktemp)"

    while IFS= read -r file; do
      if [ -z "$file" ]; then continue; fi
      local rel_path="${file#$REPO_ROOT/}"
      grep -n "" "$file" 2>/dev/null | while IFS=: read -r lineno content; do
        printf '%s:%s:\t%s\n' "$rel_path" "$lineno" "$content"
      done
    done < <(get_all_cheatsheet_files) > "$tmpfile"

    local selection
    selection="$(fzf \
      --ansi \
      --query="$query" \
      --delimiter='\t' \
      --with-nth=2 \
      --preview='
        file_line=$(echo {} | cut -d: -f1,2)
        file=$(echo "$file_line" | cut -d: -f1)
        line=$(echo "$file_line" | cut -d: -f2)
        full_path="'"$REPO_ROOT"'/$file"
        if command -v bat &>/dev/null; then
          bat --color=always --style=numbers --highlight-line="$line" "$full_path" 2>/dev/null
        else
          cat "$full_path" 2>/dev/null
        fi
      ' \
      --preview-window=right:60%:wrap \
      --height=80% \
      --border=rounded \
      --prompt="🔍 Search: " \
      --header="cheatsheets.dev | ENTER=open file | ESC=quit | Ctrl+/=toggle preview" \
      --bind "ctrl-/:toggle-preview" \
      < "$tmpfile" || true)"

    rm -f "$tmpfile"

    if [ -n "$selection" ]; then
      local rel_path
      rel_path="$(echo "$selection" | cut -d: -f1)"
      local full_path="$REPO_ROOT/$rel_path"
      echo ""
      echo -e "  ${COLOR_GREEN}Opening:${COLOR_RESET} ${rel_path}"
      echo ""
      if command -v bat &>/dev/null; then
        bat --color=always --style=full "$full_path"
      elif [ -n "${PAGER:-}" ]; then
        "$PAGER" "$full_path"
      else
        less -R "$full_path"
      fi
    fi
  else
    # Non-interactive or no fzf — use grep fallback
    cmd_grep_search "$query"
  fi
}

main "$@"
