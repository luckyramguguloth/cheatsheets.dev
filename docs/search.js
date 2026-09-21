/**
 * search.js – cheatsheets.dev
 * Vanilla JS: real-time search, keyboard nav, URL state, category filter, and interactive markdown viewer
 */

(function () {
  'use strict';

  /* ── State ── */
  const state = {
    query: '',
    category: 'all',
    activeSheet: null, // format: { name, category, file }
    kbIndex: -1,
    debounceTimer: null,
  };

  /* ── DOM refs (populated on DOMContentLoaded) ── */
  let searchInput, searchClear, searchCount;
  let tabBtns, cards, grid, emptyState;
  let viewer, viewerOverlay, viewerClose, viewerBody, viewerCategory, viewerFilename;

  /* ── Helpers ── */

  /**
   * Escape special regex chars in a user-typed string.
   */
  function escapeRegex(str) {
    return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  /**
   * Wrap matching text with <mark> tags, returns safe HTML string.
   */
  function highlight(text, query) {
    if (!query) return escapeHtml(text);
    const escaped = escapeRegex(query);
    const re = new RegExp(`(${escaped})`, 'gi');
    return escapeHtml(text).replace(re, '<mark>$1</mark>');
  }

  function escapeHtml(str) {
    const div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
  }

  /**
   * Normalize text for comparison (lowercase, collapse whitespace).
   */
  function normalize(str) {
    return str.toLowerCase().replace(/[\s\-_]+/g, ' ').trim();
  }

  /* ── Core filter & render ── */
  function applyFilters() {
    const q = normalize(state.query);
    const cat = state.category;

    let visible = 0;
    let kbReset = false;

    cards.forEach((card) => {
      const name = card.dataset.name || '';
      const desc = card.dataset.desc || '';
      const cardCat = card.dataset.category || '';

      const matchCat = cat === 'all' || cardCat === cat;
      const matchQ = q === '' ||
        normalize(name).includes(q) ||
        normalize(desc).includes(q);

      const show = matchCat && matchQ;

      if (show) {
        card.classList.remove('hidden');
        // Update highlighted text
        const nameEl = card.querySelector('.card-name');
        const descEl = card.querySelector('.card-desc');
        if (nameEl) nameEl.innerHTML = highlight(name, state.query.trim());
        if (descEl) descEl.innerHTML = highlight(desc, state.query.trim());
        visible++;
      } else {
        card.classList.add('hidden');
        if (card.classList.contains('kb-focused')) {
          card.classList.remove('kb-focused');
          kbReset = true;
        }
      }
    });

    if (kbReset) state.kbIndex = -1;

    // Empty state
    if (visible === 0) {
      emptyState.classList.add('visible');
    } else {
      emptyState.classList.remove('visible');
    }

    // Count text
    if (q || cat !== 'all') {
      searchCount.textContent = `Showing ${visible} cheatsheet${visible !== 1 ? 's' : ''}`;
    } else {
      searchCount.textContent = '';
    }

    // Update tab counts
    updateTabCounts();
  }

  function updateTabCounts() {
    const q = normalize(state.query);

    tabBtns.forEach((btn) => {
      const btnCat = btn.dataset.category;
      if (btnCat === 'all') return; // handled separately

      const count = Array.from(cards).filter((card) => {
        const name = card.dataset.name || '';
        const desc = card.dataset.desc || '';
        const matchQ = q === '' ||
          normalize(name).includes(q) ||
          normalize(desc).includes(q);
        return card.dataset.category === btnCat && matchQ;
      }).length;

      const countEl = btn.querySelector('.tab-count');
      if (countEl) countEl.textContent = count;
    });

    // All tab count
    const allBtn = document.querySelector('[data-category="all"]');
    if (allBtn) {
      const q2 = normalize(state.query);
      const total = q2 === '' ? cards.length :
        Array.from(cards).filter((c) => {
          const n = c.dataset.name || '';
          const d = c.dataset.desc || '';
          return normalize(n).includes(q2) || normalize(d).includes(q2);
        }).length;
      const countEl = allBtn.querySelector('.tab-count');
      if (countEl) countEl.textContent = total;
    }
  }

  /* ── Debounce ── */
  function debounce(fn, ms) {
    return function (...args) {
      clearTimeout(state.debounceTimer);
      state.debounceTimer = setTimeout(() => fn.apply(this, args), ms);
    };
  }

  /* ── URL hash state ── */
  function pushState() {
    const params = new URLSearchParams();
    if (state.activeSheet) {
      params.set('sheet', state.activeSheet);
    } else {
      if (state.query) params.set('q', state.query);
      if (state.category !== 'all') params.set('cat', state.category);
    }
    const hash = params.toString() ? '#' + params.toString() : window.location.pathname;
    history.replaceState(null, '', hash || window.location.pathname);
  }

  function readState() {
    const hash = window.location.hash.replace('#', '');
    if (!hash) {
      if (state.activeSheet) {
        closeViewer(false);
      }
      return;
    }
    try {
      const params = new URLSearchParams(hash);
      if (params.has('sheet')) {
        const sheetName = params.get('sheet');
        if (state.activeSheet !== sheetName) {
          openSheetByName(sheetName);
        }
      } else {
        if (state.activeSheet) {
          closeViewer(false);
        }
        if (params.has('q')) {
          state.query = params.get('q');
          if (searchInput) searchInput.value = state.query;
        } else {
          state.query = '';
          if (searchInput) searchInput.value = '';
        }
        if (params.has('cat')) {
          state.category = params.get('cat');
        } else {
          state.category = 'all';
        }
      }
    } catch (_) { /* ignore */ }
  }

  /* ── Keyboard navigation ── */
  function getVisibleCards() {
    return Array.from(cards).filter((c) => !c.classList.contains('hidden'));
  }

  function moveFocus(direction) {
    const visible = getVisibleCards();
    if (!visible.length) return;

    // Remove current highlight
    if (state.kbIndex >= 0 && visible[state.kbIndex]) {
      visible[state.kbIndex].classList.remove('kb-focused');
    }

    state.kbIndex += direction;

    // Wrap
    if (state.kbIndex < 0) state.kbIndex = visible.length - 1;
    if (state.kbIndex >= visible.length) state.kbIndex = 0;

    const target = visible[state.kbIndex];
    if (target) {
      target.classList.add('kb-focused');
      target.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
    }
  }

  function activateFocused() {
    const visible = getVisibleCards();
    if (state.kbIndex >= 0 && visible[state.kbIndex]) {
      visible[state.kbIndex].click();
    }
  }

  /* ── Markdown Parser (100% Offline Vanilla JS) ── */
  function parseMarkdown(md) {
    // Basic escapes
    let html = md
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');

    // Code blocks: ```language ... ```
    const codeBlocks = [];
    html = html.replace(/```(\w*)\n([\s\S]*?)```/gm, (match, lang, code) => {
      const id = `__CODE_BLOCK_${codeBlocks.length}__`;
      codeBlocks.push({ lang, code });
      return id;
    });

    // Inline Code: `code`
    html = html.replace(/`([^`]+)`/g, '<code class="inline-code">$1</code>');

    // Headings
    html = html.replace(/^#\s+(.+)$/gm, '<h1>$1</h1>');
    html = html.replace(/^##\s+(.+)$/gm, '<h2>$1</h2>');
    html = html.replace(/^###\s+(.+)$/gm, '<h3>$1</h3>');

    // Bold & Italic
    html = html.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
    html = html.replace(/\*([^*]+)\*/g, '<em>$1</em>');

    // Unordered tasks / list items
    html = html.replace(/^\s*[-*]\s+\[x\]\s+(.+)$/gm, '<li class="task-list-item checked"><input type="checkbox" checked disabled> $1</li>');
    html = html.replace(/^\s*[-*]\s+\[ \]\s+(.+)$/gm, '<li class="task-list-item"><input type="checkbox" disabled> $1</li>');
    html = html.replace(/^\s*[-*]\s+(.+)$/gm, '<li>$1</li>');

    // Ordered list items
    html = html.replace(/^\s*\d+\.\s+(.+)$/gm, '<li>$1</li>');

    // Links
    html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank" rel="noopener">$1</a>');

    // Blockquotes
    html = html.replace(/^\s*>\s+(.+)$/gm, '<blockquote>$1</blockquote>');

    // Tables
    let lines = html.split('\n');
    let inTable = false;
    let tableRows = [];
    for (let i = 0; i < lines.length; i++) {
      let line = lines[i].trim();
      if (line.startsWith('|') && line.endsWith('|')) {
        if (line.includes('---')) {
          lines[i] = '';
          continue;
        }
        inTable = true;
        let cells = line.split('|').slice(1, -1).map(c => c.trim());
        let rowHtml = '';
        if (tableRows.length === 0) {
          rowHtml = '<tr>' + cells.map(c => `<th>${c}</th>`).join('') + '</tr>';
        } else {
          rowHtml = '<tr>' + cells.map(c => `<td>${c}</td>`).join('') + '</tr>';
        }
        tableRows.push(rowHtml);
        lines[i] = '';
      } else {
        if (inTable) {
          lines[i] = '<table>' + tableRows.join('') + '</table>' + '\n' + lines[i];
          tableRows = [];
          inTable = false;
        }
      }
    }
    html = lines.join('\n');

    // Horizontal Rules
    html = html.replace(/^---\s*$/gm, '<hr>');

    // Re-inject code blocks with COPY buttons!
    codeBlocks.forEach((block, idx) => {
      const placeholder = `__CODE_BLOCK_${idx}__`;
      const cleanCode = block.code.trim();
      const codeHtml = `
        <div class="code-block-wrapper">
          <div class="code-block-header">
            <span class="code-block-lang">${block.lang || 'text'}</span>
            <button class="code-block-copy" data-code="${encodeURIComponent(cleanCode)}">Copy</button>
          </div>
          <pre><code class="language-${block.lang}">${cleanCode}</code></pre>
        </div>
      `;
      html = html.replace(placeholder, codeHtml);
    });

    // Paragraph wrapping
    let finalLines = html.split('\n');
    for (let i = 0; i < finalLines.length; i++) {
      let line = finalLines[i].trim();
      if (line && 
          !line.startsWith('<h') && 
          !line.startsWith('<ul') && 
          !line.startsWith('<ol') && 
          !line.startsWith('<li') && 
          !line.startsWith('<bl') && 
          !line.startsWith('<ta') && 
          !line.startsWith('<tr') && 
          !line.startsWith('<td') && 
          !line.startsWith('<th') && 
          !line.startsWith('<hr') && 
          !line.startsWith('<div') && 
          !line.startsWith('</') && 
          !line.startsWith('__CODE_')) {
        finalLines[i] = `<p>${finalLines[i]}</p>`;
      }
    }
    html = finalLines.join('\n');
    html = html.replace(/<p><\/p>/g, '');

    return html;
  }

  /* ── Cheatsheet Interactive Viewer ── */

  function openSheetByName(name) {
    // Find matching card
    const card = Array.from(cards).find(c => {
      const filename = c.getAttribute('href').split('/').pop().replace('.md', '');
      return filename === name;
    });

    if (card) {
      const filePath = card.getAttribute('href');
      const category = card.dataset.category;
      const title = card.dataset.name;
      const filename = filePath.split('/').pop();

      // Set viewer meta info
      viewerCategory.textContent = category.charAt(0).toUpperCase() + category.slice(1);
      viewerCategory.className = `viewer-badge ${category}`;
      viewerFilename.textContent = filename;
      viewerBody.innerHTML = '<div style="text-align:center;padding:40px;color:var(--text-muted);">Loading cheatsheet...</div>';

      // Show viewer modal
      viewer.classList.add('visible');
      document.body.classList.add('modal-active');
      state.activeSheet = name;
      pushState();

      // Fetch cheatsheet locally
      // Adjust path for browser: index.html is in /docs, cheatsheets are in /dev, etc.
      // So href is "../dev/git.md", which resolves correctly from docs/index.html
      fetch(filePath)
        .then(response => {
          if (!response.ok) throw new Error('Network response was not ok');
          return response.text();
        })
        .then(mdText => {
          viewerBody.innerHTML = parseMarkdown(mdText);
          setupCopyButtons();
        })
        .catch(err => {
          console.error(err);
          viewerBody.innerHTML = `
            <div style="text-align:center;padding:40px;color:var(--COLOR_RED);">
              <h3>Error loading cheatsheet</h3>
              <p>Verify that you are running the site through a local web server (e.g. <code>python -m http.server</code>).</p>
            </div>
          `;
        });
    }
  }

  function closeViewer(updateHash = true) {
    viewer.classList.remove('visible');
    document.body.classList.remove('modal-active');
    state.activeSheet = null;
    if (updateHash) pushState();
  }

  function setupCopyButtons() {
    const buttons = viewerBody.querySelectorAll('.code-block-copy');
    buttons.forEach(btn => {
      btn.addEventListener('click', () => {
        const encodedCode = btn.getAttribute('data-code');
        const codeText = decodeURIComponent(encodedCode);

        navigator.clipboard.writeText(codeText)
          .then(() => {
            btn.textContent = 'Copied!';
            btn.classList.add('copied');
            setTimeout(() => {
              btn.textContent = 'Copy';
              btn.classList.remove('copied');
            }, 1500);
          })
          .catch(err => {
            console.error('Failed to copy: ', err);
            btn.textContent = 'Failed';
          });
      });
    });
  }

  /* ── Event handlers ── */
  const handleSearch = debounce(function (e) {
    state.query = e.target.value;
    state.kbIndex = -1;

    // Show/hide clear button
    if (state.query.length > 0) {
      searchClear.classList.add('visible');
    } else {
      searchClear.classList.remove('visible');
    }

    pushState();
    applyFilters();
  }, 150);

  function handleClear() {
    state.query = '';
    searchInput.value = '';
    searchInput.focus();
    searchClear.classList.remove('visible');
    state.kbIndex = -1;
    pushState();
    applyFilters();
  }

  function handleTabClick(e) {
    const btn = e.currentTarget;
    const cat = btn.dataset.category;
    if (!cat) return;

    state.category = cat;
    state.kbIndex = -1;

    // Update tab active state
    tabBtns.forEach((b) => b.classList.remove('active'));
    btn.classList.add('active');

    pushState();
    applyFilters();
  }

  function handleKeydown(e) {
    const viewerActive = viewer && viewer.classList.contains('visible');
    if (viewerActive) {
      if (e.key === 'Escape') {
        e.preventDefault();
        closeViewer();
      }
      return;
    }

    const searchFocused = document.activeElement === searchInput;

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      moveFocus(1);
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      moveFocus(-1);
    } else if (e.key === 'Enter' && state.kbIndex >= 0) {
      e.preventDefault();
      activateFocused();
    } else if (e.key === 'Escape') {
      if (state.query) {
        handleClear();
      } else {
        searchInput.blur();
        getVisibleCards().forEach((c) => c.classList.remove('kb-focused'));
        state.kbIndex = -1;
      }
    } else if (e.key === '/' && !searchFocused &&
               !['INPUT','TEXTAREA','SELECT'].includes(document.activeElement.tagName)) {
      e.preventDefault();
      searchInput.focus();
      searchInput.select();
    }
  }

  /* ── Init ── */
  function init() {
    searchInput     = document.getElementById('search-input');
    searchClear     = document.getElementById('search-clear');
    searchCount     = document.getElementById('search-count');
    grid            = document.getElementById('cards-grid');
    emptyState      = document.getElementById('empty-state');
    tabBtns         = document.querySelectorAll('.tab-btn');
    cards           = document.querySelectorAll('.card[data-name]');

    // Viewer refs
    viewer          = document.getElementById('cheatsheet-viewer');
    viewerOverlay   = document.getElementById('viewer-overlay');
    viewerClose     = document.getElementById('viewer-close');
    viewerBody      = document.getElementById('viewer-body');
    viewerCategory  = document.getElementById('viewer-category');
    viewerFilename  = document.getElementById('viewer-filename');

    if (!searchInput || !grid) return; // guard

    // Restore state from URL hash
    readState();

    // Set active tab from state
    tabBtns.forEach((btn) => {
      btn.classList.toggle('active', btn.dataset.category === state.category);
    });

    // Restore search input value
    if (state.query) {
      searchInput.value = state.query;
      searchClear.classList.add('visible');
    }

    // Apply initial filter
    applyFilters();

    /* ── Bind events ── */
    searchInput.addEventListener('input', handleSearch);
    searchInput.addEventListener('keydown', handleKeydown);
    searchClear.addEventListener('click', handleClear);
    document.addEventListener('keydown', handleKeydown);

    tabBtns.forEach((btn) => {
      btn.addEventListener('click', handleTabClick);
    });

    // Bind card click event listeners for viewer modal
    cards.forEach((card) => {
      card.addEventListener('click', (e) => {
        e.preventDefault();
        const filename = card.getAttribute('href').split('/').pop().replace('.md', '');
        openSheetByName(filename);
      });
    });

    // Viewer modal close events
    if (viewerClose) {
      viewerClose.addEventListener('click', () => closeViewer());
    }
    if (viewerOverlay) {
      viewerOverlay.addEventListener('click', () => closeViewer());
    }

    // Re-read state on hash change (back/forward)
    window.addEventListener('hashchange', () => {
      readState();
      if (searchInput) searchInput.value = state.query;
      if (state.query) {
        searchClear.classList.add('visible');
      } else {
        searchClear.classList.remove('visible');
      }
      tabBtns.forEach((b) => {
        b.classList.toggle('active', b.dataset.category === state.category);
      });
      applyFilters();
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
