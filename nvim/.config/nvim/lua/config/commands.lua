-- User commands ported from vim/.vimrc.

-- :W — sudo-save the current buffer. vim-eunuch provides :SudoWrite; :W is the
-- alias the .vimrc kept for muscle memory.
vim.api.nvim_create_user_command('W', 'SudoWrite', {})

-- :DiffOrig — vertical diff between the buffer and the file on disk
vim.api.nvim_create_user_command('DiffOrig', function()
  vim.cmd('vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis')
end, { desc = 'Diff buffer against the on-disk file' })
