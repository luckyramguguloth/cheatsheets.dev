# CSS Cheatsheet

> Complete reference for CSS: selectors, layout, animations, and modern patterns.
> Last verified: May 2026 | Version: CSS3 / Living Standard

---

## Quick Reference

| Property / Concept | Example |
|---|---|
| Class selector | `.card { }` |
| ID selector | `#header { }` |
| Flexbox container | `display: flex; justify-content: center;` |
| Grid container | `display: grid; grid-template-columns: 1fr 1fr;` |
| Custom property | `--color-primary: #3498db;` |
| Media query | `@media (max-width: 768px) { }` |
| Transition | `transition: all 0.3s ease;` |
| Animation | `animation: fadeIn 1s ease forwards;` |
| Pseudo-class | `a:hover { }` |
| Pseudo-element | `p::first-line { }` |

---

## Selectors

### Basic Selectors

```css
/* Universal selector */
* { box-sizing: border-box; }

/* Type (element) selector */
p { color: #333; }

/* Class selector */
.card { border-radius: 8px; }

/* ID selector */
#header { background: #fff; }

/* Attribute selector */
input[type="text"] { border: 1px solid #ccc; }
a[href^="https"] { color: green; }      /* starts with */
a[href$=".pdf"] { color: red; }         /* ends with */
a[href*="example"] { color: blue; }     /* contains */
[data-active] { display: block; }       /* attribute exists */
```

### Combinators

```css
/* Descendant (space) */
.nav a { text-decoration: none; }

/* Child (>) */
ul > li { list-style: none; }

/* Adjacent sibling (+) */
h2 + p { margin-top: 0; }

/* General sibling (~) */
h2 ~ p { color: #666; }
```

### Grouping

```css
h1, h2, h3, h4 {
  font-family: 'Georgia', serif;
  line-height: 1.3;
}
```

---

## Specificity

**Specificity is calculated as (ID, Class/Attr/Pseudo-class, Element/Pseudo-element).**

| Selector | Specificity |
|---|---|
| `*` | 0,0,0 |
| `p` | 0,0,1 |
| `.class` | 0,1,0 |
| `#id` | 1,0,0 |
| `style=""` (inline) | 1,0,0,0 |
| `!important` | Overrides all |
| `p.class` | 0,1,1 |
| `#id .class p` | 1,1,1 |

```css
/* Avoid !important — fix specificity instead */
.component .title { color: red; }          /* 0,2,0 */
#sidebar .component .title { color: blue;} /* 1,2,0 — wins */
```

---

## Box Model

```css
.box {
  /* Content dimensions */
  width: 300px;
  height: 200px;

  /* Padding (inside border) */
  padding: 20px;                 /* all sides */
  padding: 10px 20px;            /* top/bottom, left/right */
  padding: 10px 20px 15px 5px;   /* top right bottom left */

  /* Border */
  border: 2px solid #333;
  border-radius: 8px;
  border-top: 1px dashed red;

  /* Margin (outside border) */
  margin: 0 auto;                /* center horizontally */
  margin: 20px 0;

  /* Box-sizing: include padding & border in width */
  box-sizing: border-box;        /* recommended default */
  box-sizing: content-box;       /* default (excludes padding) */
}
```

**Box sizing global reset:**
```css
*, *::before, *::after {
  box-sizing: border-box;
}
```

---

## Flexbox

### Container Properties

```css
.container {
  display: flex;
  display: inline-flex;

  /* Direction */
  flex-direction: row;            /* default: left to right */
  flex-direction: row-reverse;
  flex-direction: column;
  flex-direction: column-reverse;

  /* Wrapping */
  flex-wrap: nowrap;              /* default */
  flex-wrap: wrap;
  flex-wrap: wrap-reverse;

  /* Shorthand */
  flex-flow: row wrap;

  /* Justify content (main axis) */
  justify-content: flex-start;   /* default */
  justify-content: flex-end;
  justify-content: center;
  justify-content: space-between;
  justify-content: space-around;
  justify-content: space-evenly;

  /* Align items (cross axis, single line) */
  align-items: stretch;          /* default */
  align-items: flex-start;
  align-items: flex-end;
  align-items: center;
  align-items: baseline;

  /* Align content (cross axis, multi-line) */
  align-content: flex-start;
  align-content: flex-end;
  align-content: center;
  align-content: space-between;
  align-content: space-around;
  align-content: stretch;        /* default */

  /* Gap between items */
  gap: 16px;
  gap: 16px 24px;                /* row-gap column-gap */
  row-gap: 16px;
  column-gap: 24px;
}
```

### Item Properties

```css
.item {
  /* Order */
  order: 0;                      /* default */
  order: -1;                     /* move to front */
  order: 1;                      /* move to end */

  /* Grow/Shrink/Basis */
  flex-grow: 0;                  /* default: don't grow */
  flex-grow: 1;                  /* grow to fill */
  flex-shrink: 1;                /* default: shrink if needed */
  flex-shrink: 0;                /* don't shrink */
  flex-basis: auto;              /* default */
  flex-basis: 200px;

  /* Shorthand: grow shrink basis */
  flex: 0 1 auto;                /* default */
  flex: 1;                       /* flex: 1 1 0 */
  flex: auto;                    /* flex: 1 1 auto */
  flex: none;                    /* flex: 0 0 auto */

  /* Self-alignment (overrides align-items) */
  align-self: auto;
  align-self: flex-start;
  align-self: flex-end;
  align-self: center;
  align-self: stretch;
  align-self: baseline;
}
```

---

## CSS Grid

### Container Properties

```css
.grid {
  display: grid;
  display: inline-grid;

  /* Define columns */
  grid-template-columns: 200px 1fr 2fr;
  grid-template-columns: repeat(3, 1fr);
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));

  /* Define rows */
  grid-template-rows: auto 100px auto;
  grid-template-rows: repeat(3, minmax(100px, auto));

  /* Implicit rows/columns for overflow */
  grid-auto-rows: 100px;
  grid-auto-columns: 1fr;
  grid-auto-flow: row;           /* default */
  grid-auto-flow: column;
  grid-auto-flow: row dense;

  /* Named areas */
  grid-template-areas:
    "header header header"
    "sidebar main main"
    "footer footer footer";

  /* Shorthand */
  grid-template: auto 1fr auto / repeat(3, 1fr);

  /* Gap */
  gap: 20px;
  row-gap: 20px;
  column-gap: 30px;

  /* Alignment (all items) */
  justify-items: start;          /* inline axis */
  justify-items: end;
  justify-items: center;
  justify-items: stretch;        /* default */

  align-items: start;            /* block axis */
  align-items: end;
  align-items: center;
  align-items: stretch;          /* default */

  place-items: center;           /* align-items justify-items */

  /* Alignment (grid within container) */
  justify-content: start;
  justify-content: end;
  justify-content: center;
  justify-content: space-between;
  justify-content: space-around;

  align-content: start;
  align-content: end;
  align-content: center;
  align-content: space-between;

  place-content: center;
}
```

### Item Properties

```css
.grid-item {
  /* Column placement */
  grid-column-start: 1;
  grid-column-end: 3;
  grid-column: 1 / 3;            /* shorthand */
  grid-column: 1 / span 2;       /* span 2 columns */
  grid-column: span 2;

  /* Row placement */
  grid-row-start: 1;
  grid-row-end: 2;
  grid-row: 1 / 2;
  grid-row: 1 / span 2;

  /* Named area */
  grid-area: header;             /* matches grid-template-areas name */

  /* Shorthand: row-start / col-start / row-end / col-end */
  grid-area: 1 / 1 / 2 / 3;

  /* Self-alignment */
  justify-self: start;
  justify-self: end;
  justify-self: center;
  justify-self: stretch;

  align-self: start;
  align-self: end;
  align-self: center;
  align-self: stretch;

  place-self: center;
}
```

---

## Positioning

```css
.element {
  /* Positioning schemes */
  position: static;              /* default: normal flow */
  position: relative;           /* offset from normal position */
  position: absolute;           /* relative to nearest positioned ancestor */
  position: fixed;              /* relative to viewport */
  position: sticky;             /* relative until scroll threshold */

  /* Offsets (with non-static) */
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;

  /* Stack order */
  z-index: 10;
  z-index: -1;

  /* Center with absolute */
}

/* Center absolutely positioned element */
.centered {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

/* Sticky header */
.sticky-header {
  position: sticky;
  top: 0;
  z-index: 100;
}
```

---

## Typography

```css
.text {
  /* Font family */
  font-family: 'Helvetica Neue', Arial, sans-serif;
  font-family: 'Georgia', Times, serif;
  font-family: 'Courier New', monospace;

  /* Font size */
  font-size: 16px;
  font-size: 1rem;               /* relative to root */
  font-size: 1.2em;              /* relative to parent */
  font-size: clamp(1rem, 2.5vw, 2rem);  /* responsive */

  /* Font weight */
  font-weight: normal;           /* 400 */
  font-weight: bold;             /* 700 */
  font-weight: 300;              /* light */
  font-weight: 900;              /* black */

  /* Font style */
  font-style: normal;
  font-style: italic;

  /* Line height */
  line-height: 1.5;              /* unitless recommended */
  line-height: 24px;

  /* Letter spacing */
  letter-spacing: 0.05em;
  letter-spacing: -0.02em;

  /* Text alignment */
  text-align: left;
  text-align: center;
  text-align: right;
  text-align: justify;

  /* Text decoration */
  text-decoration: none;
  text-decoration: underline;
  text-decoration: line-through;

  /* Text transform */
  text-transform: uppercase;
  text-transform: lowercase;
  text-transform: capitalize;

  /* Text overflow */
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;

  /* Multi-line clamp */
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
```

---

## Colors & Backgrounds

```css
.element {
  /* Color formats */
  color: red;
  color: #ff0000;
  color: #f00;                   /* shorthand */
  color: rgb(255, 0, 0);
  color: rgba(255, 0, 0, 0.5);
  color: hsl(0, 100%, 50%);
  color: hsla(0, 100%, 50%, 0.5);
  color: oklch(0.62 0.26 29.23);/* modern */

  /* Background */
  background-color: #f5f5f5;
  background-image: url('image.jpg');
  background-image: linear-gradient(to right, #ff6b6b, #feca57);
  background-image: radial-gradient(circle, #fff, #000);

  background-size: cover;        /* fill, maintaining ratio */
  background-size: contain;      /* fit inside */
  background-size: 100% 100%;

  background-position: center;
  background-position: top left;

  background-repeat: no-repeat;
  background-repeat: repeat-x;

  background-attachment: fixed;  /* parallax effect */
  background-attachment: scroll;

  /* Shorthand */
  background: #f5f5f5 url('bg.png') no-repeat center/cover;

  /* Opacity */
  opacity: 0.5;                  /* affects entire element */
}
```

---

## Custom Properties (CSS Variables)

```css
/* Define variables on :root for global scope */
:root {
  --color-primary: #3498db;
  --color-secondary: #2ecc71;
  --color-danger: #e74c3c;
  --color-text: #2c3e50;
  --color-bg: #ffffff;

  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --spacing-lg: 2rem;

  --border-radius: 8px;
  --shadow: 0 2px 8px rgba(0, 0, 0, 0.1);

  --font-sans: 'Inter', system-ui, sans-serif;
  --font-size-base: 16px;
}

/* Use variables */
.button {
  background-color: var(--color-primary);
  padding: var(--spacing-sm) var(--spacing-md);
  border-radius: var(--border-radius);
  color: #fff;
}

/* Fallback value */
.element {
  color: var(--color-accent, #333);  /* fallback if undefined */
}

/* Override in component scope */
.dark-theme {
  --color-text: #ffffff;
  --color-bg: #1a1a2e;
}

/* Using calc() with variables */
.sidebar {
  width: calc(var(--spacing-lg) * 10);
}
```

---

## Pseudo-Classes

```css
/* User action */
a:hover { color: blue; }
button:active { transform: scale(0.98); }
input:focus { outline: 2px solid #3498db; }
input:focus-visible { outline: 2px solid #3498db; }

/* Structural */
li:first-child { font-weight: bold; }
li:last-child { border-bottom: none; }
li:nth-child(2) { color: red; }
li:nth-child(odd) { background: #f9f9f9; }
li:nth-child(even) { background: #fff; }
li:nth-child(3n+1) { color: blue; }
li:nth-last-child(2) { color: green; }
p:first-of-type { font-size: 1.2em; }
p:last-of-type { margin-bottom: 0; }
p:only-child { text-align: center; }
p:not(.special) { color: #666; }

/* Form state */
input:checked { accent-color: #3498db; }
input:disabled { opacity: 0.5; cursor: not-allowed; }
input:enabled { cursor: pointer; }
input:required { border-left: 3px solid red; }
input:optional { border-left: 3px solid green; }
input:valid { border-color: green; }
input:invalid { border-color: red; }
input:placeholder-shown { font-style: italic; }

/* Links */
a:link { color: blue; }
a:visited { color: purple; }
a:hover { color: darkblue; }
a:active { color: red; }
```

---

## Pseudo-Elements

```css
/* First line / letter */
p::first-line { font-weight: bold; }
p::first-letter { font-size: 2em; float: left; }

/* Before / after (must have content property) */
.button::before {
  content: "→ ";
}
.required::after {
  content: " *";
  color: red;
}

/* Placeholder styling */
input::placeholder { color: #aaa; font-style: italic; }

/* Selection styling */
::selection { background: #3498db; color: white; }

/* Marker (list bullets) */
li::marker { color: #3498db; font-size: 1.2em; }
```

---

## Transitions

```css
.button {
  background-color: #3498db;
  transition: background-color 0.3s ease;

  /* Multiple properties */
  transition:
    background-color 0.3s ease,
    transform 0.2s ease-out,
    box-shadow 0.3s ease;

  /* Shorthand: property duration timing-function delay */
  transition: all 0.3s ease 0s;
}

.button:hover {
  background-color: #2980b9;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.2);
}

/* Timing functions */
/* ease | linear | ease-in | ease-out | ease-in-out | cubic-bezier(n,n,n,n) | steps(n) */
.smooth { transition: all 0.3s ease-in-out; }
.linear { transition: all 0.3s linear; }
.bounce { transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
```

---

## Animations

```css
/* Define keyframes */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

/* Apply animation */
.element {
  animation-name: fadeIn;
  animation-duration: 0.5s;
  animation-timing-function: ease;
  animation-delay: 0.1s;
  animation-iteration-count: 1;   /* or infinite */
  animation-direction: normal;     /* reverse | alternate | alternate-reverse */
  animation-fill-mode: forwards;  /* none | forwards | backwards | both */
  animation-play-state: running;  /* paused | running */

  /* Shorthand: name duration timing delay iterations direction fill-mode */
  animation: fadeIn 0.5s ease 0.1s 1 normal forwards;

  /* Multiple animations */
  animation: fadeIn 0.5s ease, pulse 2s ease infinite;
}

/* Loading spinner */
.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}
```

---

## Media Queries

```css
/* Mobile first (min-width) */
.container { width: 100%; }

@media (min-width: 576px) { .container { max-width: 540px; } }
@media (min-width: 768px) { .container { max-width: 720px; } }
@media (min-width: 992px) { .container { max-width: 960px; } }
@media (min-width: 1200px) { .container { max-width: 1140px; } }
@media (min-width: 1400px) { .container { max-width: 1320px; } }

/* Desktop first (max-width) */
@media (max-width: 768px) {
  .sidebar { display: none; }
  .nav { flex-direction: column; }
}

/* Range */
@media (min-width: 600px) and (max-width: 900px) { }

/* Orientation */
@media (orientation: landscape) { }
@media (orientation: portrait) { }

/* Dark mode */
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg: #1a1a2e;
    --color-text: #ffffff;
  }
}

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}

/* Print */
@media print {
  .no-print { display: none; }
  a::after { content: " (" attr(href) ")"; }
}

/* High resolution / retina */
@media (-webkit-min-device-pixel-ratio: 2), (min-resolution: 192dpi) {
  .logo { background-image: url('logo@2x.png'); }
}
```

---

## Units

| Unit | Type | Description |
|---|---|---|
| `px` | Absolute | Pixels |
| `em` | Relative | Relative to parent font-size |
| `rem` | Relative | Relative to root font-size |
| `%` | Relative | Relative to parent |
| `vw` | Viewport | 1% of viewport width |
| `vh` | Viewport | 1% of viewport height |
| `vmin` | Viewport | 1% of smaller dimension |
| `vmax` | Viewport | 1% of larger dimension |
| `dvh` | Viewport | Dynamic viewport height (mobile) |
| `fr` | Grid | Fraction of available grid space |
| `ch` | Font | Width of the "0" character |
| `ex` | Font | Height of the "x" character |
| `pt` | Absolute | 1/72 of an inch (print) |
| `cm`, `mm` | Absolute | Centimeters, millimeters |

---

## Transform

```css
.element {
  /* Translate */
  transform: translateX(50px);
  transform: translateY(-20px);
  transform: translate(50px, -20px);
  transform: translateZ(100px);        /* 3D */
  transform: translate3d(x, y, z);

  /* Scale */
  transform: scaleX(1.5);
  transform: scaleY(0.5);
  transform: scale(1.2);
  transform: scale(1.5, 0.5);

  /* Rotate */
  transform: rotate(45deg);
  transform: rotateX(45deg);          /* 3D */
  transform: rotateY(45deg);          /* 3D */

  /* Skew */
  transform: skewX(15deg);
  transform: skewY(10deg);
  transform: skew(15deg, 10deg);

  /* Multiple transforms */
  transform: translateY(-5px) scale(1.05) rotate(2deg);

  /* Transform origin */
  transform-origin: center;           /* default */
  transform-origin: top left;
  transform-origin: 50% 50%;
  transform-origin: 0 0;

  /* 3D perspective */
  perspective: 1000px;
}
```

---

## Common Patterns

### Centering

```css
/* Flexbox center */
.flex-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

/* Grid center */
.grid-center {
  display: grid;
  place-items: center;
}

/* Absolute center */
.abs-center {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

/* Margin auto (horizontal) */
.container {
  max-width: 1200px;
  margin: 0 auto;
}
```

### Card Component

```css
.card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 24px;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}
```

### Responsive Grid

```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 24px;
}
```

### Truncate Text

```css
.truncate {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 200px;
}
```

### Visually Hidden (Accessible)

```css
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

### Aspect Ratio

```css
.video-wrapper {
  aspect-ratio: 16 / 9;
  width: 100%;
}

.square { aspect-ratio: 1; }
```

### Custom Scrollbar

```css
::-webkit-scrollbar { width: 8px; }
::-webkit-scrollbar-track { background: #f1f1f1; }
::-webkit-scrollbar-thumb { background: #888; border-radius: 4px; }
::-webkit-scrollbar-thumb:hover { background: #555; }
```

---

## Tips & Tricks

- Use `box-sizing: border-box` globally to make sizing intuitive
- Prefer `rem` for font sizes and `em` for spacing relative to font
- Use `clamp(min, preferred, max)` for fluid responsive sizes
- `gap` on flex containers is cleaner than margin hacks
- Prefer custom properties over repeated values — enables easy theming
- Use `will-change: transform` sparingly to hint GPU acceleration
- `prefers-reduced-motion` media query is essential for accessibility
- `:focus-visible` targets keyboard focus only (not mouse click)
- Use `aspect-ratio` instead of the padding-top hack for responsive ratios
- `currentColor` inherits the element's color value in other properties
- CSS `@layer` helps manage specificity in large projects
- `contain: layout style` improves performance by scoping paint/layout

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
