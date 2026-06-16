return {
  -- Statusline (replaces vim-airline). 'auto' derives colours from Dracula.
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'auto',
        globalstatus = true,
        section_separators = '',
        component_separators = '',
      },
      sections = {
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
      },
    },
  },

  -- File explorer (replaces NERDTree): ,nt toggle  ,nf reveal current file
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>nt', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle file tree' },
      { '<leader>nf', '<cmd>NvimTreeFindFile<cr>', desc = 'Reveal current file' },
    },
    opts = { view = { width = 35 } },
  },

  -- Symbol outline (replaces tagbar, now LSP/Treesitter-backed): ,tt
  {
    'stevearc/aerial.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    keys = { { '<leader>tt', '<cmd>AerialToggle!<cr>', desc = 'Toggle symbol outline' } },
    opts = {},
  },

  -- Undo-history visualiser (still the best at this): ,u
  {
    'mbbill/undotree',
    keys = { { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Toggle undo tree' } },
  },
}
