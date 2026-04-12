return {
    "neovim-treesitter/nvim-treesitter",
    version = false,
    build = ':TSUpdate',
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    opts = {
      ensure_install = { "c99", "c++", "html", "java", "kotlin", "go", "javascript", "typescript", "python", "zig",
        "rust", "lua_ls", "nix", "ocaml", "norg", "starlark" },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
      end
      require("nvim-treesitter").install(opts.ensure_installed)
    end
}
