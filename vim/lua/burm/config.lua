local BF = require('burm.funcs')
-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

require("oil").setup()

require("nvim-web-devicons").setup({ default = true })

require('Comment').setup {}

--- Treesitter config
require('nvim-treesitter.configs').setup {
  ensure_install = { "c99", "c++", "html", "java", "kotlin", "go", "javascript", "typescript", "python", "zig",
    "rust", "lua_ls", "nix", "ocaml" },
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    -- disable treesitter on large files
    disable = function(_, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  indent = { enable = true },
}

--- Telescope setup
local lga_actions = require("telescope-live-grep-args.actions")
require('telescope').setup {
  defaults = {
    prompt_prefix = '> ',
    color_devicons = true,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
      }
    }
  },
  extensions = {
    fzf_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        }
      }
    },
  },
}


require('telescope').load_extension('fzf')
require('telescope').load_extension('harpoon')
require('telescope').load_extension('live_grep_args')


--- nvim-cmp setup
local lspkind = require('lspkind')
lspkind.init()

local cmp = require('burm.cmp')
cmp.setup()

--- LSP setup
-- LSPConfig setup
local keymaps = require("burm.keymaps")
local on_attach = function(client, bufnr)
  print("[LSP] " .. client.name .. " attached")
  keymaps.lsp(bufnr)
end

local servers = { "pyright", "gopls", "clangd", "ts_ls", "zls", "lua_ls", "nil_ls", "rust_analyzer" }
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local configs = {
  default = {
    on_attach = on_attach
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim', 'hs' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  gopls = {
    flags = { debounce_text_changes = 200 },
    settings = {
      gopls = {
        completeUnimported = true,
        buildFlags = { "-mod=readonly", "-tags=debug" },
        ["local"] = "github.com/sourcegraph/sourcegraph",
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        experimentalPostfixCompletions = true,
        codelenses = { test = true },
        hints = {
          parameterNames = true,
          assignVariableTypes = true,
          constantValues = true,
          rangeVariableTypes = true,
          compositeLiteralTypes = true,
          compositeLiteralFields = true,
          functionTypeParameters = true,
        },
      },
    },
  },
  rust_analyzer = {
    flags = { debounce_text_changes = 200 },
    settings = {
      rust_analyzer = {
        cargo = { allFeatures = true },
      },
    },
  },
}



local blink = require('blink.cmp')
for _, lsp in ipairs(servers) do
  local c = configs.default
  if configs[lsp] ~= nil then
    c = configs[lsp]
    c.on_attach = configs.default.on_attach
    c.capabilities = blink.get_lsp_capabilities(configs['capabilities'])
  end

  require('lspconfig')[lsp].setup(c)
end

-- Trouble
require('trouble').setup({})

-- Mason, use :Mason to open up the window
require("mason").setup()


local dap, dapui = require("dap"), require("dapui")
-- require("nvim-dap-virtual-text").setup() this throws a cannot allocate memory error in delv
dapui.setup()
vim.fn.sign_define('DapBreakpoint', { text = '🧪', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🔍', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '👉', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '🛑', texthl = '', linehl = '', numhl = '' })
require('dap-go').setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end

-- Diagnostics
vim.diagnostic.config({
  underline = true,
  virtual_text = true,
  signs = true,
})

-- Remember the last position my cursor was at
require("nvim-lastplace").setup({
  lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
  lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
  lastplace_open_folds = true
})
