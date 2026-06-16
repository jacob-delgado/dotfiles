-- Treesitter: real syntax trees for highlighting + indentation, replacing the
-- regex `syntax on` and all the g:go_highlight_* flags from the .vimrc.
return {
  'nvim-treesitter/nvim-treesitter',
  -- Pin the stable master branch. The newer default `main` branch dropped the
  -- nvim-treesitter.configs setup API (ensure_installed / highlight.enable)
  -- this spec uses in favour of an evolving, more manual one.
  branch = 'master',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'go', 'gomod', 'gosum', 'gowork', 'rust', 'python', 'lua', 'bash',
      'yaml', 'json', 'toml', 'markdown', 'markdown_inline',
      'vim', 'vimdoc', 'dockerfile', 'gitcommit', 'diff',
    },
    highlight = { enable = true },
    indent = { enable = true },
  },
}
