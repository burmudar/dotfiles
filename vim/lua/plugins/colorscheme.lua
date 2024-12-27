return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      -- load the colorscheme here
      require("catppuccin").setup {
        -- other possible flavours:
        -- macchiato
        -- frappe
        -- latte
        -- mocha
        flavour = "mocha",
        background = {
          light = "latte",
          dark = "macchiato",
        }
      }

      vim.o.background = "dark"
      vim.cmd([[colorscheme catppuccin]])
    end
  },
}
