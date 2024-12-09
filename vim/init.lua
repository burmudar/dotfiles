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
  {
    "robitx/gp.nvim",
    config = function()
      require("gp").setup({
        providers = {
          openai = {
            endpoint = "https://api.openai.com/v1/chat/completions",
            secret = {
              "bash",
              "-c",
              "gopass cat Internet/openai/chatgpt | head -n1"
            },
          }
        }
      })
    end,
  },
  "nvim-lua/popup.nvim",
  "christoomey/vim-tmux-navigator",
  "tpope/vim-sensible",
  "tpope/vim-surround",
  --"tpope/vim-fugitive",
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
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- load the colorscheme here
  --     vim.o.background = "dark"
  --     vim.cmd([[colorscheme tokyonight-storm]])
  --   end,
  -- },
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
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-live-grep-args.nvim'
    }
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      numhl = true,
      word_diff = false,
      current_line_blame = true,
    }
  },
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
  },
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',

    version = 'v0.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = 'default',
      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'normal',

      -- experimental auto-brackets support
      accept = { auto_brackets = { enabled = true } },

      -- experimental signature help support
      trigger = { signature_help = { enabled = true } },
    }
  },
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
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
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = {
      { "echasnovski/mini.icons", opts = {} }
    },
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
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true
  },
  {
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("hunk").setup()
    end,
  }
})
require("burm.keymaps").setup()
require("burm.autocmd").setup()
require("burm.config")
