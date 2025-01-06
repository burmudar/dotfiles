local M = {}
local keymaps = require("burm.keymaps")
local blink = require('blink.cmp')
local lspconfig = require('lspconfig')
local servers = { "pyright", "gopls", "clangd", "ts_ls", "zls", "lua_ls", "nil_ls", "rust_analyzer" }

local function create_hightlight_autocmd(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Document Highlight",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Clear All the References",
    })
  end
end

local function on_attach(client, bufnr)
  keymaps.lsp(bufnr)
  create_hightlight_autocmd(client, bufnr)
  print("[LSP] " .. client.name .. " attached")
end

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

function M.setup(_opts)
  for i, lsp in ipairs(servers) do
    local c = configs.default
    if configs[lsp] ~= nil then
      c = configs[lsp]
      c.on_attach = configs.default.on_attach
      c.capabilities = blink.get_lsp_capabilities(configs['capabilities'])
    end
    lspconfig[lsp].setup(c)
  end
end

return M
