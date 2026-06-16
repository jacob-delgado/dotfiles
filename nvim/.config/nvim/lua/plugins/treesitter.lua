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
  dependencies = {
    -- af/if/ac/ic/aa/ia text objects + ]m [m ]] [[ motions. No built-in
    -- equivalent. Pinned to master to match nvim-treesitter's branch/API.
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'master' },
  },
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'go', 'gomod', 'gosum', 'gowork', 'rust', 'python', 'lua', 'bash',
      'yaml', 'json', 'toml', 'markdown', 'markdown_inline',
      'vim', 'vimdoc', 'dockerfile', 'gitcommit', 'diff',
    },
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- jump forward to the next textobject if not on one
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- record these moves in the jumplist
        goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
        goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
      },
    },
  },
}
