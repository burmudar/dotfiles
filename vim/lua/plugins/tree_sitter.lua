return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ':TSUpdate',
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context", "nvim-treesitter/nvim-treesitter-textobjects"
    },
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    opts = {
      ensure_install = { "c99", "c++", "html", "java", "kotlin", "go", "javascript", "typescript", "python", "zig",
        "rust", "lua_ls", "nix", "ocaml", "norg", "starlark" },
      auto_install = true,
      ignore_install = {},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        -- disable treesitter on large files
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end
  },
  { "nvim-treesitter/nvim-treesitter-context",     dependencies = { "nvim-treesitter/nvim-treesitter" } },
  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter/nvim-treesitter" } },
}
