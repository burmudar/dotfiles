local M = {}

local function registerAutoCmd()
  --- Remove trailing whitespace before write
  vim.cmd([[
    augroup BURM_WHITESPACE
        autocmd!
        autocmd BufWritePre * %s/\s\+$//e
    augroup END
    ]])

  vim.cmd([[
    augroup BURM_FORMATTING
        autocmd BufWritePre * :lua vim.lsp.buf.format()
    augroup END
    ]])

  vim.cmd([[
    augroup BURM_GOLANG
      autocmd!

      autocmd BufEnter,BufNewFile,BufRead *.go setlocal formatoptions+=roq
      autocmd BufEnter,BufNewFile,BufRead *.go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
      autocmd BufEnter,BufNewFile,BufRead *.tmpl setlocal filetype=html
    augroup END
    ]])

  vim.cmd([[
    augroup BURN_PYTHON
        autocmd BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
    augroup END
    ]])

  vim.cmd([[
    augroup RUST
        autocmd BufNewFile,BufRead *.rs nnoremap <F5> :RustRun<CR>
    augroup END
    ]])
end

M.setup = function()
  registerAutoCmd()

  -- register a user command which can format json using jq
  vim.api.nvim_create_user_command("JSONF", "% !jq", {})
  -- register Neogit
  vim.api.nvim_create_user_command("G", "Neogit", {})
end

return M
