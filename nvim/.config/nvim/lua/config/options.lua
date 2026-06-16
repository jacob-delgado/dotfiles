-- Ported from vim/.vimrc. Settings that Neovim already enables by default are
-- intentionally dropped: nocompatible, filetype/syntax on, backspace,
-- incsearch, wildmenu, hidden, autoindent, encoding=utf-8, history, ttyfast.
local opt = vim.opt

-- Indentation: 4-space soft tabs (vim-sleuth still auto-detects per file).
-- cindent is dropped in favour of Treesitter-aware indentation.
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.shiftround = true
opt.smartindent = true

-- Display
opt.number = true
opt.cursorline = true
opt.wrap = false
opt.linebreak = true
opt.scrolloff = 5
opt.sidescrolloff = 5
opt.showmatch = true
opt.showtabline = 2
opt.signcolumn = 'yes'          -- stop git/diagnostic signs shifting the buffer
opt.title = true
opt.cmdheight = 2
opt.termguicolors = true
opt.background = 'dark'
opt.modelines = 0
opt.fileformats = 'unix'
-- Marker at 80, solid block from column 120 on (same formula as the .vimrc).
opt.colorcolumn = '80,' .. table.concat(vim.fn.range(120, 999), ',')
opt.guicursor:append('v:blinkon0')

-- Search
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Editing behaviour
opt.autowrite = true
opt.clipboard = 'unnamed,unnamedplus'   -- system clipboard on macOS + Linux
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.formatoptions = 'qrn1'
opt.whichwrap:append('<,>,h,l')
opt.mouse = 'a'
opt.updatetime = 250
opt.textwidth = 200                      -- FileType text overrides this to 80
opt.tags = 'tags;/'

-- Bells off
opt.errorbells = false
opt.visualbell = false

-- Wildmenu ignore list
opt.wildmode = { 'list:longest', 'full' }
opt.wildignore = { '*.o', '*~', '*.pyc', '*.pyo', '*.exe', '.git/*', '.idea/*' }

-- Diff: add ignore-whitespace + force vertical splits on top of nvim defaults.
opt.diffopt:append({ 'iwhite', 'vertical' })

-- Persistent undo + backups + swap, kept out of the working tree under
-- ~/.local/share/nvim (mirrors the .vimrc's ~/.vim/{undo,backup,tmp}).
local data = vim.fn.stdpath('data')
opt.undofile = true
opt.undolevels = 500
opt.undodir = data .. '/undo'
opt.backup = true
opt.backupdir = data .. '/backup'
opt.directory = data .. '/swap//'        -- // = full-path swap names, avoids clashes
vim.fn.mkdir(data .. '/undo', 'p')
vim.fn.mkdir(data .. '/backup', 'p')
vim.fn.mkdir(data .. '/swap', 'p')
