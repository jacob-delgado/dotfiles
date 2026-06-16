return {
  -- Mason installs language servers / tools into ~/.local/share/nvim/mason and
  -- prepends its bin dir to PATH.
  { 'williamboman/mason.nvim', opts = {} },

  -- Native LSP. Neovim 0.11+ ships vim.lsp.config()/vim.lsp.enable(); lspconfig
  -- supplies the per-server defaults, mason provides the binaries.
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = 'rounded' },
      })

      -- Buffer-local LSP maps, set when a server attaches. Neovim's built-in
      -- defaults already cover K (hover), grr (references), grn (rename),
      -- gra (code action), gri (implementation); these add the .vimrc-style
      -- ergonomics on top.
      local fmt_group = vim.api.nvim_create_augroup('lsp-format', { clear = true })
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(ev)
          local function map(keys, fn, desc)
            vim.keymap.set('n', keys, fn, { buffer = ev.buf, desc = desc })
          end
          map('gd', vim.lsp.buf.definition, 'Go to definition')
          map('<leader>e', vim.lsp.buf.rename, 'Rename symbol')   -- mirrors vim-go ,e
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action')

          -- Format on save for servers that support it (rust_analyzer, lua_ls,
          -- …). Go is excluded: go.nvim already runs goimports on BufWritePre
          -- for *.go, and double-formatting would just be wasted work.
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.server_capabilities.documentFormattingProvider
            and vim.bo[ev.buf].filetype ~= 'go' then
            vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = ev.buf })
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = fmt_group,
              buffer = ev.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 2000 })
              end,
            })
          end
        end,
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require('mason-lspconfig').setup({
        ensure_installed = { 'rust_analyzer', 'pyright', 'lua_ls', 'bashls', 'yamlls' },
        automatic_enable = false, -- we enable explicitly below; gopls is go.nvim's job
      })

      vim.lsp.config('*', { capabilities = capabilities })
      vim.lsp.config('lua_ls', {
        settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
      })

      -- gopls is intentionally absent: go.nvim (plugins/lang.lua) owns it.
      vim.lsp.enable({ 'rust_analyzer', 'pyright', 'lua_ls', 'bashls', 'yamlls' })
    end,
  },

  -- Linters that aren't language servers — mirrors the old ALE config. The
  -- pylint / shellcheck / yamllint CLIs must be on PATH (same as ALE needed).
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufWritePost' },
    config = function()
      require('lint').linters_by_ft = {
        python = { 'pylint' },
        sh = { 'shellcheck' },
        yaml = { 'yamllint' },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
        callback = function() require('lint').try_lint() end,
      })
    end,
  },
}
