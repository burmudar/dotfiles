return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      svelte = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
      python = { "ruff_format" },
      go = { "gofmt", "goimports" },
      rust = { "rustfmt" },
      zig = { "zigfmt" },
    },
    format_on_save = function(bufnr)
      if vim.b[bufnr].disable_autoformat then
        return
      end
      if vim.bo[bufnr].filetype == "nix" then
        return
      end
      return {
        timeout_ms = 3000,
        lsp_fallback = true,
      }
    end,
  },
}
