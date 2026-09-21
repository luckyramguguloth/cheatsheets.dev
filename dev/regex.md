# Regex Cheatsheet

> Pattern matching language for searching and manipulating text.
> Last verified: May 2026 | Version: PCRE2 / ECMAScript 2024

---

## Quick Reference

| Pattern | Description |
|---|---|
| `.` | Any character except newline |
| `^` | Start of string/line |
| `$` | End of string/line |
| `*` | Zero or more |
| `+` | One or more |
| `?` | Zero or one (optional) |
| `{n,m}` | Between n and m times |
| `[abc]` | Character class (a, b, or c) |
| `[^abc]` | Negated class (not a, b, c) |
| `\d` | Digit `[0-9]` |
| `\w` | Word character `[a-zA-Z0-9_]` |
| `\s` | Whitespace `[ \t\r\n\f]` |
| `\b` | Word boundary |
| `(abc)` | Capturing group |
| `(?:abc)` | Non-capturing group |
| `a\|b` | Alternation (a or b) |
| `(?=...)` | Positive lookahead |
| `(?!...)` | Negative lookahead |
| `(?<=...)` | Positive lookbehind |
| `(?<!...)` | Negative lookbehind |

---

## Anchors

```regex
^           Start of string (or line with m flag)
$           End of string (or line with m flag)
\A          Start of string (not affected by multiline)
\Z          End of string (not affected by multiline)
\b          Word boundary (between \w and \W)
\B          Not a word boundary
\G          Start of current match (continuing from last)
```

**Examples:**

```regex
^Hello           Matches "Hello" only at start
world$           Matches "world" only at end
\bcat\b          Matches "cat" not "catch" or "scat"
\Bcat\B          Matches "cat" inside a word (e.g., "scat")
^\d+$            Entire string is digits
```

---

## Character Classes

### Predefined Classes

```regex
\d          Digit: [0-9]
\D          Non-digit: [^0-9]
\w          Word char: [a-zA-Z0-9_]
\W          Non-word char: [^a-zA-Z0-9_]
\s          Whitespace: [ \t\r\n\f\v]
\S          Non-whitespace
\n          Newline
\t          Tab
\r          Carriage return
\f          Form feed
\v          Vertical tab
```

### Custom Character Classes

```regex
[abc]           Matches a, b, or c
[a-z]           Lowercase letter a to z
[A-Z]           Uppercase letter A to Z
[0-9]           Digit 0 to 9
[a-zA-Z]        Any letter
[a-zA-Z0-9]     Alphanumeric
[^abc]          NOT a, b, or c (negation)
[^0-9]          Not a digit
[a-z&&[^aeiou]] Consonants (PCRE intersection)
[.\-+]          Literal . - + inside class
```

**POSIX classes (works in grep/sed):**

```regex
[:alpha:]   Letters [a-zA-Z]
[:digit:]   Digits [0-9]
[:alnum:]   Alphanumeric [a-zA-Z0-9]
[:lower:]   Lowercase [a-z]
[:upper:]   Uppercase [A-Z]
[:space:]   Whitespace
[:punct:]   Punctuation
```

---

## Quantifiers

```regex
*           Zero or more (greedy)
+           One or more (greedy)
?           Zero or one (optional, greedy)
{n}         Exactly n times
{n,}        n or more times
{n,m}       Between n and m times (inclusive)

# Lazy (non-greedy) — add ? after quantifier
*?          Zero or more (lazy)
+?          One or more (lazy)
??          Zero or one (lazy)
{n,m}?      Between n and m (lazy, prefer fewer)

# Possessive (no backtracking, PCRE only)
*+          Zero or more (possessive)
++          One or more (possessive)
```

**Greedy vs Lazy example:**

```regex
# Input: <b>Bold</b> and <i>italic</i>
<.+>        Greedy — matches entire string (all of it)
<.+?>       Lazy — matches <b> then </b> separately
```

---

## Groups

```regex
(abc)           Capturing group — captures and backreferences
(?:abc)         Non-capturing group — groups but no capture
(?<name>abc)    Named capturing group
(?P<name>abc)   Named group (Python/PCRE syntax)
(?'name'abc)    Named group (PCRE alternative syntax)

# Backreferences
\1              First captured group
\2              Second captured group
\k<name>        Named group reference (PCRE)
$1              First group in replacement string
${name}         Named group in replacement

# Examples
(\w+) \1                Matches repeated word: "hello hello"
(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})
                        Named date parts
```

---

## Alternation

```regex
cat|dog         Matches "cat" or "dog"
(cat|dog)s      Matches "cats" or "dogs"
gr(a|e)y        Matches "gray" or "grey"
^(foo|bar)$     Entire string is "foo" or "bar"
```

---

## Lookaheads & Lookbehinds

### Lookahead (zero-width assertion ahead)

```regex
(?=pattern)     Positive lookahead — must be followed by pattern
(?!pattern)     Negative lookahead — must NOT be followed by pattern

# Examples
\d+(?= dollars)     Matches number followed by " dollars"
\w+(?!ing)          Matches word NOT followed by "ing"
foo(?=bar)          Matches "foo" in "foobar" but not "foobaz"
```

### Lookbehind (zero-width assertion behind)

```regex
(?<=pattern)    Positive lookbehind — must be preceded by pattern
(?<!pattern)    Negative lookbehind — must NOT be preceded by pattern

# Examples
(?<=\$)\d+      Matches digits preceded by $
(?<!un)happy    Matches "happy" but not "unhappy"
(?<=<b>)\w+     Matches word inside <b> tag
```

---

## Flags / Modifiers

```regex
i           Case-insensitive matching
g           Global — find all matches (not just first)
m           Multiline — ^ and $ match line boundaries
s           Dotall — . matches newline too
x           Extended — allow whitespace and comments
u           Unicode — enable Unicode matching
y           Sticky — match at exact position (JS)
```

**Inline flags:**

```regex
(?i)hello       Case-insensitive from this point
(?m)^line       Multiline from this point
(?s).+          Dotall from this point
(?i-m)text      Enable i, disable m
(?ims)          Multiple flags inline
```

---

## Common Patterns

### Email Address

```regex
^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$
```

### URL

```regex
https?://(?:[-\w.]|(?:%[\da-fA-F]{2}))+(?:/[^?\s]*)?(?:\?[^\s]*)?
```

### IPv4 Address

```regex
^(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)$
```

### IPv6 Address

```regex
^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$
```

### Date (YYYY-MM-DD)

```regex
^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$
```

### Time (HH:MM or HH:MM:SS)

```regex
^([01]\d|2[0-3]):([0-5]\d)(?::([0-5]\d))?$
```

### Phone Number (US)

```regex
^(?:\+1[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$
```

### Zip Code (US)

```regex
^\d{5}(?:-\d{4})?$
```

### Credit Card

```regex
^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13})$
```

### Hexadecimal Color

```regex
^#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})$
```

### Slug (URL-safe string)

```regex
^[a-z0-9]+(?:-[a-z0-9]+)*$
```

### Strong Password

```regex
^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$
```

### Username (3-16 alphanumeric + underscore)

```regex
^[a-zA-Z0-9_]{3,16}$
```

### HTML Tag

```regex
<([a-zA-Z][a-zA-Z0-9]*)\b[^>]*>(.*?)<\/\1>
```

### JSON String Value

```regex
"([^"\\]|\\.)*"
```

---

## Language-Specific Syntax

### Python (`re` module)

```python
import re

# Compile pattern
pattern = re.compile(r'\d+', re.IGNORECASE)

# Match at start
m = re.match(r'\d+', '123abc')
m.group()       # '123'

# Search anywhere
m = re.search(r'\d+', 'abc123')
m.group()       # '123'
m.start()       # 3
m.end()         # 6

# Find all matches
re.findall(r'\d+', 'a1 b22 c333')  # ['1', '22', '333']

# Find all with groups
re.findall(r'(\w+)=(\w+)', 'a=1 b=2')  # [('a','1'), ('b','2')]

# Iterator of match objects
for m in re.finditer(r'\w+', text):
    print(m.group(), m.start())

# Replace
re.sub(r'\d+', 'NUM', 'a1 b22')    # 'a NUM b NUM'
re.sub(r'(\w+)', r'[\1]', 'hello') # '[hello]'
re.sub(r'\d+', 'X', text, count=1) # replace first only

# Split
re.split(r'\s+', 'one  two   three')  # ['one', 'two', 'three']

# Flags
re.IGNORECASE   # re.I
re.MULTILINE    # re.M
re.DOTALL       # re.S
re.VERBOSE      # re.X (allow whitespace/comments)
re.UNICODE      # re.U (default in Python 3)

# Named groups
m = re.match(r'(?P<year>\d{4})-(?P<month>\d{2})', '2024-01')
m.group('year')     # '2024'
m.groupdict()       # {'year': '2024', 'month': '01'}
```

### JavaScript

```javascript
// Literal syntax
const pattern = /\d+/g;
const pattern2 = /hello/i;

// Constructor (for dynamic patterns)
const pattern3 = new RegExp('\\d+', 'g');

// Test (returns boolean)
/^\d+$/.test('123');     // true

// Match
'abc123'.match(/\d+/);          // ['123'] + index
'a1 b2'.match(/\d+/g);          // ['1', '2'] (global)

// matchAll (returns iterator)
for (const m of 'a1 b2'.matchAll(/(\w)(\d)/g)) {
    console.log(m[0], m[1], m[2]);
}

// Replace
'hello'.replace(/l/g, 'L');     // 'heLLo'
'2024-01'.replace(/(\d{4})-(\d{2})/, '$2/$1');  // '01/2024'
'world'.replace(/(\w+)/, (match, p1) => p1.toUpperCase());

// Split
'one,two,,three'.split(/,+/);   // ['one', 'two', 'three']

// Search (returns index or -1)
'hello world'.search(/world/);  // 6

// Flags: g, i, m, s, u, y, d
```

### grep / sed / awk

```bash
# grep — basic regex (BRE by default)
grep 'pattern' file.txt
grep -E 'pattern+' file.txt    # Extended regex (ERE)
grep -P 'pattern' file.txt     # Perl-compatible (PCRE)
grep -F 'literal' file.txt     # Fixed string (no regex)

# BRE vs ERE differences:
# BRE: \( \) \{ \} \+ \? \|  (must escape special chars)
# ERE: (  )  {  }  +  ?  |   (no escape needed)

# sed
sed 's/old/new/' file          # BRE by default
sed -E 's/old+/new/' file      # Extended regex
sed 's/\(group\)/\1/' file     # BRE group reference
sed -E 's/(group)/\1/' file    # ERE group reference

# awk
awk '/pattern/ {print}'        # ERE in awk
awk '$0 ~ /pattern/ {print}'   # explicit match
awk 'match($0, /(\d+)/, arr) {print arr[1]}'  # capture group
```

---

## Advanced Patterns

### Recursive/Balanced Matching (PCRE only)

```regex
# Match balanced parentheses
\((?:[^()]*|(?R))*\)

# Match nested HTML tags (not recommended, use parser)
<(\w+)(?:[^>]*)>(?:(?!<\1)[\s\S]|(?R))*</\1>
```

### Atomic Groups & Possessive

```regex
(?>pattern)     Atomic group — no backtracking inside
\w++            Possessive quantifier — no backtracking
```

### Conditionals (PCRE)

```regex
(?(1)yes|no)    If group 1 matched, use "yes" pattern; else "no"
(?(?=cond)yes)  Conditional based on lookahead
```

---

## Tips & Tricks

- **Use raw strings** in Python: `r'\d+'` so you don't double-escape backslashes.
- **Anchor your patterns**: `^\d+$` matches whole string; `\d+` matches anywhere.
- **Prefer non-capturing groups** `(?:...)` when you don't need the capture — faster.
- **Lazy quantifiers** `+?` help avoid catastrophic backtracking on nested patterns.
- **Use named groups** `(?P<name>...)` for readability in complex patterns.
- **Test at regex101.com** — explains each part and shows matches visually.
- **Atomic groups** `(?>...)` and possessive quantifiers `++` prevent catastrophic backtracking.
- For HTML/XML parsing, prefer a proper parser (BeautifulSoup, lxml) over regex.
- **`re.VERBOSE`** allows inline comments and whitespace — great for complex patterns.
- Remember that `.` does NOT match newlines by default; use `re.DOTALL` or `(?s)`.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
