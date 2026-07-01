# vim

Stow package for `~/.vimrc` and `~/.vim/`. Vim 8+ with vim-plug managing
the plugin set.

## Table of contents

- [Plugins](#plugins)
  - [Editing essentials (tpope stack)](#editing-essentials-tpope-stack)
  - [UI](#ui)
  - [Fuzzy finder](#fuzzy-finder)
  - [Editor integrations](#editor-integrations)
  - [Linting](#linting)
  - [Languages](#languages)
  - [Colors](#colors)
- [Leader-key cheat sheet](#leader-key-cheat-sheet)
- [Other mappings](#other-mappings)
- [Non-default settings](#non-default-settings)
- [Window/pane navigation across vim and tmux](#windowpane-navigation-across-vim-and-tmux)
- [Ripgrep integration](#ripgrep-integration)
- [Go workflow](#go-workflow)
- [Runtime directories](#runtime-directories)
- [Fresh-machine setup](#fresh-machine-setup)

Leader is `,` (`let mapleader=','`).

## Plugins

Managed by [vim-plug](https://github.com/junegunn/vim-plug). Install/update
with `:PlugInstall` / `:PlugUpdate`. Clean orphans with `:PlugClean!`.

### Editing essentials (tpope stack)

| Plugin              | Use                                                                                                                              |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `vim-commentary`    | `gcc` toggles a line, `gc{motion}` toggles a range                                                                               |
| `vim-surround`      | `cs'"` → change `'foo'` to `"foo"`; `ys{motion}{char}`; `ds{char}`                                                               |
| `vim-repeat`        | makes the above two `.`-repeatable                                                                                               |
| `vim-sleuth`        | auto-detect indent settings from the file                                                                                        |
| `vim-fugitive`      | `:Git`, `:Gdiffsplit`, `:Gblame`, `:Git log`                                                                                     |
| `vim-dispatch`      | async build/test runner                                                                                                          |
| `vim-projectionist` | project-aware `:A`-style file switching                                                                                          |
| `vim-unimpaired`    | bracket-pair mappings: `]q`/`[q` quickfix, `]b`/`[b` buffers, `]c`/`[c` (shared with gitgutter), `]<Space>` add blank line, etc. |
| `vim-eunuch`        | shell-command Ex wrappers: `:Rename`, `:Move`, `:Delete`, `:SudoWrite`, `:Chmod`                                                 |

### UI

| Plugin               | Use                                                          |
| -------------------- | ------------------------------------------------------------ |
| `vim-airline`        | statusline with mode/branch/lint                             |
| `bufexplorer`        | `<leader>be/bt/bs/bv` — list/toggle/split buffers            |
| `preservim/nerdtree` | `<leader>nt` toggle, `<leader>nf` reveal current file        |
| `tagbar`             | `<leader>tt` outline of symbols (needs ctags)                |
| `undotree`           | `<leader>u` visualize undo branches (paired with `undofile`) |

### Fuzzy finder

| Plugin                              | Use                                                 |
| ----------------------------------- | --------------------------------------------------- |
| `junegunn/fzf` + `junegunn/fzf.vim` | `:Files`, `:Rg`, `:Buffers`, `:GFiles?`, `:History` |

### Editor integrations

| Plugin               | Use                                                                    |
| -------------------- | ---------------------------------------------------------------------- |
| `editorconfig-vim`   | honor `.editorconfig` files                                            |
| `vim-tmux-navigator` | `<C-h/j/k/l>` jumps across vim splits *and* tmux panes                 |
| `vim-gitgutter`      | gutter diff markers; `]c`/`[c` next/prev hunk                          |
| `splitjoin.vim`      | `gS`/`gJ` split/join one-liners ↔ blocks                               |
| `auto-pairs`         | auto-close brackets/quotes                                             |
| `ultisnips`          | snippet engine                                                         |
| `vim-snippets`       | the snippet library `ultisnips` expands (engine ships none on its own) |

### Linting

| Plugin               | Use                                                                  |
| -------------------- | -------------------------------------------------------------------- |
| `dense-analysis/ale` | async linting (pylint, shellcheck, yamllint). Go is owned by vim-go. |

### Languages

| Plugin               | Use                                                   |
| -------------------- | ----------------------------------------------------- |
| `fatih/vim-go`       | Go IDE-ish features. See [Go workflow](#go-workflow). |
| `rust-lang/rust.vim` | Rust filetype + rustfmt                               |

### Colors

`dracula` is the scheme for all filetypes, including Go.

## Leader-key cheat sheet

(Leader = `,`)

| Keys                  | Action                                          |
| --------------------- | ----------------------------------------------- |
| `,<space>`            | clear search highlight                          |
| `,,`                  | switch to last file                             |
| `,ev` / `,sv`         | edit / source `$MYVIMRC`                        |
| `,ln` / `,nw` / `,rn` | toggle number / wrap / relativenumber           |
| `,sc`                 | toggle spell check                              |
| `,tn` / `,tc`         | new / close tab                                 |
| `,bd` / `,bda`        | close current buffer / close all buffers        |
| `,dc` / `,do`         | close diff / `:DiffOrig` (diff against unsaved) |
| `,rt`                 | retab                                           |
| `,url`                | open URL under cursor (OS default browser)      |
| `,gg`                 | toggle gitgutter line highlights                |
| `,tt`                 | toggle tagbar                                   |
| `,nt` / `,nf`         | toggle / reveal NERDTree                        |
| `,u`                  | toggle undotree                                 |
| `,f` / `<C-p>`        | fzf `:Files`                                    |
| `,b`                  | fzf `:Buffers`                                  |
| `,a`                  | fzf `:Rg` (prompt for pattern)                  |
| `,*`                  | fzf `:Rg` word under cursor                     |
| `,h`                  | fzf `:History`                                  |
| `,q`                  | close quickfix                                  |
| `<C-n>` / `<C-m>`     | `:cnext` / `:cprevious`                         |

## Other mappings

Non-leader bindings worth knowing:

| Keys                                | Action                                                                    |
| ----------------------------------- | ------------------------------------------------------------------------- |
| `jj` (insert)                       | `<Esc>` — escape without leaving home row                                 |
| `<Down>` / `<Up>` (insert)          | move by visual line (`gj`/`gk`), so wrapped lines work intuitively        |
| `j` / `k` (normal)                  | move by visual line (`gj`/`gk`)                                           |
| `<M-j>` / `<M-k>` (normal + visual) | move the current line / selection down / up                               |
| `<` / `>` (visual)                  | indent left / right and keep the selection (`gv` re-select)               |
| `<tab>` (normal + visual)           | jump to matching bracket (rebinds `%`)                                    |
| `n` / `N` / `*` / `#`               | re-center the screen on the match (`Nzz`)                                 |
| `/`                                 | starts a "very magic" search (`/\v` — most punctuation is regex metachar) |
| `Q`                                 | `gq` — reformat with motion (the default `Q` ex mode is rarely useful)    |

Custom Ex commands:

| Command             | Action                                                                        |
| ------------------- | ----------------------------------------------------------------------------- |
| `:W` / `:SudoWrite` | sudo-save the current buffer (`:W` is an alias for vim-eunuch's `:SudoWrite`) |
| `:DiffOrig`         | vertical diff between the buffer and the on-disk file (`,do` triggers it)     |

## Non-default settings

| Setting                                       | Reason                                                                |
| --------------------------------------------- | --------------------------------------------------------------------- |
| `hidden`                                      | allow buffer switching with unsaved changes                           |
| `clipboard=unnamed,unnamedplus`               | system clipboard on Mac (`unnamed`) and Linux (`unnamedplus`)         |
| `termguicolors`                               | true color; pairs with tmux `terminal-overrides ",xterm-256color:Tc"` |
| `splitbelow`, `splitright`                    | new splits open in more intuitive positions                           |
| `completeopt=menu,menuone,noselect`           | dropdown without auto-selecting first match                           |
| `mouse=a`                                     | mouse on                                                              |
| `undofile`, `undolevels=500`                  | persistent undo across sessions                                       |
| `backup`, `backupdir=~/.vim/backup`           | keep backup files in a known place                                    |
| `directory=~/.vim/tmp`, `undodir=~/.vim/undo` | move swap/undo out of the working dir                                 |
| `colorcolumn="80," + range(120,999)`          | line marker at 80, solid color from 120+                              |
| `textwidth=200`                               | global default; overridden to 80 for `FileType text`                  |
| `ignorecase` + `smartcase`                    | case-insensitive unless query has uppercase                           |
| `tags=tags;/`                                 | walk up looking for ctags `tags` file                                 |

Trailing whitespace is highlighted in red and stripped on save for
`*.go`/`*.py`/`*.sh`. The motion/search rebindings that pair with
these settings (visual-line `j`/`k`, recentering `n`/`*`, `<tab>` for
bracket matching) are listed under [Other mappings](#other-mappings).

## Window/pane navigation across vim and tmux

`<C-h/j/k/l>` is bound in both. With `vim-tmux-navigator` and tmux's
matching keybindings, hitting `<C-l>` from a rightmost vim split jumps
into the tmux pane to the right. Same in reverse.

## Ripgrep integration

- `:Rg foo` — interactive fzf picker over rg results (from `fzf.vim`).

- `,*` — `:Rg` for the word under the cursor.

- `:grep foo` — batch search; populates the quickfix list. Uses rg via:

  ```vim
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
  ```

- For "live rg + fzf, open at line in editor" from outside vim, see the
  `frg` function in `fzf/README.md`.

## Go workflow

`vim-go` is configured with:

- `g:go_fmt_command="goimports"` — format + organize imports on save
- `g:go_metalinter_autosave=1` — run linter on save
- `g:go_auto_sameids=1`, `g:go_auto_type_info=1` — highlight same identifiers, show types
- Many `g:go_highlight_*=1` flags for richer syntax

Go-specific leader maps (active only in `.go` files):

| Keys              | Action                                           |
| ----------------- | ------------------------------------------------ |
| `,b`              | `:GoBuild` or `:GoTestCompile` based on filename |
| `,c`              | toggle coverage                                  |
| `,t`              | test                                             |
| `,r`              | run                                              |
| `,e`              | rename (gopls)                                   |
| `,i`              | info under cursor                                |
| `,s`              | implements                                       |
| `,ds`/`,dt`/`,dv` | def in split/tab/vsplit                          |
| `,gd`/`,gv`/`,gb` | doc / doc-vertical / doc-browser                 |
| `,gl`             | metalinter                                       |
| `,ga`             | `:GoAlternate` (jump between code and test file) |

## Runtime directories

The repo includes empty `.gitignore` files in these dirs to keep them
present in stow targets without committing the runtime data:

| Dir              | What goes there                          |
| ---------------- | ---------------------------------------- |
| `~/.vim/backup`  | `*~` backup files (gitignored repo-wide) |
| `~/.vim/tmp`     | swap files                               |
| `~/.vim/undo`    | persistent undo blobs                    |
| `~/.vim/plugged` | vim-plug-managed plugins (not in repo)   |

## Fresh-machine setup

```sh
stow vim                    # symlinks ~/.vimrc and ~/.vim/
vim +"PlugInstall --sync" +qall
```

For headless (CI/script) install, vim-plug needs a real pty — run inside
a temporary tmux session (see `CLAUDE.md` at the repo root).
