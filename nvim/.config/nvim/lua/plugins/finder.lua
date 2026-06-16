-- fzf-lua: the closest Neovim analogue to the fzf + fzf.vim setup. Pickers are
-- bound to the same leader keys the .vimrc used. fzf_colors=true inherits the
-- terminal's Dracula fzf palette (set in fzf/.fzf.zsh).
return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'FzfLua',
  keys = {
    { '<C-p>', '<cmd>FzfLua files<cr>', desc = 'Find files' },
    { '<leader>f', '<cmd>FzfLua files<cr>', desc = 'Find files' },
    { '<leader>b', '<cmd>FzfLua buffers<cr>', desc = 'Buffers' },
    { '<leader>be', '<cmd>FzfLua buffers<cr>', desc = 'Buffers' },
    { '<leader>a', '<cmd>FzfLua live_grep<cr>', desc = 'Live grep (rg)' },
    { '<leader>*', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep word under cursor' },
    { '<leader>h', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent files' },
  },
  opts = {
    winopts = { height = 0.85, width = 0.85 },
    fzf_colors = true,
  },
}
