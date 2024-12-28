return {
  {
    name = "burm",
    dir = "~/.config/nvim/lua/burm",
    config = function(opts)
      require("burm").setup()
    end,
  }
}
