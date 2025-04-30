--- KEYMAPS HERE
local M                 = {}
local km                = vim.keymap.set
local telescope_builtin = require("telescope.builtin")
local burm_telescope    = require("burm.telescope")
local gitsigns          = require("gitsigns")

local function telescope()
  km("n", "<leader>ll", telescope_builtin.resume, { desc = "[enter] resume last pick" })
  km("n", "<leader>?", telescope_builtin.oldfiles, { desc = "[?] Find recently opened files" })
  km("n", "<leader>sg", telescope_builtin.live_grep, { desc = "[S]earch by [G]rep" })
  km("n", "<leader>gf", telescope_builtin.git_files, { desc = "[G]it [F]iles" })
  km("n", "<leader>sw", telescope_builtin.grep_string, { desc = "[S]earch [W]ord by grep" })
  km("n", "<leader><space>", telescope_builtin.buffers, { desc = "[S]earch existings [B]uffers" })
  km("n", "<leader>sh", telescope_builtin.help_tags, { desc = "[S]earch [H]elp" })
  km("n", "<leader>df", function()
    telescope_builtin.git_files { cwd = '$SRC/dotfiles' }
  end, { desc = "Search [D]ot[F]iles" })
  km("n", "<leader>sl", require('telescope').extensions.live_grep_args.live_grep_args,
    { desc = "[S]earch by [L]ive Grep Args" })

  km("n", "<leader>/", burm_telescope.fuzzy_browser, { desc = "[/] Fuzzy search in current buffer" })
  km("n", "<leader>sf", burm_telescope.quick_file_browser, { desc = "[S]earch [F]iles" })
  km("n", "<leader>sG", burm_telescope.grep_with_glob, { desc = "[S]earch by [G]rep [G]lob" })
end

local function misc()
  km("n", "<leader>n", ":nohlsearch<CR>")
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

  km("n", "<leader>m", require('harpoon.mark').add_file, { desc = "[M]ark a file" })
  km("n", "<leader>sm", require('harpoon.ui').toggle_quick_menu, { desc = "[S]how [M]arks" })
  -- GP bindings
  km("n", "<C-g>t", "<cmd>GpChatToggle<CR>", { noremap = true, desc = "Toggle GP Chat interface" })
  km("v", "<C-g>i", "<cmd>GpImplement<CR>", { noremap = true, desc = "Use current line as prompt and expand" })

  -- Yank into clipboard
  km("v", "<leader>y", "\"+y")
  km("n", "<leader>p", "\"+p")

  -- Oil
  km("n", "<leader>f", require("oil").toggle_float)
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
  --- Press CTRL-ESC to exit terminal mode
  km("t", "<Esc><Esc>", '<C-\\><C-n>', { noremap = true })
  --vim.cmd("tnoremap <Esc> <C-\\><C-n>")
  -- Markdown
  km("n", "<leader>tm", "<cmd>RenderMarkdown toggle<cr>")
  -- Execute lua
  km("n", "<space><space>x", "<cmd>source %<cr>")
  km("n", "<space>x", ":.lua<cr>")
  km("v", "<space>x", ":lua<cr>")
end

M.general = function()
  misc()
  telescope()
end

function M.lsp(bufnr)
  local opts = function(desc)
    return { desc = "LSP: " .. desc, buffer = bufnr, noremap = true, silent = true }
  end

  km('n', 'gD', vim.lsp.buf.declaration, opts("[G]oto [D]eclaration"))
  km('n', 'gd', telescope_builtin.lsp_definitions, opts("[G]oto [D]efinition"))
  km('n', 'K', vim.lsp.buf.hover, opts("[H]over Documentation"))
  km('n', 'gi', telescope_builtin.lsp_implementations, opts("[G]oto [i]mplementation"))
  km('n', 'gr', telescope_builtin.lsp_references, opts("[G]oto [r]eferences"))
  km('n', 'gt', telescope_builtin.lsp_type_definitions, opts("[G]oto [t]ype"))
  km('n', '[d', vim.diagnostic.goto_prev, opts("Prev Diagnostic"))
  km('n', ']d', vim.diagnostic.goto_next, opts("Next Diagnostics"))
  km("n", "<leader>sd", function()
    telescope_builtin.diagnostics(require('telescope.themes').get_dropdown
      {
        layout_config = { width = 0.80 },
        bufnr = 0
      }
    )
  end, { desc = "[S]earch [D]iagnostics" })
  km('n', '<M-r>', vim.lsp.buf.rename, opts("[R][e]name"))
  km('n', '<M-.>', vim.lsp.buf.code_action, opts("[C]ode [A]ction"))
  km('v', '<M-.>', vim.lsp.buf.code_action, opts("[C]ode [A]ction"))
  km('n', '<leader>ci', vim.lsp.buf.incoming_calls, opts("[I]ncoming [c]alls"))
  km('n', '<leader>co', vim.lsp.buf.outgoing_calls, opts("[O]utgoing [c]alls"))
  km('n', '<leader>l', vim.diagnostic.setloclist, opts("Diagnostics to Loc List"))
  km('n', '<leader>q', vim.diagnostic.setqflist, opts("Diagnostics to QuickFix List"))
  km('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, opts("Format"))
  km('n', '<leader>wl', function() P(vim.lsp.buf.list_workspace_folders()) end,
    opts("List Workspace Folders"))
  km('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts("[W]orkspace [A]dd folder"))
  km('n', '<leader>wr', vim.lsp.buf.add_workspace_folder, opts("[W]orkspace [R]emove folder"))
  km('n', '<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols,
    opts("[W]orkspace [S]ymbols"))
  km("n", "<leader>ss", telescope_builtin.lsp_document_symbols, { desc = "[S]earch Document [S]ymbols" })

  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if filetype == "go" then
    vim.keymap.set('n', '<leader>ws', function()
      telescope_builtin.lsp_workspace_symbols { query = vim.fn.input("Query: ") }
    end, opts("[W]orkspace [S]ymbols"))
  end
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
