local M = {}

function M.setup(_opts)
  require("burm.keymaps").setup()
  require("burm.autocmd").setup()
  require("burm.lsp").setup()
  require("burm.focus").setup()
  --require("burm.norg").setup()
end

return M
