local M = {}

local function newFocus()
  local cache_dir = vim.fn.stdpath("cache") .. "/focus"
  local date = os.date("%Y-%m-%d")
  local self = {
    content = {
      "* Flow Dojo Checklist",
      "- ( ) All comms closed (Slack, Discord, Telegram, etc.)",
      "- ( ) Phone + watch silenced + hidden",
      "- ( ) Only 1–2 work tabs open",
      "- ( ) Desk clear (water, tools, task only)",
      "- ( ) Task written: “Today I will ______”",
      "- ( ) Start focus music / ambient noise",
      "- ( ) Breathe (3x) and begin",
    },
    date = date,
    cache_dir = cache_dir,
    filename = cache_dir .. "/" .. date .. ".norg",
  }

  function self:maybe_create()
    local uv = vim.loop

    if not uv.fs_stat(self.cache_dir) then
      vim.fn.mkdir(self.cache_dir, "p")
    end

    if not uv.fs_stat(self.filename) then
      local fd = assert(io.open(self.filename, "w"))
      for _, line in ipairs(self.content) do
        fd:write(line .. "\n")
      end
      fd:close()
    end
  end

  function self:show_popup()
    local buf = vim.fn.bufadd(self.filename)
    vim.fn.bufload(self.filename)

    local max_len = 0

    for _, line in ipairs(self.content) do
      max_len = math.max(max_len, #line)
    end

    local padding = 4
    local width = max_len + padding
    local height = #self.content + 2

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local opts = {
      relative = "editor",
      style = "minimal",
      border = "rounded",
      width = width,
      height = height,
      row = row,
      col = col,
    }

    local win = vim.api.nvim_open_win(buf, true, opts)

    vim.api.nvim_buf_set_option(buf, "filetype", "norg")
    vim.api.nvim_buf_set_option(buf, "buftype", "")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "modifiable", true)

    vim.keymap.set("n", "q", function()
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("write")
      end)
      vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
  end

  return self
end

local function bind(method, obj)
  return function(...)
    method(obj, ...)
  end
end


function M.setup()
  local focus = newFocus()
  vim.api.nvim_create_user_command("Focus", bind(focus.show_popup, focus), {})
end

return M
