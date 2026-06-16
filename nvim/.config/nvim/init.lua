-- Neovim entry point. This is a from-scratch Lua rebuild of the vim/ package
-- (lazy.nvim, native LSP + Treesitter), not a fork of ~/.vimrc. See
-- nvim/README.md for the plugin-by-plugin map from the old config.

-- Leader must be set before lazy.nvim loads so plugin mappings observe it.
-- Matches the .vimrc: leader = ',' (localleader too, for filetype plugins).
vim.g.mapleader = ','
vim.g.maplocalleader = ','

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.commands')
require('config.lazy')
