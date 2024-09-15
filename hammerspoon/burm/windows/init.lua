local M = {}

local function showFn(hint)
  local names = {}
  if type(hint) ~= "table" then
    table.insert(names, hint)
  else
    names = hint
  end
  return function()
    for _, name in ipairs(names) do
      local app = hs.application.find(name)
      if app and not app:isFrontmost() then
        app:activate()
        return
      end
    end
  end
end

local function maximizeFocusedWindow()
  local window = hs.window.focusedWindow()
  window:centerOnScreen()
  window:maximize()
end

local function moveWindow(screenNum)
  local screens = hs.screen.allScreens()
  return function()
    local window = hs.window.focusedWindow()
    window:moveToScreen(screens[screenNum])
  end
end

M.setup = function(cfg)
  cfg = cfg or {}

  local showBindings = cfg.show or {}
  for _, val in ipairs(showBindings) do
    local fn = val.fn or showFn(val.apps)
    hs.hotkey.bind(val.meta, val.key, fn)
  end

  local moveBindings = cfg.move or {}
  for _, val in ipairs(moveBindings) do
    hs.hotkey.bind(val.meta, val.key, moveWindow(val.window))
  end

  local maxWindow = cfg.maximise or {}
  hs.hotkey.bind(maxWindow.meta, maxWindow.key, maximizeFocusedWindow)
end

return M
