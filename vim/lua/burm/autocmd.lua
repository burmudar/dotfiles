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

  -- register user command with !! which puts the entire buffer through a shell command
  vim.api.nvim_create_user_command("RR", function(opts)
    local range = ""
    if opts.range > 0 then
      range = string.format(":%d,%d!", opts.line1, opts.line2)
    else
      range = ":%!"
    end
    vim.cmd(range .. opts.args)
  end, {
    nargs = "+",
    range = true,
    desc = "Pipe (pipe of the buffer through a shell command"
  })

  -- register a user command to insert co-author lines
  vim.api.nvim_create_user_command("Coauth", function(opts)
    local keegan = "Co-authored-by Keegan Carruthers-Smith <keegan.csmith@gmail.com>"
    local bolaji = "Co-authored-by Bolaji Olajide <25608335+BolajiOlajide@users.noreply.github.com>"
    
    local text = ""
    if opts.args == "keegan" then
      text = keegan
    elseif opts.args == "bolaji" then
      text = bolaji
    else
      text = keegan .. "\n" .. bolaji
    end
    
    -- Insert the text at the current cursor position
    local pos = vim.api.nvim_win_get_cursor(0)
    local line = pos[1] - 1
    vim.api.nvim_buf_set_lines(0, line, line, false, vim.split(text, "\n"))
  end, {
    nargs = "?",
    desc = "Insert co-author lines for commit messages"
  })
end

return M
