return {
  {
    name = "burm",
    dir = "~/.config/nvim/lua/burm",
    config = function(opts)
      require("burm").setup()
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "robitx/gp.nvim",
    }
  }
}
