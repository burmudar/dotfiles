return {
  -- "nvim-lua/popup.nvim",
  "christoomey/vim-tmux-navigator",
  "tpope/vim-sensible",
  "tpope/vim-surround",
  { 'echasnovski/mini.statusline', version = '*', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      numhl = true,
      word_diff = false,
      current_line_blame = true,
    }
  },
  -- "stevearc/dressing.nvim",
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim"
  },
  "rust-lang/rust.vim",
  "ziglang/zig.vim",
  "folke/which-key.nvim",
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta",        lazy = true }, -- optional `vim.uv` typings
  require("burm.sg").setup(),
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  },
}
