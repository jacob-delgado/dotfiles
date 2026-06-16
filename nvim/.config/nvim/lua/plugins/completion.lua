-- blink.cmp: completion engine + snippet expansion (replaces the
-- UltiSnips + vim-snippets stack). version='*' pulls a tagged release, which
-- ships a prebuilt fuzzy-matcher binary — no Rust toolchain needed to build.
return {
  'saghen/blink.cmp',
  version = '*',
  dependencies = { 'rafamadriz/friendly-snippets' },
  event = 'InsertEnter',
  opts = {
    -- default preset: <C-y> accept, <C-n>/<C-p> select, <C-space> toggle docs.
    keymap = { preset = 'default' },
    completion = { documentation = { auto_show = true } },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
}
