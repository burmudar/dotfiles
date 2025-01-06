return {
  "onsails/lspkind-nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',       opts = {} },
      'folke/neodev.nvim',
    },
    config = function(opts)
      require("burm.lsp").setup({})
    end,
  },
  "folke/lsp-colors.nvim",
  "folke/trouble.nvim",
  "ray-x/lsp_signature.nvim",
}
