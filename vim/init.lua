local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("burm.options").setup()
require("lazy").setup({
  "nvim-lua/popup.nvim",
  "christoomey/vim-tmux-navigator",
  "tpope/vim-sensible",
  "tpope/vim-surround",
  "tpope/vim-fugitive",
  {
    "nvim-lualine/lualine.nvim",
    opts = { theme = "gruvbox" }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ':TSUpdate',
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context", "nvim-treesitter/nvim-treesitter-textobjects" }
  },
  "vim-pandoc/vim-pandoc",
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.o.background = "dark"
      vim.cmd([[colorscheme tokyonight-storm]])
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.o.background = "dark"
      -- vim.cmd([[colorscheme gruvbox]])
    end,
    opts = {
      invert_selection = false
    }
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim' }
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      numhl = true,
      word_diff = true,
      current_line_blame = true,
    }
  },
  "onsails/lspkind-nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',       opts = {} },
      'folke/neodev.nvim',
    },
    -- opts = {
    --   setup = {
    --     rust_analyzer = function()
    --       return true
    --     end,
    --   },
    -- },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    }
  },
  {
    "L3MON4D3/LuaSnip",
    tag = "v2.1.0",
    dependencies = { "saadparwaiz1/cmp_luasnip" }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    config = function()
      require("neo-tree").setup({
        default_component_configs = {
          name = {
            use_git_status_colors = true,
          },
          git_status = {
            symbols = {
              unstaged = ""
            },
          },
        }
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  "folke/which-key.nvim",
  "folke/lsp-colors.nvim",
  "folke/trouble.nvim",
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
  { "Bilal2453/luvit-meta",                     lazy = true }, -- optional `vim.uv` typings
  "ray-x/lsp_signature.nvim",
  "stevearc/dressing.nvim",
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim"
  },
  "ethanholz/nvim-lastplace",
  "ThePrimeagen/harpoon",
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl"
  },
  "numToStr/comment.nvim",
  "rust-lang/rust.vim",
  "ziglang/zig.vim",
  "mfussenegger/nvim-dap",
  "leoluz/nvim-dap-go",
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
  },
  "theHamsta/nvim-dap-virtual-text",
  require("burm.sg").setup(),
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  }
})
require("burm.keymaps").setup()
require("burm.autocmd").setup()
require("burm.config")
