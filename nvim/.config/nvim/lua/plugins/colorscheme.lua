-- Dracula, the Lua port: Treesitter- and LSP-aware (the old dracula/vim only
-- coloured regex syntax). Matches the kitty / tmux / fzf Dracula palettes.
return {
  'Mofiqul/dracula.nvim',
  name = 'dracula',
  lazy = false,
  priority = 1000, -- load before any other plugin so highlights are set early
  config = function()
    require('dracula').setup({ italic_comment = true })
    vim.cmd.colorscheme('dracula')
  end,
}
