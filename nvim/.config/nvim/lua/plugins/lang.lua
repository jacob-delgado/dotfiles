return {
  -- Go: go.nvim reproduces the vim-go command workflow (:GoTest, :GoRun,
  -- :GoCoverage, :GoAlt, …) on top of gopls. It configures gopls itself
  -- (lsp_cfg=true), so plugins/lsp.lua deliberately leaves gopls alone.
  -- After first install, run :GoInstallBinaries to fetch gopls + friends.
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'go', 'gomod' },
    opts = {
      lsp_cfg = true,
      lsp_keymaps = false,        -- we set our own, matching the .vimrc leaders
      lsp_inlay_hints = { enable = false },
      goimports = 'gopls',        -- format + organise imports (g:go_fmt_command)
    },
    config = function(_, opts)
      require('go').setup(opts)

      -- goimports on save (mirrors g:go_fmt_command = "goimports").
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        group = vim.api.nvim_create_augroup('go-format', { clear = true }),
        callback = function() require('go.format').goimports() end,
      })

      -- Go leader maps, active only in Go buffers (mirrors the vim-go set).
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'go',
        group = vim.api.nvim_create_augroup('go-maps', { clear = true }),
        callback = function(ev)
          local function m(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          m('<leader>b', '<cmd>GoBuild<cr>', 'Go build')
          m('<leader>t', '<cmd>GoTest<cr>', 'Go test')
          m('<leader>r', '<cmd>GoRun<cr>', 'Go run')
          m('<leader>c', '<cmd>GoCoverage<cr>', 'Go coverage toggle')
          m('<leader>ga', '<cmd>GoAlt<cr>', 'Go alternate (code <-> test)')
          m('<leader>gl', '<cmd>GoLint<cr>', 'Go lint')
          m('<leader>gd', '<cmd>GoDoc<cr>', 'Go doc')
          m('<leader>i', vim.lsp.buf.hover, 'Type/doc under cursor')
          m('<leader>s', vim.lsp.buf.implementation, 'Implements')
          m('<leader>ds', '<cmd>split | lua vim.lsp.buf.definition()<cr>', 'Definition in split')
          m('<leader>dv', '<cmd>vsplit | lua vim.lsp.buf.definition()<cr>', 'Definition in vsplit')
          m('<leader>dt', '<cmd>tab split | lua vim.lsp.buf.definition()<cr>', 'Definition in tab')
        end,
      })
    end,
  },

  -- Rust: rust-analyzer is configured in plugins/lsp.lua; rust.vim adds the
  -- filetype + :RustFmt niceties.
  { 'rust-lang/rust.vim', ft = 'rust' },
}
