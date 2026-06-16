return {
  -- Git porcelain. Fugitive stays the gold standard — no Lua replacement needed.
  { 'tpope/vim-fugitive', cmd = { 'Git', 'Gdiffsplit', 'Gread', 'Gwrite', 'Gclog', 'Gblame' } },

  -- Gutter signs + hunk navigation (replaces vim-gitgutter).
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(buf)
        local gs = require('gitsigns')
        local function map(lhs, rhs, desc)
          vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc })
        end
        -- ]c / [c next/prev hunk (matches the unimpaired-style .vimrc maps)
        map(']c', function() gs.nav_hunk('next') end, 'Next git hunk')
        map('[c', function() gs.nav_hunk('prev') end, 'Prev git hunk')
        map('<leader>gg', gs.toggle_linehl, 'Toggle git line highlight')
        map('<leader>hs', gs.stage_hunk, 'Stage hunk')
        map('<leader>hu', gs.reset_hunk, 'Reset hunk')
        map('<leader>hp', gs.preview_hunk, 'Preview hunk')
      end,
    },
  },
}
