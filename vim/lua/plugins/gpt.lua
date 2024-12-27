return {
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
}
