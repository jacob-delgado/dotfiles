-- Autocommands ported from vim/.vimrc.
local augroup = vim.api.nvim_create_augroup('vimrc', { clear = true })
local au = vim.api.nvim_create_autocmd

-- Narrower text width for prose files
au('FileType', {
  group = augroup,
  pattern = 'text',
  callback = function() vim.opt_local.textwidth = 80 end,
})

-- Restore the cursor to its last position when reopening a file
au('BufReadPost', {
  group = augroup,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Strip trailing whitespace on save for Go / Python / shell
au('BufWritePre', {
  group = augroup,
  pattern = { '*.go', '*.py', '*.sh' },
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[silent! keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Highlight trailing whitespace in red. clearmatches() + matchadd() mirrors the
-- .vimrc's :match toggling, excluding the char right under the cursor while
-- typing so it doesn't flash on every space.
local function highlight_trailing(exclude_cursor)
  vim.fn.clearmatches()
  if exclude_cursor then
    vim.fn.matchadd('ExtraWhitespace', [[\s\+\%#\@<!$]])
  else
    vim.fn.matchadd('ExtraWhitespace', [[\s\+$]])
  end
end
au({ 'BufWinEnter', 'InsertLeave' }, {
  group = augroup,
  callback = function() highlight_trailing(false) end,
})
au('InsertEnter', {
  group = augroup,
  callback = function() highlight_trailing(true) end,
})
-- Re-apply the highlight group whenever the colorscheme (re)loads.
au('ColorScheme', {
  group = augroup,
  callback = function()
    vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = '#ff5555' }) -- Dracula red
  end,
})
