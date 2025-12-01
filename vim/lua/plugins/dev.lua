return {
  {
    name = "amp",
    dir = "~/code/amp.nvim/",
    opts = { auto_start = true, log_level = "info" },
    -- config = function(opts)
    --   require("amp").setup(opts)
    -- end,
  },
  {
    "sourcegraph/amp.nvim",
    branch = "main",
    lazy = false,
    enabled = false,
    opts = { auto_start = true, log_level = "info" },
  }
}
