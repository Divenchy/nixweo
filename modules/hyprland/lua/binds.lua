local vars = require("variables")
local mod = "SUPER"
local shift = "SHIFT"
local ctrl = "CTRL"
local alt = "ALT"

-- Actions
hl.bind(mod + "Return", hl.dsp.exec_cmd(vars.terminal))
hl.bind(mod + "B", hl.dsp.exec_cmd(vars.browser))
hl.bind(mod + "F", hl.dsp.exec_cmd(vars.file_manager))
hl.bind(mod + "Space", hl.dsp.global("caelestia:shell"))
hl.bind(mod + "E", hl.dsp.exec_cmd(vars.editor))
hl.bind(mod + shift + "Q", hl.dsp.window.close())
hl.bind(mod + shift + ctrl + "Q", hl.dsp.window.kill())
hl.bind(mod + "Escape", hl.dsp.exec_cmd(vars.suspend))

-- Caelestia Misc
create_bind(vars.kbSession, hl.dsp.global("caelestia:session"))
create_bind(vars.kbShowSidebar, hl.dsp.global("caelestia:sidebar"))
create_bind(vars.kbClearNotifs, hl.dsp.global("caelestia:clearNotifs"))
create_bind(vars.kbShowPanels, hl.dsp.global("caelestia:showall"))
create_bind(vars.kbLock, hl.dsp.global("caelestia:lock"))

-- Movement/Windows management
hl.bind(mod + shift + "S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mod + ctrl + "F", hl.dsp.window.float({ action = "toggle", window = "activewindow" }))
hl.bind(
  mod + shift + "M",
  hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle", window = "activewindow" })
)

hl.bind(mod + "H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod + "J", hl.dsp.focus({ direction = "d" }))
hl.bind(mod + "K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod + "L", hl.dsp.focus({ direction = "r" }))

hl.bind(mod + "Tab", hl.dsp.focus({ workspace = "previous_per_monitor" }))
hl.bind(mod + "S", hl.dsp.focus({ workspace = "special:magic" }))

hl.bind(mod + ctrl + "J", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mod + ctrl + "K", hl.dsp.focus({ workspace = "-1" }))

hl.bind(mod + shift + "J", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mod + shift + "K", hl.dsp.window.move({ workspace = "-1" }))

hl.bind(mod + "1", hl.dsp.focus({ workspace = "1" }))
hl.bind(mod + "2", hl.dsp.focus({ workspace = "2" }))
hl.bind(mod + "3", hl.dsp.focus({ workspace = "3" }))
hl.bind(mod + "4", hl.dsp.focus({ workspace = "4" }))
hl.bind(mod + "5", hl.dsp.focus({ workspace = "5" }))

hl.bind(mod + shift + "1", hl.dsp.window.move({ workspace = "1" }))
hl.bind(mod + shift + "2", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mod + shift + "3", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mod + shift + "4", hl.dsp.window.move({ workspace = "4" }))
hl.bind(mod + shift + "5", hl.dsp.window.move({ workspace = "5" }))

hl.bind(mod + "COMMA", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mod + ctrl + "COMMA", hl.dsp.focus({ monitor = "-1" }))
hl.bind(mod + shift + "COMMA", hl.dsp.window.move({ monitor = "+1", window = "activewindow" }))

hl.bind(mod + ctrl + "S", hl.dsp.exec_cmd(vars.screenshot_region_clipboard))
hl.bind(mod + shift + ctrl + "S", hl.dsp.exec_cmd(vars.screenshot_region_to_file))
hl.bind(mod + "F5", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mod + shift + "F5", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mod + ctrl + "F5", hl.dsp.exec_cmd("hyprshot -m output"))

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%-"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"))

hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("wl-copy"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("wl-paste"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("wl-cut"))
