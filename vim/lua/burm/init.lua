local M = {}

function M.setup(_opts)
  require("burm.keymaps").setup()
  require("burm.autocmd").setup()
  require("burm.lsp").setup()
end

return M
