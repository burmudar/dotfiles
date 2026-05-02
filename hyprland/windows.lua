-- Window rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "xwayland-nofocus",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_initial_focus = true,
})

hl.window_rule({
    name = "default-opacity",
    match = { class = ".*" },
    opacity = "0.97 0.9",
})

hl.window_rule({
    name = "terminal-tag",
    match = { class = "(Alacritty|kitty|com.mitchellh.ghostty)" },
    tag = "+terminal",
})

hl.window_rule({
    name = "chromium-tag",
    match = { class = "((google-)?[cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)" },
    tag = "+chromium-based-browser",
})

hl.window_rule({
    name = "firefox-tag",
    match = { class = "([fF]irefox|zen|librewolf)" },
    tag = "+firefox-based-browser",
})

hl.window_rule({
    name = "chromium-tile",
    match = { tag = "chromium-based-browser" },
    tile = true,
})

hl.window_rule({
    name = "chromium-opacity",
    match = { tag = "chromium-based-browser" },
    opacity = "1 0.97",
})

hl.window_rule({
    name = "firefox-opacity",
    match = { tag = "firefox-based-browser" },
    opacity = "1 0.97",
})

hl.window_rule({
    name = "video-sites-opacity",
    match = { initial_title = [=[((?i)(?:[a-z0-9-]+\.)*youtube\.com_/|app\.zoom\.us_/wc/home)]=] },
    opacity = "1.0 1.0",
})

hl.window_rule({
    name = "media-apps-opacity",
    match = { class = "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|imv)$" },
    opacity = "1 1",
})

hl.window_rule({
    name = "floating-float",
    match = { tag = "floating-window" },
    float = true,
})

hl.window_rule({
    name = "floating-center",
    match = { tag = "floating-window" },
    center = true,
})

hl.window_rule({
    name = "floating-size",
    match = { tag = "floating-window" },
    size = { 800, 600 },
})

hl.window_rule({
    name = "floating-apps-tag",
    match = { class = "(blueberry.py|org.gnome.NautilusPreviewer|com.gabm.satty)" },
    tag = "+floating-window",
})

hl.window_rule({
    name = "file-dialogs-tag",
    match = {
        class = "(xdg-desktop-portal-gtk|sublime_text|org.gnome.Nautilus)",
        title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files)",
    },
    tag = "+floating-window",
})

hl.window_rule({
    name = "calculator-float",
    match = { class = "org.gnome.Calculator" },
    float = true,
})

hl.window_rule({
    name = "clipse-float",
    match = { class = "(com.custom.clipse)" },
    float = true,
})

hl.window_rule({
    name = "clipse-size",
    match = { class = "(com.custom.clipse)" },
    size = { 622, 652 },
})
