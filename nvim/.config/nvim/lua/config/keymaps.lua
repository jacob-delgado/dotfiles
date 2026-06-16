-- Key mappings ported from vim/.vimrc. Plugin-owned maps (fzf-lua, gitsigns,
-- nvim-tree, LSP, go.nvim, …) live with their specs under lua/plugins/.
local map = vim.keymap.set

-- Clear search highlight
map('n', '<leader><space>', '<cmd>nohlsearch<cr>', { silent = true, desc = 'Clear search highlight' })
-- Switch between the last two files
map('n', '<leader><leader>', '<C-^>', { desc = 'Last file' })
-- Edit / source the config ($MYVIMRC points at init.lua under Neovim)
map('n', '<leader>ev', '<cmd>vsplit $MYVIMRC<cr>', { desc = 'Edit init.lua' })
map('n', '<leader>sv', '<cmd>source $MYVIMRC<cr>', { desc = 'Source init.lua' })

-- Toggles
map('n', '<leader>ln', '<cmd>set invnumber<cr>', { desc = 'Toggle number' })
map('n', '<leader>nw', '<cmd>set invwrap<cr>', { desc = 'Toggle wrap' })
map('n', '<leader>rn', '<cmd>set invrelativenumber<cr>', { desc = 'Toggle relativenumber' })
map('n', '<leader>sc', '<cmd>setlocal spell!<cr>', { desc = 'Toggle spell' })
map('n', '<leader>rt', '<cmd>retab<cr>', { desc = 'Retab' })

-- Tabs
map('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = 'New tab' })
map('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = 'Close tab' })

-- Buffers (Bclose plugin gone; plain bdelete is enough)
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })
map('n', '<leader>bda', '<cmd>%bdelete!<cr>', { desc = 'Delete all buffers' })

-- Diff helpers
map('n', '<leader>dc', '<cmd>q<cr><cmd>diffoff!<cr>', { desc = 'Close diff' })
map('n', '<leader>do', '<cmd>DiffOrig<cr>', { desc = 'Diff against on-disk file' })

-- Quickfix: the built-in ]q / [q navigate; ,q closes. The .vimrc used
-- <C-n>/<C-m> for next/prev, but <C-m> IS <CR>, so Enter ran :cprevious in
-- normal mode. Dropped in favour of the built-in bracket maps (0.11+).
map('n', '<leader>q', '<cmd>cclose<cr>', { desc = 'Close quickfix' })

-- Insert-mode tweaks
map('i', 'jj', '<Esc>', { desc = 'Escape' })
map('i', '<Down>', '<C-o>gj', { silent = true })
map('i', '<Up>', '<C-o>gk', { silent = true })

-- Move lines / selections up and down
map('n', '<M-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
map('n', '<M-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
map('v', '<M-j>', ":m '>+1<cr>gv=gv", { silent = true, desc = 'Move selection down' })
map('v', '<M-k>', ":m '<-2<cr>gv=gv", { silent = true, desc = 'Move selection up' })

-- Search ergonomics: re-center the screen on the match
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')
map('n', '*', '*zz')
map('n', '#', '#zz')
map('n', 'g*', 'g*zz')
map('n', 'g#', 'g#zz')
-- Start every search "very magic" (most punctuation is a regex metachar)
map('n', '/', '/\\v')

-- Window navigation. vim-tmux-navigator overrides these to also cross tmux
-- panes; defined here as a fallback for when the plugin is absent.
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Visual: keep the selection after indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Match brackets with <Tab> (rebinds %)
map({ 'n', 'v' }, '<Tab>', '%', { remap = true })

-- Treat j/k as visual-line movement
map('n', 'j', 'gj', { silent = true })
map('n', 'k', 'gk', { silent = true })

-- Reformat with motion (the default Q ex-mode is rarely useful)
map('n', 'Q', 'gq')

-- Open the URL under the cursor in the system's default browser
map('n', '<leader>url', function()
  local url = vim.fn.matchstr(vim.fn.getline('.'), [[http[s]\?:\/\/[^ \t]*]])
  if url == '' then return end
  local opener = vim.fn.has('mac') == 1 and 'open' or 'xdg-open'
  vim.fn.jobstart({ opener, url })
end, { desc = 'Open URL under cursor' })
