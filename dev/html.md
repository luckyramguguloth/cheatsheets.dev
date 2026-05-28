# HTML Cheatsheet

> Reference for HTML5 elements, forms, accessibility, and semantic patterns.
> Last verified: May 2026 | Version: HTML5 / Living Standard

---

## Quick Reference

| Element | Purpose |
|---|---|
| `<header>` | Page/section header |
| `<nav>` | Navigation links |
| `<main>` | Primary content |
| `<article>` | Self-contained content |
| `<section>` | Thematic grouping |
| `<aside>` | Tangentially related content |
| `<footer>` | Page/section footer |
| `<figure>` | Media with caption |
| `<details>` | Collapsible disclosure widget |
| `<dialog>` | Modal/non-modal dialog |

---

## Document Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Page description for SEO">
  <meta name="author" content="Author Name">
  <meta name="robots" content="index, follow">

  <!-- Open Graph (social sharing) -->
  <meta property="og:title" content="Page Title">
  <meta property="og:description" content="Description">
  <meta property="og:image" content="https://example.com/image.jpg">
  <meta property="og:url" content="https://example.com/page">
  <meta property="og:type" content="website">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Page Title">
  <meta name="twitter:description" content="Description">
  <meta name="twitter:image" content="https://example.com/image.jpg">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="/favicon.png">
  <link rel="apple-touch-icon" href="/apple-touch-icon.png">

  <!-- Stylesheet -->
  <link rel="stylesheet" href="/styles.css">

  <!-- Preload critical assets -->
  <link rel="preload" href="/font.woff2" as="font" type="font/woff2" crossorigin>
  <link rel="preconnect" href="https://fonts.googleapis.com">

  <!-- Canonical URL -->
  <link rel="canonical" href="https://example.com/page">

  <title>Page Title | Site Name</title>
</head>
<body>
  <!-- content -->
  <script src="/main.js" defer></script>
</body>
</html>
```

---

## Semantic Elements

### Page Layout

```html
<header>
  <nav aria-label="Main navigation">
    <ul>
      <li><a href="/">Home</a></li>
      <li><a href="/about">About</a></li>
    </ul>
  </nav>
</header>

<main id="main-content">
  <article>
    <header>
      <h1>Article Title</h1>
      <p>By <address rel="author">Jane Doe</address> on <time datetime="2026-05-28">May 28, 2026</time></p>
    </header>
    <section>
      <h2>Section Heading</h2>
      <p>Content...</p>
    </section>
    <footer>Article footer</footer>
  </article>

  <aside aria-label="Related links">
    <h2>Related</h2>
    <ul>...</ul>
  </aside>
</main>

<footer>
  <p>&copy; 2026 Company Name</p>
  <nav aria-label="Footer navigation">...</nav>
</footer>
```

### Text Content

```html
<!-- Headings (h1 once per page for SEO) -->
<h1>Main Title</h1>
<h2>Section</h2>
<h3>Subsection</h3>
<h4>Sub-subsection</h4>
<h5>Minor heading</h5>
<h6>Smallest heading</h6>

<!-- Paragraphs and inline -->
<p>A paragraph with <strong>important text</strong> and <em>emphasized text</em>.</p>
<p>Also <b>bold</b> (stylistic), <i>italic</i> (stylistic), <u>underline</u>.</p>
<p><small>Fine print</small> and <mark>highlighted text</mark>.</p>
<p><del>Deleted text</del> and <ins>inserted text</ins>.</p>
<p><sub>subscript</sub> and <sup>superscript</sup>.</p>
<p><code>inline code</code> and <kbd>keyboard input</kbd>.</p>
<p><var>variable</var> and <samp>sample output</samp>.</p>
<p><abbr title="HyperText Markup Language">HTML</abbr> is a markup language.</p>
<p><cite>Book Title</cite> by Author.</p>
<p><q cite="https://example.com">Inline quotation.</q></p>

<!-- Block quote -->
<blockquote cite="https://example.com">
  <p>A famous quote goes here.</p>
  <footer>— <cite>Author Name</cite></footer>
</blockquote>

<!-- Preformatted / code block -->
<pre><code>
function hello() {
  console.log("Hello, world!");
}
</code></pre>

<!-- Horizontal rule -->
<hr>

<!-- Line break -->
<br>

<!-- Word break opportunity -->
<wbr>

<!-- Details/Summary (accordion) -->
<details>
  <summary>Click to expand</summary>
  <p>Hidden content revealed on click.</p>
</details>

<!-- Dialog -->
<dialog id="my-dialog">
  <form method="dialog">
    <p>Dialog content</p>
    <button value="cancel">Cancel</button>
    <button value="confirm">Confirm</button>
  </form>
</dialog>
```

---

## Lists

```html
<!-- Unordered list -->
<ul>
  <li>Item one</li>
  <li>Item two</li>
  <li>Nested:
    <ul>
      <li>Nested item</li>
    </ul>
  </li>
</ul>

<!-- Ordered list -->
<ol>
  <li>First step</li>
  <li>Second step</li>
  <li>Third step</li>
</ol>

<!-- Ordered with attributes -->
<ol start="5" reversed type="A">
  <li>Starts at E (reversed: E, D, C...)</li>
</ol>

<!-- Description list -->
<dl>
  <dt>HTML</dt>
  <dd>HyperText Markup Language</dd>
  <dt>CSS</dt>
  <dd>Cascading Style Sheets</dd>
</dl>
```

---

## Links & Images

```html
<!-- Basic link -->
<a href="https://example.com">Visit Example</a>

<!-- Open in new tab -->
<a href="https://example.com" target="_blank" rel="noopener noreferrer">External Link</a>

<!-- Download link -->
<a href="/files/report.pdf" download="report.pdf">Download PDF</a>
<a href="/files/report.pdf" download>Download PDF</a>

<!-- Anchor (jump to section) -->
<a href="#section-id">Jump to section</a>
<section id="section-id">...</section>

<!-- Email / phone link -->
<a href="mailto:hello@example.com">Email us</a>
<a href="mailto:hello@example.com?subject=Hello&body=Hi there">Email with subject</a>
<a href="tel:+15551234567">Call us</a>

<!-- Image -->
<img src="/images/photo.jpg"
     alt="A descriptive alternative text"
     width="800"
     height="600"
     loading="lazy"
     decoding="async">

<!-- Responsive image (srcset) -->
<img src="/images/photo-400.jpg"
     srcset="/images/photo-400.jpg 400w,
             /images/photo-800.jpg 800w,
             /images/photo-1200.jpg 1200w"
     sizes="(max-width: 600px) 400px,
            (max-width: 900px) 800px,
            1200px"
     alt="Responsive photo"
     loading="lazy">

<!-- Art direction with picture -->
<picture>
  <source media="(max-width: 600px)" srcset="/images/mobile.jpg">
  <source media="(min-width: 601px)" srcset="/images/desktop.jpg">
  <img src="/images/desktop.jpg" alt="Fallback image">
</picture>

<!-- WebP with fallback -->
<picture>
  <source srcset="/images/photo.webp" type="image/webp">
  <source srcset="/images/photo.avif" type="image/avif">
  <img src="/images/photo.jpg" alt="Photo">
</picture>

<!-- Figure with caption -->
<figure>
  <img src="/images/chart.png" alt="Sales chart for Q1 2026">
  <figcaption>Figure 1: Q1 2026 Sales Data</figcaption>
</figure>
```

---

## Tables

```html
<table>
  <caption>Monthly Sales Report</caption>
  <thead>
    <tr>
      <th scope="col">Month</th>
      <th scope="col">Revenue</th>
      <th scope="col">Growth</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">January</th>
      <td>$10,000</td>
      <td>+5%</td>
    </tr>
    <tr>
      <th scope="row">February</th>
      <td>$12,000</td>
      <td>+20%</td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <th scope="row">Total</th>
      <td>$22,000</td>
      <td>+12.5%</td>
    </tr>
  </tfoot>
</table>

<!-- Spanning cells -->
<tr>
  <td colspan="2">Spans 2 columns</td>
</tr>
<tr>
  <td rowspan="2">Spans 2 rows</td>
  <td>Other cell</td>
</tr>
```

---

## Forms

### Form Wrapper

```html
<form
  action="/submit"
  method="POST"
  enctype="multipart/form-data"  <!-- for file uploads -->
  novalidate                     <!-- disable native validation -->
  autocomplete="on"
>
  <!-- inputs -->
</form>
```

### All Input Types

```html
<!-- Text inputs -->
<input type="text" name="username" placeholder="Enter username" required minlength="3" maxlength="20">
<input type="email" name="email" autocomplete="email" required>
<input type="password" name="password" minlength="8" autocomplete="new-password">
<input type="search" name="q" placeholder="Search...">
<input type="url" name="website" placeholder="https://example.com">
<input type="tel" name="phone" pattern="[0-9]{10}" placeholder="1234567890">

<!-- Number inputs -->
<input type="number" name="age" min="0" max="120" step="1">
<input type="range" name="volume" min="0" max="100" step="5" value="50">

<!-- Date/Time inputs -->
<input type="date" name="birthday" min="1900-01-01" max="2026-12-31">
<input type="time" name="meeting-time" min="09:00" max="18:00" step="900">
<input type="datetime-local" name="event-datetime">
<input type="month" name="birth-month">
<input type="week" name="week">

<!-- Choice inputs -->
<input type="checkbox" name="agree" id="agree" value="yes" checked>
<label for="agree">I agree to the terms</label>

<input type="radio" name="gender" id="male" value="male">
<label for="male">Male</label>
<input type="radio" name="gender" id="female" value="female">
<label for="female">Female</label>

<!-- File input -->
<input type="file" name="avatar" accept="image/png, image/jpeg" multiple>
<input type="file" name="document" accept=".pdf,.doc,.docx">

<!-- Color -->
<input type="color" name="theme-color" value="#3498db">

<!-- Hidden -->
<input type="hidden" name="csrf_token" value="abc123">

<!-- Buttons -->
<input type="submit" value="Submit">
<input type="reset" value="Reset">
<input type="button" value="Click Me">
<input type="image" src="/btn.png" alt="Submit">

<!-- Button element (preferred) -->
<button type="submit">Submit Form</button>
<button type="button" onclick="doSomething()">Click</button>
<button type="reset">Reset</button>
```

### Textarea & Select

```html
<!-- Textarea -->
<textarea
  name="message"
  rows="5"
  cols="40"
  placeholder="Write your message..."
  maxlength="500"
  required
></textarea>

<!-- Select dropdown -->
<select name="country" required>
  <option value="" disabled selected>Choose a country</option>
  <optgroup label="Americas">
    <option value="us">United States</option>
    <option value="ca">Canada</option>
    <option value="mx">Mexico</option>
  </optgroup>
  <optgroup label="Europe">
    <option value="gb">United Kingdom</option>
    <option value="de">Germany</option>
  </optgroup>
</select>

<!-- Multi-select -->
<select name="skills" multiple size="4">
  <option value="html">HTML</option>
  <option value="css">CSS</option>
  <option value="js" selected>JavaScript</option>
</select>

<!-- Datalist (autocomplete suggestions) -->
<input list="browsers" name="browser" placeholder="Choose a browser">
<datalist id="browsers">
  <option value="Chrome">
  <option value="Firefox">
  <option value="Safari">
  <option value="Edge">
</datalist>
```

### Form Organization

```html
<!-- Label (always associate with input) -->
<label for="email">Email Address</label>
<input type="email" id="email" name="email">

<!-- Wrapping label (no 'for' needed) -->
<label>
  Email Address
  <input type="email" name="email">
</label>

<!-- Fieldset and legend -->
<fieldset>
  <legend>Personal Information</legend>
  <label for="first-name">First Name</label>
  <input type="text" id="first-name" name="first-name">

  <label for="last-name">Last Name</label>
  <input type="text" id="last-name" name="last-name">
</fieldset>

<!-- Output element -->
<form oninput="result.value = parseInt(a.value) + parseInt(b.value)">
  <input type="range" id="a" value="50"> +
  <input type="number" id="b" value="50"> =
  <output name="result" for="a b">100</output>
</form>

<!-- Progress and meter -->
<progress value="70" max="100">70%</progress>
<meter value="0.6" min="0" max="1" low="0.3" high="0.7" optimum="1">60%</meter>
```

### Form Validation Attributes

```html
<input
  type="email"
  required                         <!-- field must be filled -->
  minlength="5"                    <!-- minimum character count -->
  maxlength="100"                  <!-- maximum character count -->
  min="0"                          <!-- min value (number/date) -->
  max="100"                        <!-- max value (number/date) -->
  step="0.01"                      <!-- increment step -->
  pattern="[a-z]{3,}"             <!-- regex pattern -->
  title="Lowercase letters only"   <!-- validation message hint -->
  autocomplete="email"             <!-- browser autocomplete -->
  autofocus                        <!-- focus on page load -->
  readonly                         <!-- can't edit, is submitted -->
  disabled                         <!-- can't edit, not submitted -->
  spellcheck="true"               <!-- spell check -->
>
```

---

## Meta Tags

```html
<!-- Essential -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="160 chars max page description">
<meta name="keywords" content="html, css, web development">
<meta name="author" content="Jane Doe">

<!-- Robots -->
<meta name="robots" content="index, follow">
<meta name="robots" content="noindex, nofollow">
<meta name="googlebot" content="noindex">

<!-- Refresh/Redirect -->
<meta http-equiv="refresh" content="5;url=https://example.com">

<!-- Theme color (mobile) -->
<meta name="theme-color" content="#3498db">
<meta name="theme-color" content="#1a1a2e" media="(prefers-color-scheme: dark)">

<!-- Color scheme -->
<meta name="color-scheme" content="light dark">

<!-- HTTP headers via meta -->
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Content-Security-Policy" content="default-src 'self'">
<meta http-equiv="Cache-Control" content="no-cache">
```

---

## Data Attributes

```html
<!-- Define data attributes -->
<div
  data-id="42"
  data-user-role="admin"
  data-config='{"theme":"dark","lang":"en"}'
>
  Content
</div>

<!-- Access in JavaScript -->
<script>
  const el = document.querySelector('[data-id]');
  const id = el.dataset.id;          // "42"
  const role = el.dataset.userRole;  // "admin" (camelCase)
  const config = JSON.parse(el.dataset.config);

  // Set data attribute
  el.dataset.status = 'active';      // adds data-status="active"
</script>

<!-- Use in CSS -->
<style>
  [data-theme="dark"] { background: #1a1a2e; }
  [data-status="active"]::after { content: " ✓"; }
</style>
```

---

## ARIA Attributes

### Roles

```html
<!-- Landmark roles -->
<div role="banner">       <!-- header -->
<div role="navigation">  <!-- nav -->
<div role="main">        <!-- main content -->
<div role="complementary"> <!-- aside -->
<div role="contentinfo"> <!-- footer -->
<div role="search">      <!-- search region -->
<div role="region" aria-labelledby="section-title"> <!-- labeled region -->

<!-- Widget roles -->
<div role="button" tabindex="0">Click me</div>
<div role="checkbox" aria-checked="true">Option</div>
<div role="dialog" aria-modal="true" aria-labelledby="dialog-title">
<div role="alert">Error: Please fix the form</div>
<div role="status">Loading complete</div>
<div role="tab">Tab label</div>
<div role="tabpanel">Tab content</div>
<div role="tooltip" id="tip">Helpful tooltip</div>
<div role="progressbar" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100">
```

### States & Properties

```html
<!-- Labels -->
<button aria-label="Close dialog">✕</button>
<nav aria-labelledby="nav-heading">
  <h2 id="nav-heading">Main Navigation</h2>
</nav>
<input aria-describedby="email-help">
<p id="email-help">We'll never share your email.</p>

<!-- Hidden from screen readers -->
<span aria-hidden="true">★</span>

<!-- Live regions -->
<div aria-live="polite">Status message</div>     <!-- announces after user idle -->
<div aria-live="assertive">Urgent message</div>  <!-- announces immediately -->
<div aria-live="off">No announcement</div>

<!-- Expanded/collapsed -->
<button aria-expanded="false" aria-controls="menu">Menu</button>
<ul id="menu" hidden>...</ul>

<!-- Current page/state -->
<a href="/" aria-current="page">Home</a>
<li aria-current="step">Step 2</li>

<!-- Required / invalid -->
<input aria-required="true">
<input aria-invalid="true" aria-errormessage="email-error">
<p id="email-error" role="alert">Invalid email format</p>

<!-- Selected / checked -->
<option aria-selected="true">Option 1</option>
<div role="checkbox" aria-checked="true">Check me</div>

<!-- Disabled -->
<button aria-disabled="true">Can't click</button>

<!-- Pressed (toggle button) -->
<button aria-pressed="false">Mute</button>
```

---

## Canvas

```html
<canvas id="myCanvas" width="400" height="300">
  Fallback text for non-canvas browsers.
</canvas>

<script>
  const canvas = document.getElementById('myCanvas');
  const ctx = canvas.getContext('2d');

  // Rectangle
  ctx.fillStyle = '#3498db';
  ctx.fillRect(10, 10, 150, 100);
  ctx.strokeStyle = '#2980b9';
  ctx.strokeRect(10, 10, 150, 100);
  ctx.clearRect(20, 20, 50, 50);   // erase area

  // Path
  ctx.beginPath();
  ctx.moveTo(200, 50);
  ctx.lineTo(300, 200);
  ctx.lineTo(100, 200);
  ctx.closePath();
  ctx.fill();
  ctx.stroke();

  // Circle
  ctx.beginPath();
  ctx.arc(200, 150, 50, 0, Math.PI * 2);
  ctx.fillStyle = 'red';
  ctx.fill();

  // Text
  ctx.font = '24px Arial';
  ctx.fillStyle = '#333';
  ctx.fillText('Hello Canvas', 50, 50);

  // Image
  const img = new Image();
  img.onload = () => ctx.drawImage(img, 0, 0, 200, 150);
  img.src = '/path/to/image.png';
</script>
```

---

## SVG

```html
<!-- Inline SVG -->
<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <!-- Circle -->
  <circle cx="50" cy="50" r="40" fill="#3498db" stroke="#2980b9" stroke-width="2"/>

  <!-- Rectangle -->
  <rect x="10" y="10" width="80" height="60" rx="5" fill="#2ecc71"/>

  <!-- Line -->
  <line x1="0" y1="0" x2="100" y2="100" stroke="black" stroke-width="2"/>

  <!-- Path (d attribute) -->
  <path d="M 10 80 C 40 10, 65 10, 95 80 S 150 150, 180 80" fill="none" stroke="red"/>

  <!-- Polygon -->
  <polygon points="50,10 90,90 10,90" fill="orange"/>

  <!-- Text -->
  <text x="50" y="50" text-anchor="middle" font-size="14" fill="white">SVG</text>

  <!-- Group -->
  <g transform="translate(10, 10) rotate(45)">
    <circle cx="0" cy="0" r="10" fill="purple"/>
  </g>
</svg>

<!-- SVG as img -->
<img src="/icon.svg" alt="Icon description" width="24" height="24">

<!-- SVG as CSS background -->
<style>
  .icon {
    background-image: url("data:image/svg+xml,%3Csvg...%3E");
  }
</style>
```

---

## Multimedia

```html
<!-- Video -->
<video
  controls
  width="640"
  height="360"
  poster="/thumbnail.jpg"
  autoplay
  muted
  loop
  preload="metadata"
>
  <source src="/video.webm" type="video/webm">
  <source src="/video.mp4" type="video/mp4">
  <track kind="subtitles" src="/captions.vtt" srclang="en" label="English" default>
  Your browser does not support video.
</video>

<!-- Audio -->
<audio controls preload="metadata">
  <source src="/audio.ogg" type="audio/ogg">
  <source src="/audio.mp3" type="audio/mpeg">
  Your browser does not support audio.
</audio>

<!-- Iframe embed -->
<iframe
  src="https://www.youtube.com/embed/dQw4w9WgXcQ"
  width="560"
  height="315"
  title="YouTube video player"
  frameborder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope"
  allowfullscreen
  loading="lazy"
></iframe>
```

---

## Common Patterns

### Skip Navigation Link (Accessibility)

```html
<!-- First element in body -->
<a href="#main-content" class="skip-link">Skip to main content</a>

<!-- CSS for skip link -->
<style>
  .skip-link {
    position: absolute;
    top: -40px;
    left: 0;
    background: #000;
    color: #fff;
    padding: 8px;
    z-index: 1000;
  }
  .skip-link:focus { top: 0; }
</style>
```

### Card Component

```html
<article class="card">
  <img src="/card-image.jpg" alt="Card image description" loading="lazy">
  <div class="card-body">
    <h3 class="card-title"><a href="/post/slug">Article Title</a></h3>
    <p class="card-excerpt">Brief description of the content...</p>
    <footer class="card-meta">
      <time datetime="2026-05-28">May 28, 2026</time>
      <span class="tag">CSS</span>
    </footer>
  </div>
</article>
```

### Breadcrumbs (ARIA)

```html
<nav aria-label="Breadcrumb">
  <ol>
    <li><a href="/">Home</a></li>
    <li><a href="/blog">Blog</a></li>
    <li aria-current="page">CSS Grid Guide</li>
  </ol>
</nav>
```

### Notification Banner

```html
<div role="alert" aria-live="assertive" class="notification notification--error">
  <svg aria-hidden="true"><!-- error icon --></svg>
  <p>Something went wrong. Please try again.</p>
  <button type="button" aria-label="Dismiss notification">✕</button>
</div>
```

### Loading Spinner

```html
<div role="status" aria-label="Loading">
  <div class="spinner" aria-hidden="true"></div>
  <span class="sr-only">Loading...</span>
</div>
```

---

## Accessibility Tips

- Always include `alt` text for images (`alt=""` for decorative images)
- Use semantic elements (`<button>` not `<div onclick>`)
- Ensure heading hierarchy is logical (h1 → h2 → h3)
- Every form input needs a `<label>` associated via `for`/`id`
- Use `tabindex="0"` to make non-interactive elements focusable
- Never use `tabindex` values > 0 (breaks natural tab order)
- Color alone should never convey meaning
- Ensure interactive elements are at least 44×44 CSS pixels
- Test with keyboard navigation only
- Use `aria-live` regions for dynamically updated content
- Use `<button>` for actions, `<a>` for navigation
- Provide text alternatives for audio/video content (transcripts, captions)

---

## Tips & Tricks

- Use `loading="lazy"` on all below-the-fold images for performance
- `<link rel="preconnect">` speeds up third-party font loading
- `defer` attribute on scripts prevents render blocking
- Use `<template>` element for client-side HTML templates
- `<dialog>` has built-in accessibility (focus trap, Escape key)
- `<details>`/`<summary>` gives you a free accordion with no JS
- `autocomplete` on inputs improves form UX dramatically
- `inputmode` hints mobile keyboard type without changing input type
- Use `fetchpriority="high"` on the LCP image for Core Web Vitals
- `<meta name="theme-color">` changes mobile browser chrome color
- Validate HTML at validator.w3.org to catch structural issues

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
