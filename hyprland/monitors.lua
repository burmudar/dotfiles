-- Monitor configuration
-- https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output = "DP-2",
    mode = "3840x2160@119",
    position = "0x0",
    scale = 1.25,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440@143",
    position = "3072x0",
    scale = 1,
    transform = 1,
})

hl.workspace_rule({ workspace = "1", monitor = "DP-2", decorate = true, gaps_in = 1, gaps_out = 8 })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", decorate = true, gaps_in = 1, gaps_out = 8 })
hl.workspace_rule({ workspace = "3", monitor = "DP-2", decorate = true, gaps_in = 1, gaps_out = 8 })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", decorate = true, gaps_in = 1, gaps_out = 8 })
hl.workspace_rule({ workspace = "5", monitor = "DP-2", decorate = true, gaps_in = 1, gaps_out = 8 })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", decorate = true, gaps_in = 1, gaps_out = 8 })
hl.workspace_rule({ workspace = "7", monitor = "DP-2", decorate = true, gaps_in = 1, gaps_out = 8 })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1", decorate = true, gaps_in = 1, gaps_out = 8 })
