# nvim

Stow package for `~/.config/nvim/`. A from-scratch Lua config
([lazy.nvim](https://github.com/folke/lazy.nvim) + native LSP + Treesitter),
not a port of `~/.vimrc`. The older `vim/` package stays as-is and remains the
default `$EDITOR`; this exists to migrate to Neovim incrementally without
losing the muscle memory baked into the Vim config.

## Table of contents

- [Layout](#layout)
- [Plugin map (Vim → Neovim)](#plugin-map-vim--neovim)
- [What Neovim made redundant](#what-neovim-made-redundant)
- [LSP, completion, linting](#lsp-completion-linting)
- [Leader-key cheat sheet](#leader-key-cheat-sheet)
- [Text objects (Treesitter)](#text-objects-treesitter)
- [Go workflow](#go-workflow)
- [Settings that differ from the .vimrc](#settings-that-differ-from-the-vimrc)
- [Runtime directories](#runtime-directories)
- [Fresh-machine setup](#fresh-machine-setup)

Leader is `,` (`vim.g.mapleader = ','`), set in `init.lua` before any plugin
loads.

## Layout

```
nvim/.config/nvim/
├── init.lua                 entry: leader, then require the config modules
└── lua/
    ├── config/
    │   ├── lazy.lua         bootstrap lazy.nvim, import lua/plugins/
    │   ├── options.lua      vim.opt settings ported from .vimrc
    │   ├── keymaps.lua      non-plugin maps (leader, visual-line j/k, …)
    │   ├── autocmds.lua     trailing-WS, cursor restore, text tw=80
    │   └── commands.lua     :W (SudoWrite alias), :DiffOrig
    └── plugins/             one spec file per concern; lazy imports them all
        ├── colorscheme.lua  dracula.nvim
        ├── editing.lua      tpope stack, autopairs, tmux-navigator
        ├── ui.lua           lualine, nvim-tree, aerial, undotree
        ├── finder.lua       fzf-lua
        ├── git.lua          fugitive, gitsigns
        ├── treesitter.lua   nvim-treesitter
        ├── completion.lua   blink.cmp + friendly-snippets
        ├── lsp.lua          mason, lspconfig, nvim-lint
        └── lang.lua         go.nvim, rust.vim
```

`init.lua` is Neovim's `$MYVIMRC`, so `,ev` / `,sv` edit / source it.

## Plugin map (Vim → Neovim)

Kept as-is — these run natively and have no better replacement:
`vim-surround`, `vim-repeat`, `vim-sleuth`, `vim-eunuch`,
`vim-projectionist`, `vim-dispatch`, `vim-fugitive`, `splitjoin.vim`,
`vim-tmux-navigator`, `undotree`, `rust.vim`.

Replaced with a Lua-native equivalent:

| Vim plugin | Neovim replacement | Notes |
|---|---|---|
| `vim-airline` | `lualine.nvim` | theme `auto` follows Dracula |
| `nerdtree` | `nvim-tree.lua` | `,nt` / `,nf` unchanged |
| `tagbar` | `aerial.nvim` | `,tt`; LSP/Treesitter-backed, no ctags |
| `fzf` + `fzf.vim` | `fzf-lua` | same `,f ,b ,a ,* ,h` maps |
| `vim-gitgutter` | `gitsigns.nvim` | `]c`/`[c` hunks, `,gg` toggle |
| `auto-pairs` | `nvim-autopairs` | integrates with blink.cmp |
| `ultisnips` + `vim-snippets` | `blink.cmp` + `friendly-snippets` | snippets via the completion menu |
| `ale` | `nvim-lint` + LSP diagnostics | pylint / shellcheck / yamllint |
| `vim-go` | `go.nvim` + `gopls` | commands + maps preserved (see below) |
| `dracula/vim` | `dracula.nvim` | Treesitter- & LSP-aware |

## What Neovim made redundant

Dropped entirely — the capability is now built in:

| Dropped | Replaced by (built-in) |
|---|---|
| `vim-commentary` | `gc` / `gcc` commenting (Neovim 0.10+) |
| `vim-unimpaired` | `]q [q`, `]b [b`, `]<Space>`, `]d [d` default maps (0.11+); `]c [c` via gitsigns |
| `editorconfig-vim` | native `.editorconfig` support (Neovim 0.9+) |
| `syntax on` + `g:go_highlight_*` | Treesitter highlighting |
| `nocompatible`, `filetype … on`, `backspace`, `incsearch`, `wildmenu`, `hidden`, `autoindent`, `ttyfast` | Neovim defaults |

## LSP, completion, linting

- **Servers** (auto-installed by `mason-lspconfig`): `gopls` (via go.nvim),
  `rust_analyzer`, `pyright`, `lua_ls`, `bashls`, `yamlls`. Enabled with the
  native `vim.lsp.enable()`; `:Mason` manages the binaries.
- **Built-in LSP maps** (Neovim defaults, on attach): `K` hover, `grr`
  references, `grn` rename, `gra` code action, `gri` implementation,
  `[d`/`]d` diagnostics. Added on top: `gd` definition, `,e` rename,
  `,ca` code action.
- **Completion**: `blink.cmp` — `<C-y>` accept, `<C-n>`/`<C-p>` select,
  `<C-space>` toggle docs. Snippets come from `friendly-snippets`.
- **Format on save**: Go uses go.nvim's `goimports`; every other server that
  advertises formatting (`rust_analyzer`, `lua_ls`) runs `vim.lsp.buf.format()`
  on `BufWritePre` (built-in, no plugin). Servers that can't format (`pyright`,
  `bashls`, `yamlls`) are simply skipped.
- **Linting**: `nvim-lint` runs the same linters ALE did — `pylint` (Python),
  `shellcheck` (sh), `yamllint` (yaml). The CLI tools must be on `PATH`.

## Leader-key cheat sheet

(Leader = `,`. Maps shared with the Vim config keep the same keys.)

| Keys | Action |
|---|---|
| `,<space>` | clear search highlight |
| `,,` | switch to last file |
| `,ev` / `,sv` | edit / source `init.lua` |
| `,ln` / `,nw` / `,rn` | toggle number / wrap / relativenumber |
| `,sc` / `,rt` | toggle spell / retab |
| `,tn` / `,tc` | new / close tab |
| `,bd` / `,bda` | delete current / all buffers |
| `,dc` / `,do` | close diff / `:DiffOrig` |
| `,url` | open URL under cursor (system browser) |
| `,u` | toggle undotree |
| `,tt` | toggle aerial symbol outline |
| `,nt` / `,nf` | toggle / reveal nvim-tree |
| `,f` / `<C-p>` | fzf-lua files |
| `,b` / `,be` | fzf-lua buffers |
| `,a` | fzf-lua live grep |
| `,*` | fzf-lua grep word under cursor |
| `,h` | fzf-lua recent files |
| `,gg` | toggle gitsigns line highlight |
| `,hs` / `,hu` / `,hp` | stage / reset / preview git hunk |
| `,q` | close quickfix |
| `]q` / `[q` | next / prev quickfix (built-in) |
| `]c` / `[c` | next / prev git hunk |

Non-leader maps carried over verbatim from the `.vimrc`: `jj`→Esc, visual-line
`j`/`k`, `<M-j>`/`<M-k>` move line/selection, `<` / `>` keep selection,
`<Tab>`→`%`, recentering `n`/`N`/`*`/`#`, very-magic `/`, `Q`→`gq`,
`<C-h/j/k/l>` window+tmux navigation. See [the vim README](vim.md) for the
rationale behind each.

## Text objects (Treesitter)

From `nvim-treesitter-textobjects` (no built-in equivalent). Use in operator-
or visual-pending position, e.g. `daf` deletes a whole function, `vif` selects
its body, `cia` changes an argument:

| Key | Selects / moves to |
|---|---|
| `af` / `if` | a function / inside a function |
| `ac` / `ic` | a class / inside a class |
| `aa` / `ia` | a parameter / inside a parameter |
| `]m` / `[m` | next / prev function start |
| `]]` / `[[` | next / prev class start |

## Go workflow

`go.nvim` owns `gopls` and reproduces the vim-go commands. Maps active only in
`.go` buffers:

| Keys | Action |
|---|---|
| `,b` | `:GoBuild` |
| `,t` / `,r` | test / run |
| `,c` | `:GoCoverage` toggle |
| `,ga` | `:GoAlt` (code ↔ test) |
| `,gl` / `,gd` | lint / doc |
| `,i` / `,s` | hover (type/doc) / implements |
| `,ds` / `,dv` / `,dt` | definition in split / vsplit / tab |
| `,e` | rename (LSP, global map) |

go.nvim drives `gopls` (already on `$PATH` if you used vim-go — it installs to
`~/go/bin`). The extra tools it shells out to (`gotests`, `iferr`, …) come from
`:GoInstallBinaries` — run it **from inside a Go buffer**, since go.nvim only
loads for Go filetypes; `nvim "+GoInstallBinaries"` on an empty buffer fails
with "not an editor command". `goimports` runs on save.

## Settings that differ from the .vimrc

Mostly faithful; the deliberate changes:

| Change | Reason |
|---|---|
| `cindent` dropped | Treesitter handles indentation per-filetype |
| `signcolumn=yes` added | keep git/diagnostic signs from shifting text |
| runtime dirs under `~/.local/share/nvim` | Neovim's `stdpath('data')`, not `~/.vim` |
| `viminfo` → `shada` | Neovim's default shada is sensible; not overridden |
| statusline/`laststatus`/`ruler` unset | lualine owns the statusline |

Everything else — `colorcolumn` 80+120 formula, `clipboard`, `undofile`,
`textwidth=200` (80 for text), `ignorecase`+`smartcase`, `gdefault`,
trailing-whitespace highlight + strip-on-save for go/py/sh — is ported directly.

## Runtime directories

`init.lua`/`options.lua` create these on startup (Neovim won't):

| Dir | Contents |
|---|---|
| `~/.local/share/nvim/undo` | persistent undo |
| `~/.local/share/nvim/backup` | `backup` files |
| `~/.local/share/nvim/swap` | swap files |
| `~/.local/share/nvim/lazy` | lazy.nvim-managed plugins |
| `~/.local/share/nvim/mason` | LSP servers / tools |

`~/.config/nvim/lazy-lock.json` pins plugin commits — commit it after a
`:Lazy sync` so installs are reproducible.

## Fresh-machine setup

```sh
stow nvim                                   # symlinks ~/.config/nvim
nvim --headless "+Lazy! sync" +qa           # install plugins
```

Then, for the optional Go tools, open any `.go` file and run
`:GoInstallBinaries` (gopls itself is already covered if vim-go installed it).

Treesitter compiles parsers on first run (needs a C compiler — clang on macOS,
`build-essential` on Debian). `:checkhealth` flags anything missing.
