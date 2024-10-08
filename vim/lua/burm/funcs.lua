local pathlib = require("plenary.path")
local M = {}
--- Print the internal representation of the thing
P = function(v)
  print(vim.inspect(v))
  return v
end

--- Reload a module
R = function(...)
  print("reloading " .. ...)
  return require("plenary.reload").reload_module(...)
end

M.env_for_key = function(key, default)
  local env = vim.fn.environ()

  for k, v in pairs(env) do
    if k == key then
      return v
    end
  end

  return default
end

M.src_dir = M.env_for_key("SRC", nil)

M.quick_term = function()
  if not M.term_id then
    vim.cmd [[10new]]
    M.term_id = vim.fn.termopen("/bin/zsh")
  else
    -- does this work ?
    vim.fn.win_execute(M.term_id, "close")
  end

  vim.wait(100, function() return false end)
end

M.current_file = function()
  return vim.fn.expand("%")
end

M.toggle_list_window = function(key, open_cmd, close_cmd)
  local info = vim.fn.getwininfo()
  local curr_win_nr = vim.api.nvim_win_get_number(0)
  local window_info = info[curr_win_nr]

  if window_info[key] > 0 then
    vim.cmd(close_cmd)
  else
    vim.cmd(open_cmd)
  end
end

M.toggle_quickfix = function() toggle_list_window("quickfix", "copen", "cclose") end
M.toggle_loclist = function() toggle_list_window("loclist", "lopen", "lclose") end

M.current_dir = function()
  local file = M.current_file()
  local p = pathlib:new(file)

  return P(p:parent().filename)
end
M.relative_src_dir = function(path)
  local p = pathlib.new(M.src_dir)
  return pathlib.joinpath(p, path).filename
end

M.relative_home_dir = function(path)
  local p = pathlib:new(vim.env.HOME)
  return pathlib.joinpath(p, path).filename
end

M.reload_current = function()
  local current_file = M.current_file()
  local _, e_idx = current_file:find("lua%p", 0)

  if e_idx ~= nil then
    local package_name = current_file:sub(e_idx + 1, #current_file):gsub("/", "."):gsub(".lua", "")
    R(package_name)
  end
end

M.env_set = function(key, value)
  vim.env[key] = value
end

M.file_exists = function(path)
  return vim.fn.filereadable(path) == 1
end

M.read_full = function(path)
  local fp = io.open(path, "r")
  if not fp then
    return ""
  end
  return fp:read()
end

M.Darwin = "Darwin"
M.Linux = "Linux"
M.Windows = "Windows"
M.Unknown = "unknown"

M.is_linux = function()
  return M.get_os() == M.Linux
end
M.is_darwin = function()
  return M.get_os() == M.Darwin
end
M.is_windows = function()
  return M.get_os() == M.Windows
end

M.get_os = function()
  return vim.loop.os_uname().sysname
end

M.open_url = function()
  local url = vim.fn.expand("<cfile>")
  if string.find(url, "^https?://") == nil then
    return
  end
  vim.notify("opening " .. url)
  if M.is_darwin() then
    vim.fn.execute("!open " .. url)
  elseif M.is_linux() then
    vim.fn.execute("!xdg-open " .. url)
  end
end

return M
