-- Keybindings configuration
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER"
local terminal = "ghostty"
local fileManager = "nautilus"
local browser = "qutebrowser"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal), { description = "Terminal" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(fileManager), { description = "File manager" })
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browser), { description = "Browser" })

hl.bind(mainMod .. " + BACKSPACE", hl.dsp.exec_cmd("wofi --show drun"), { description = "Launch apps" })
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("wlogout"), { description = "Power menu" })

hl.bind(mainMod .. " + C", hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert" }), { description = "Copy" })
hl.bind(mainMod .. " + V", hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" }), { description = "Paste" })
hl.bind(mainMod .. " + X", hl.dsp.send_shortcut({ mods = "CTRL", key = "X" }), { description = "Cut" })
hl.bind(mainMod .. " + CTRL + V", hl.dsp.exec_cmd("ghostty --class=com.custom.clipse -e 'clipse'"), { description = "Clipboard manager" })

hl.bind(mainMod .. " + COMMA", hl.dsp.exec_cmd("makoctl dismiss"), { description = "Dismiss last notification" })
hl.bind(mainMod .. " + SHIFT + COMMA", hl.dsp.exec_cmd("makoctl dismiss --all"), { description = "Dismiss all notifications" })

hl.bind("SHIFT + ALT + M", hl.dsp.exec_cmd([=[hyprctl dispatch 'hl.dsp.dpms({ action = "off" })']=]))
hl.bind("CTRL + ALT + M", hl.dsp.exec_cmd([=[hyprctl dispatch 'hl.dsp.dpms({ action = "on" })']=]))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd([=[grim -g "$(slurp)" - | wl-copy]=]), { description = "Screenshot" })
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"), { description = "Color picking" })

hl.bind(mainMod .. " + W", hl.dsp.window.kill(), { description = "Close active window" })
hl.bind(
    "CTRL + ALT + DELETE",
    hl.dsp.exec_cmd([=[
while read -r address; do
    hyprctl dispatch "hl.dsp.window.close({ window = \"address:${address}\" })"
done < <(hyprctl clients -j | jq -r '.[].address')
]=]),
    { description = "Close all Windows" }
)

hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudo window" })
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Force full screen" })
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }), { description = "Tiled full screen" })
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Full width" })

hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "l" }), { description = "Move focus left" })
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "r" }), { description = "Move focus right" })
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "u" }), { description = "Move focus up" })
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "d" }), { description = "Move focus down" })

local workspaceKeys = {
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
}

for workspace, key in ipairs(workspaceKeys) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }), {
        description = "Switch to workspace " .. workspace,
    })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }), {
        description = "Move window to workspace " .. workspace,
    })
end

hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind(mainMod .. " + CTRL + TAB", hl.dsp.focus({ workspace = "previous" }), { description = "Former workspace" })

hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.window.swap({ direction = "l" }), { description = "Swap window to the left" })
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "r" }), { description = "Swap window to the right" })
hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.swap({ direction = "u" }), { description = "Swap window up" })
hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.swap({ direction = "d" }), { description = "Swap window down" })

hl.bind("ALT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end, { description = "Cycle to next window" })

hl.bind("ALT + SHIFT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end, { description = "Cycle to prev window" })

hl.bind(mainMod .. " + minus", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { description = "Expand window left" })
hl.bind(mainMod .. " + +", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { description = "Shrink window left" })
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { description = "Shrink window up" })
hl.bind(mainMod .. " + SHIFT + +", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { description = "Expand window down" })

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Scroll active workspace forward" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Scroll active workspace backward" })

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { description = "Toggle window grouping" })
hl.bind(mainMod .. " + ALT + G", hl.dsp.window.move({ out_of_group = true }), { description = "Move active window out of group" })

hl.bind(mainMod .. " + ALT + LEFT", hl.dsp.window.move({ into_group = true, direction = "l" }), { description = "Move window to group on left" })
hl.bind(mainMod .. " + ALT + RIGHT", hl.dsp.window.move({ into_group = true, direction = "r" }), { description = "Move window to group on right" })
hl.bind(mainMod .. " + ALT + UP", hl.dsp.window.move({ into_group = true, direction = "u" }), { description = "Move window to group on top" })
hl.bind(mainMod .. " + ALT + DOWN", hl.dsp.window.move({ into_group = true, direction = "d" }), { description = "Move window to group on bottom" })

hl.bind(mainMod .. " + ALT + TAB", hl.dsp.group.next(), { description = "Next window in group" })
hl.bind(mainMod .. " + ALT + SHIFT + TAB", hl.dsp.group.prev(), { description = "Previous window in group" })

hl.bind(mainMod .. " + ALT + 1", hl.dsp.group.active({ index = 1 }), { description = "Switch to group window 1" })
hl.bind(mainMod .. " + ALT + 2", hl.dsp.group.active({ index = 2 }), { description = "Switch to group window 2" })
hl.bind(mainMod .. " + ALT + 3", hl.dsp.group.active({ index = 3 }), { description = "Switch to group window 3" })
hl.bind(mainMod .. " + ALT + 4", hl.dsp.group.active({ index = 4 }), { description = "Switch to group window 4" })
hl.bind(mainMod .. " + ALT + 5", hl.dsp.group.active({ index = 5 }), { description = "Switch to group window 5" })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), {
    locked = true,
    repeating = true,
    description = "Volume up",
})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), {
    locked = true,
    repeating = true,
    description = "Volume down",
})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {
    locked = true,
    repeating = true,
    description = "Mute",
})
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), {
    locked = true,
    repeating = true,
    description = "Mute microphone",
})
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), {
    locked = true,
    repeating = true,
    description = "Brightness up",
})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), {
    locked = true,
    repeating = true,
    description = "Brightness down",
})

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), {
    locked = true,
    description = "Next track",
})
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), {
    locked = true,
    description = "Pause",
})
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), {
    locked = true,
    description = "Play",
})
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), {
    locked = true,
    description = "Previous track",
})
