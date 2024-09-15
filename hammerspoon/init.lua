require("burm.watcher").setup({
  bind = {
    meta = { "cmd" },
    key = "`"
  }
})

require("burm.windows").setup({
  show = {
    {
      meta = { "cmd" },
      key = "1",
      apps = { "kitty", "alacritty" }
    },
    {
      meta = { "cmd" },
      key = "2",
      fn = function()
        local zoom = hs.application.find("zoom")
        if zoom then
          local win = zoom:findWindow("Zoom Meeting")
          win:focus()
          return
        end
      end
    },
    {
      meta = { "cmd" },
      key = "3",
      apps = "slack"
    },
    {
      meta = { "cmd" },
      key = "4",
      apps = { "Firefox", "qutebrowser" }
    },
  },
  move = {
    {
      meta = { "cmd", "shift" },
      key = "1",
      window = 1
    },
    {
      meta = { "cmd", "shift" },
      key = "2",
      window = 2
    }
  },
  maximise = {
    meta = { "cmd", "shift" },
    key = "w",
  },
})
