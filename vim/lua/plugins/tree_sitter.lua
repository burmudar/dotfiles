return {
    "neovim-treesitter/nvim-treesitter",
    version = false,
    build = ':TSUpdate',
    dependencies = {
        "neovim-treesitter/treesitter-parser-registry"
    },
    opts = {
      ensure_install = { "c99", "c++", "elixir", "html", "java", "kotlin", "go", "javascript", "typescript", "python", "zig",
        "rust", "lua_ls", "nix", "ocaml", "starlark" },
      ignored = { "norg" },
    },
    config = function(_, opts)
      -- if type(opts.ensure_install) == "table" then
      --   opts.ensure_install = LazyVim.dedup(opts.ensure_install)
      -- end
      require("nvim-treesitter").install(opts.ensure_install)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = opts.ensure_install,
        callback = function ()
          vim.treesitter.start()
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'
          vim.bo.indentexpr = "vLlua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end
}
