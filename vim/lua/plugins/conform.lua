return {
  {
    "stevearc/conform.nvim",
    config = function (opts)
      require("conform").setup({
        formatters_by_ft = {
          lua = {"stylelua"},
          go = { "gofmt", lsp_format = "fallback" }
        }
      })
    end
  },
}
