local M = {}

M.setup = function()
  if vim.env.SG_NVIM_DEV then
    return { dir = vim.fn.getcwd(), dependencies = { "nvim-lua/plenary.nvim" } }
  else
    return {
      "sourcegraph/sg.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    }
  end
end

return M
