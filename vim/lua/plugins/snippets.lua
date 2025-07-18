return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",                   -- for regex support
  dependencies = { "rafamadriz/friendly-snippets" }, -- optional
  config = function()
    require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })
  end,
}
