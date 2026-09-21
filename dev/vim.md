# Vim Cheatsheet

> Highly configurable terminal text editor. Modal, efficient, everywhere.
> Last verified: May 2026 | Version: Vim 9.1 / Neovim 0.10

---

## Quick Reference

| Command | Description |
|---|---|
| `i` | Enter Insert mode |
| `Esc` | Return to Normal mode |
| `:w` | Save file |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `h j k l` | Move left/down/up/right |
| `dd` | Delete (cut) line |
| `yy` | Yank (copy) line |
| `p` | Paste after cursor |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `/pattern` | Search forward |
| `n` | Next search match |
| `:%s/old/new/g` | Replace all in file |
| `gg` | Go to first line |
| `G` | Go to last line |
| `v` | Visual mode (character) |
| `V` | Visual line mode |
| `Ctrl+v` | Visual block mode |
| `.` | Repeat last change |

---

## The Famous Exit Commands

```vim
" The four horsemen of vim exit
:q          " Quit (fails if unsaved changes)
:q!         " Force quit (discard changes)
:wq         " Write and quit
:x          " Write and quit (only writes if changed)

" Other ways out
ZZ          " Normal mode: write and quit (same as :x)
ZQ          " Normal mode: quit without saving (same as :q!)
:qa         " Quit all windows
:qa!        " Force quit all windows

" The help
:help       " You don't have to be afraid anymore
```

---

## Modes

| Mode | Enter | Description |
|---|---|---|
| Normal | `Esc` | Default mode — navigation and commands |
| Insert | `i`, `a`, `o`, etc. | Type text |
| Visual | `v`, `V`, `Ctrl+v` | Select text |
| Command | `:` | Ex commands |
| Replace | `R` | Overwrite text |
| Select | `gh` | Like Visual but typing replaces |

---

## Normal Mode — Navigation

### Basic Movement

```vim
h           Move left
j           Move down
k           Move up
l           Move right

" Faster movement
w           Next word (start)
W           Next WORD (whitespace-delimited)
b           Previous word (start)
B           Previous WORD
e           Next word (end)
E           Next WORD (end)
ge          Previous word (end)

" Line navigation
0           Start of line
^           First non-whitespace character
$           End of line
g_          Last non-whitespace character

" Document navigation
gg          First line
G           Last line
5G          Go to line 5
:42         Go to line 42
H           Top of screen (High)
M           Middle of screen (Middle)
L           Bottom of screen (Low)

" Screen scrolling
Ctrl+f      Page down (Forward)
Ctrl+b      Page up (Backward)
Ctrl+d      Half page down
Ctrl+u      Half page up
Ctrl+e      Scroll down one line
Ctrl+y      Scroll up one line
zz          Center screen on cursor
zt          Scroll cursor to top
zb          Scroll cursor to bottom
```

### Jumping

```vim
%           Jump to matching bracket: () [] {}
[[          Jump to previous section/function
]]          Jump to next section/function
{           Jump to previous empty line
}           Jump to next empty line
(           Beginning of sentence
)           End of sentence

" Marks
ma          Set mark 'a' at cursor position
`a          Jump to mark 'a' (exact position)
'a          Jump to mark 'a' (line start)
``          Jump to previous position
''          Jump to previous line
`.          Jump to last edit location
Ctrl+o      Jump back in jump list
Ctrl+i      Jump forward in jump list
:jumps      Show jump list
:marks      Show all marks
```

---

## Normal Mode — Editing

### Operators (combine with motions)

```vim
" Format: [operator][count][motion]
d           Delete (cut)
y           Yank (copy)
c           Change (delete and enter Insert mode)
>           Indent right
<           Indent left
=           Auto-indent
~           Toggle case (single char)
g~          Toggle case (with motion)
gu          Lowercase (with motion)
gU          Uppercase (with motion)
!           Filter through external command

" Common operator+motion combos
dw          Delete word
d$          Delete to end of line
d0          Delete to start of line
dd          Delete entire line
D           Delete to end of line (same as d$)
diw         Delete inner word (not surrounding space)
daw         Delete a word (including surrounding space)
di"         Delete inside quotes
da"         Delete quotes and content
d2w         Delete 2 words
5dd         Delete 5 lines

yy          Yank line
y$          Yank to end of line
yiw         Yank inner word
y%          Yank to matching bracket

cw          Change word (delete + insert)
ciw         Change inner word
ci"         Change inside quotes
C           Change to end of line
cc          Change entire line

>>          Indent line right
<<          Indent line left
5>>         Indent 5 lines right
```

### Insert Mode Entry

```vim
i           Insert before cursor
I           Insert at start of line
a           Append after cursor
A           Append at end of line
o           New line below, enter insert
O           New line above, enter insert
s           Delete char, enter insert
S           Delete line, enter insert (same as cc)
gi          Insert at last insert position
```

### Copy, Cut, Paste

```vim
yy          Yank (copy) line
dd          Delete (cut) line
p           Paste after cursor/line
P           Paste before cursor/line

" Registers
"ayy        Yank line into register 'a'
"ap         Paste from register 'a'
"+yy        Yank line into system clipboard
"+p         Paste from system clipboard
"0p         Paste last yank (not last delete)
:reg        Show all register contents
```

### Undo & Redo

```vim
u           Undo last change
U           Undo all changes on current line
Ctrl+r      Redo
:earlier 5m Go to state 5 minutes ago
:later 5m   Go to state 5 minutes ahead
```

---

## Search & Replace

### Searching

```vim
/pattern        Search forward
?pattern        Search backward
n               Next match (same direction)
N               Previous match (opposite direction)
*               Search word under cursor (forward)
#               Search word under cursor (backward)
g*              Search partial word under cursor
:noh            Clear search highlighting

" Search options
/pattern\c      Case-insensitive
/pattern\C      Case-sensitive
/\<word\>       Whole word only
/pat1\|pat2     Search pat1 OR pat2

" Very magic mode (ERE-like)
/\v(foo|bar)+   Very magic — fewer escapes needed
```

### Substitution

```vim
:s/old/new/         Replace first on current line
:s/old/new/g        Replace all on current line
:%s/old/new/g       Replace all in file
:%s/old/new/gc      Replace all with confirmation
:5,10s/old/new/g    Replace on lines 5-10
:'<,'>s/old/new/g   Replace in visual selection

" Flags
g   All occurrences on line
c   Confirm each substitution
i   Case insensitive
I   Case sensitive
n   Count matches (no replacement)
e   Don't error if no match

" Backreferences in replacement
:%s/\(foo\)\(bar\)/\2\1/g    Swap foo and bar (BRE)
:%s/\v(foo)(bar)/\2\1/g      Same with very magic

" Special replacement sequences
\n  Newline
\u  Uppercase next char
\l  Lowercase next char
\U  Uppercase all following
\L  Lowercase all following
\E  End \U or \L
&   Whole match
\0  Whole match (alternative)
```

---

## Visual Mode

```vim
v           Character visual mode
V           Line visual mode
Ctrl+v      Block visual mode
gv          Reselect last visual selection
o           Move to other end of selection
O           Move to other corner (block mode)

" Operations on selection
d           Delete selection
y           Yank selection
c           Change selection
>           Indent right
<           Indent left
~           Toggle case
u           Lowercase
U           Uppercase
:           Enter command for selection range

" Block mode tricks
Ctrl+v      Select column
I           Insert before all selected lines
A           Append after all selected lines
```

---

## Marks & Jumps

```vim
ma          Set local mark 'a' (a-z, per file)
mA          Set global mark 'A' (A-Z, cross-file)
`a          Jump to mark (exact position)
'a          Jump to mark (line start)
:marks      List all marks
:delmarks a Delete mark 'a'
:delmarks!  Delete all marks
```

---

## Macros & Registers

```vim
qa          Start recording macro into register 'a'
q           Stop recording
@a          Play macro 'a'
@@          Replay last macro
10@a        Play macro 'a' 10 times

" View macro
:reg a

" Edit macro
"ap         Paste macro to buffer
" (edit it)
"ayy        Yank back into register
```

---

## Windows, Tabs & Splits

```vim
" Splits
:sp file        Horizontal split (open file)
:vsp file       Vertical split (open file)
Ctrl+w s        Horizontal split (current file)
Ctrl+w v        Vertical split (current file)
Ctrl+w w        Cycle between windows
Ctrl+w h/j/k/l  Navigate windows (left/down/up/right)
Ctrl+w H/J/K/L  Move window (swap position)
Ctrl+w +/-      Increase/decrease height
Ctrl+w >/<      Increase/decrease width
Ctrl+w =        Equalize window sizes
Ctrl+w c        Close current window
Ctrl+w o        Keep only current window (close others)
:only           Same as Ctrl+w o

" Tabs
:tabnew         Open new tab
:tabnew file    Open file in new tab
gt              Next tab
gT              Previous tab
2gt             Go to tab 2
:tabclose       Close current tab
:tabonly        Keep only current tab
:tabs           List all tabs
```

---

## File Operations & Ex Commands

```vim
:e file         Open/edit a file
:e!             Reload current file (discard changes)
:w              Write (save)
:w file         Write to different file
:w !sudo tee %  Save with sudo (if forgot to sudo vim)
:r file         Read file into buffer
:r !command     Insert command output into buffer
:q              Quit
:qa             Quit all
:wq / :x / ZZ  Write and quit

" Buffer management
:ls             List all buffers
:b2             Switch to buffer 2
:bn             Next buffer
:bp             Previous buffer
:bd             Delete (close) buffer
:badd file      Add file to buffer list

" Path shortcuts in commands
%               Current file name
%%              Current file's directory (some configs)
#               Alternate (previous) file name
```

---

## .vimrc Essentials

```vim
" ~/.vimrc (or ~/.config/nvim/init.vim for Neovim)

" Enable syntax highlighting
syntax on

" Line numbers
set number
set relativenumber

" Tabs and indentation
set tabstop=4
set shiftwidth=4
set expandtab           " Use spaces instead of tabs
set smartindent
set autoindent

" Search
set hlsearch            " Highlight search results
set incsearch           " Incremental search
set ignorecase          " Case insensitive search...
set smartcase           " ...unless uppercase is used

" Performance & UI
set scrolloff=8         " Keep 8 lines above/below cursor
set sidescrolloff=8
set signcolumn=yes
set cursorline
set colorcolumn=80      " Visual ruler at 80 chars
set wrap                " Wrap long lines
set linebreak           " Break at word boundaries
set showmatch           " Show matching brackets
set wildmenu            " Better command completion
set laststatus=2        " Always show status bar

" Files
set noswapfile
set nobackup
set undofile            " Persistent undo
set undodir=~/.vim/undo

" Clipboard
set clipboard=unnamedplus   " Use system clipboard

" Leader key
let mapleader = " "     " Space as leader

" Common mappings
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <Esc> :noh<CR>   " Clear search highlight
nnoremap Y y$             " Make Y consistent with D and C

" Quick edit vimrc
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
```

---

## Plugins Overview (vim-plug)

```vim
" Install vim-plug first, then in .vimrc:
call plug#begin()

Plug 'preservim/nerdtree'          " File tree
Plug 'junegunn/fzf.vim'            " Fuzzy finder
Plug 'tpope/vim-fugitive'          " Git integration
Plug 'tpope/vim-surround'          " Surround text objects
Plug 'tpope/vim-commentary'        " Comment/uncomment
Plug 'airblade/vim-gitgutter'      " Git diff in gutter
Plug 'vim-airline/vim-airline'     " Status line
Plug 'neoclide/coc.nvim'          " LSP/Autocomplete
Plug 'dense-analysis/ale'          " Async linting
Plug 'morhetz/gruvbox'             " Color scheme

call plug#end()

" Install: :PlugInstall
" Update:  :PlugUpdate
" Clean:   :PlugClean
```

---

## Tips & Tricks

- Use `.` to repeat the last change — it's incredibly powerful for repetitive edits.
- `ci"` (change inside quotes) is one of the most useful text objects — learn `i` and `a` motions.
- `*` searches for the word under cursor without typing — then `cgn` changes next match.
- Use `:g/pattern/d` to delete all lines matching a pattern.
- `:v/pattern/d` deletes all lines NOT matching a pattern (the opposite of `:g`).
- Record a macro with `qq`, then `q`, then apply with `@q`. Use `@@` to repeat.
- `Ctrl+a` / `Ctrl+x` in Normal mode increments/decrements numbers under cursor.
- `gf` opens the file under the cursor — great for navigating imports.
- `viw` selects a word regardless of cursor position within it.
- `:%!python3 -m json.tool` formats the entire buffer as JSON.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
