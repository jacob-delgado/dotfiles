-- Editing essentials. The tpope stack still has no better replacement and runs
-- natively under Neovim, so it carries over unchanged. Two tpope plugins are
-- dropped because Neovim now ships their core: vim-commentary (gc/gcc, 0.10+)
-- and vim-unimpaired (]q [q ]b [b ]<Space> ]d bracket maps are defaults, 0.11+;
-- the ]c/[c hunk maps come from gitsigns).
return {
  'tpope/vim-surround',          -- cs'" / ys{motion}{char} / ds{char}
  'tpope/vim-repeat',            -- makes surround (and friends) '.'-repeatable
  'tpope/vim-sleuth',            -- auto-detect indent settings per file
  'tpope/vim-eunuch',            -- :Rename :Move :Delete :SudoWrite :Chmod
  'tpope/vim-projectionist',     -- project-aware :A file switching
  { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } },
  'AndrewRadev/splitjoin.vim',   -- gS / gJ split <-> join one-liners

  -- <C-h/j/k/l> crosses Vim splits AND tmux panes (pairs with tmux config).
  { 'christoomey/vim-tmux-navigator', lazy = false },

  -- Auto-close brackets/quotes (replaces jiangmiao/auto-pairs).
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

  -- editorconfig support is built into Neovim 0.9+, so editorconfig-vim is gone.
}
