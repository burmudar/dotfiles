--- KEYMAPS HERE
local M        = {}
local km       = vim.keymap.set
--local burm_telescope    = require("burm.telescope")
local gitsigns = require("gitsigns")

-- snippets sets keybindings for Luansnips
local function snippets()
  km({ "i", "s" }, "<C-j>", function()
    local ls = require("luasnip")
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, { silent = true })

  -- Use <C-k> to jump backward
  km({ "i", "s" }, "<C-k>", function()
    local ls = require("luasnip")
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true })
end

local function misc()
  km("n", "n", "nzzzv", { noremap = true, desc = "center on next result in search" })
  km("n", "N", "Nzzzv", { noremap = true, desc = "center on previous result in search" })


  km("n", "<tab><leader>", ":tabn<cr>")
  km("n", "<leader><tab>", ":tabp<cr>")
  km("n", "<leader><cr>", ":so ~/.config/nvim/init.lua<cr>")
  --- this should probably be a auto command in lua files
  km("n", "<c-m-r>", require('burm.funcs').reload_current)
  --- QuickFix
  km("n", "]p", ":cnext<cr>")
  km("n", "[p", ":cprev<cr>")
  km("n", "<c-q>", require('burm.funcs').toggle_quickfix)

  km("n", "<leader>o", require('burm.funcs').open_url)

  km("n", "<leader>.d", gitsigns.diffthis, { desc = "[g]it [d]iff this" })
  km("n", "<leader>.D", function() gitsigns.diffthis("~") end, { desc = "[g]it [d]iff this with origin" })

  -- Yank into clipboard
  km("v", "<leader>y", "\"+y")
  km("n", "<leader>p", "\"+p")

  --- Debugging
  km('n', "<leader>b", require('dap').toggle_breakpoint)
  km('n', "<leader>B", function()
    require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
  end)
  km('n', "<F5>", require('dap').continue)
  km('n', "<F6>", require('dapui').toggle)
  km('n', "<F10>", require('dap').step_over)
  km('n', "<F11>", require('dap').step_into)
  km('n', "<F12>", require('dap').step_out)
  -- Markdown
  km("n", "<leader>tm", "<cmd>RenderMarkdown toggle<cr>")
  -- Execute lua
  km("n", "<space><space>x", "<cmd>source %<cr>")
  km("n", "<space>x", ":lua<cr>", { desc = "execute lua [N]" })
  km("v", "<space>x", ":lua<cr>", { desc = "execute lua [V]" })
end

M.general = function()
  misc()
  snippets()
end

function M.lsp(bufnr)
  local opts = function(desc)
    return { desc = "LSP: " .. desc, buffer = bufnr, noremap = true, silent = true }
  end

  km('n', 'gD', vim.lsp.buf.declaration, opts("[G]oto [D]eclaration"))
  km('n', 'K', vim.lsp.buf.hover, opts("[H]over Documentation"))
  km('n', '[d', vim.diagnostic.goto_prev, opts("Prev Diagnostic"))
  km('n', ']d', vim.diagnostic.goto_next, opts("Next Diagnostics"))
  km('n', '<M-r>', vim.lsp.buf.rename, opts("[R][e]name"))
  km('n', '<M-.>', vim.lsp.buf.code_action, opts("[C]ode [A]ction"))
  km('v', '<M-.>', vim.lsp.buf.code_action, opts("[C]ode [A]ction"))
  km('n', '<leader>ci', vim.lsp.buf.incoming_calls, opts("[I]ncoming [c]alls"))
  km('n', '<leader>co', vim.lsp.buf.outgoing_calls, opts("[O]utgoing [c]alls"))
  km('n', '<leader>l', vim.diagnostic.setloclist, opts("Diagnostics to Loc List"))
  km('n', '<leader>q', vim.diagnostic.setqflist, opts("Diagnostics to QuickFix List"))
  km('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, opts("Format"))
end

M.setup = function(callbacks)
  if not callbacks == nil then
    for _, cb in ipairs(callbacks) do
      cb()
    end
  end
  M.general()
end


return M
