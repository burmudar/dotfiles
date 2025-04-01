return {
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    config = function()
      vim.api.nvim_create_user_command("Nt", ":e ~/code/notes/tasks.norg", {})
      vim.api.nvim_create_user_command("Nj", "Neorg journal today", {})
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/code/notes",
              },
              default_workspace = "notes",
            },
          },
        },
      }

      vim.wo.foldlevel = 99
      vim.wo.conceallevel = 2
    end,
  }
}
