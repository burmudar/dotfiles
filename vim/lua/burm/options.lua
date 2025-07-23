local M = {}

M.setup = function()
  vim.g.mapleader = " "
  vim.g.maplocaleader = " "
  vim.g.rustfmt_autosave = 1

  vim.opt.exrc = true
  vim.opt.guicursor = ""
  vim.opt.number = true
  vim.opt.hidden = true
  vim.opt.hlsearch = false
  vim.opt.cursorline = true
  vim.opt.showmatch = true
  vim.opt.errorbells = false

  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
  vim.opt.shiftround = true
  vim.opt.smartindent = true

  vim.opt.nu = true
  vim.opt.wrap = false
  vim.opt.swapfile = false
  vim.opt.backup = false
  vim.opt.undofile = true
  vim.opt.incsearch = true
  vim.opt.termguicolors = true
  vim.opt.scrolloff = 8
  vim.opt.sidescrolloff = 8
  vim.opt.showmode = false
  vim.opt.signcolumn = "yes"
  vim.opt.colorcolumn = "120"
  vim.opt.splitbelow = true
  vim.opt.completeopt = "menuone,noselect"
  vim.opt.clipboard = "unnamedplus"
  vim.opt.breakindent = true
  -- silent pattern not found in compe
  vim.opt.shortmess:append("c")
  vim.g.completetion_matching_strategy_list = "fuzzy, substring, exact"
  vim.opt.splitbelow = true
  vim.opt.splitright = true

  vim.opt.list = true
  vim.opt.listchars = "tab:▎·,trail:·,eol:↲,nbsp:␣"

  vim.opt.timeoutlen = 300
  vim.opt.updatetime = 50
  vim.opt.syntax = "enable"

  vim.opt.lazyredraw = true
  vim.opt.ttyfast = true

  vim.opt.title = true
  vim.opt.titlestring = "nvim - %t"


  vim.fn.sign_define(
    'DiagnosticSignError',
    { text = '✖', texthl = 'DiagnosticSignError', numhl = 'DiagnosticSignError' }
  )
  vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint', numhl = 'DiagnosticSignHint' })
  vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo', numhl = 'DiagnosticSignInfo' })
  vim.fn.sign_define('DiagnosticSignWarn', {
    text = ' ',
    texthl = 'DiagnosticSignWarn',
    numhl = 'DiagnosticSignWarn'
  })
end

return M
