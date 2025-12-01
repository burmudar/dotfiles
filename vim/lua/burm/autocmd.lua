local M = {}

local function registerAutoCmd()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "yaml", "yml" },
    callback = function()
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
    end,
  })
  --- Remove trailing whitespace before write
  vim.cmd([[
    augroup BURM_WHITESPACE
        autocmd!
        autocmd BufWritePre * %s/\s\+$//e
    augroup END
    ]])

  vim.cmd([[
    augroup BURM_FORMATTING
        autocmd!
        autocmd BufWritePre * :lua if not vim.b.disable_autoformat then vim.lsp.buf.format() end
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

  -- register user command to disable/enable auto-formatting
  vim.api.nvim_create_user_command("FormatDisable", function()
    vim.b.disable_autoformat = true
    print("Auto-format disabled for this buffer")
  end, {})

  vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    print("Auto-format enabled for this buffer")
  end, {})

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
  -- Show errors and warnings in a floating window
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
          return
        end
      end
      vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
    end,
  })

  -- Inspect floats
  vim.api.nvim_create_user_command("InspectFloats", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" then
        print("Float window: ", win)
        print(vim.inspect(config))
      end
    end
  end, {})
end

return M
