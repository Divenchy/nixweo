local vars = require("variables")

-- Monitors
hl.monitor({
  output = "HDMI-A-1",
  mode = "preferred",
  position = "auto",
  scale = "1",
})

hl.monitor({
  output = "eDP-1",
  mode = "3840x2400@60.00",
  position = "auto-right",
  scale = "2",
})

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "1",
})

-- Autostart
hl.on("hyprland.start", function()
  hl.exec_cmd(vars.editor, { workspace = "1 silent" })
  hl.exec_cmd(vars.browser, { workspace = "2 silent" })
  hl.exec_cmd(vars.terminal, { workspace = "3 silent" })
  hl.exec_cmd(vars.caelestia_init)
  hl.dsp.focus({ workspace = "2" })
end)

-- Permissions
hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })

-- ENVIRONMENT VARS
hl.env("NIXOS_OZONE_WL", "1")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("YDOTOOL_SOCKET", "/run/ydotool/socket")

-- Hyprland options
require("opts")
-- Animations
require("animations")
-- Binds
require("binds")
