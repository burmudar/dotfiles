local M = {}

M.setup = function(cfg)
  cfg = cfg or {}
  M.last_app = nil
  M.current_app = nil
  M.watcher = hs.application.watcher.new(M._on_event)

  local binding = cfg.bind
  local meta = binding.meta or { "cmd" }
  local key = binding.key or "`"

  hs.hotkey.bind(meta, key, M.activate_last)

  M.watcher:start()
end

M.shutdown = function()
  M.watcher:stop()
end

M._on_event = function(name, ev_type, app)
  --- Only interested when a new app is activated
  if ev_type == hs.application.watcher.activated then
    --- Remember our current app as the one before this event
    M.last_app = M.current_app
    --- Set the current app to be the one this event is for
    M.current_app = app
  end
end

--- Activate the last app if there is one
M.activate_last = function()
  if M.last_app then
    M.last_app:activate()
  end
end

return M
