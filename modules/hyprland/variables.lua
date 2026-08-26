local mod = "SUPER"
local shift = "SHIFT"
local ctrl = "CTRL"
local alt = "ALT"

return {
  -- default apps
  terminal = "wezterm",
  file_manager = "dolphin",
  editor = "emacs",
  browser = "firefox",

  -- cmds
  suspend = "systemctl suspend",
  screenshot_region_clipboard = 'grim -g "$(slurp)" - | wl-copy',
  screenshot_region_to_file = 'grim -g "$(slurp)" $(HOME)/$(date + "%Y-%m-%d-%H%M%S.png")',
  caelestia_init = "sleep 2 && caelestia-shell -d",
  initial_workspace = "sleep 1 && hyprctl dispatch workspace 2",

  -- keybinds
  kbSession = mod .. " + " .. ctrl .. " + " .. alt .. " + S",
  kbShowSidebar = mod .. " + " .. ctrl .. " + " .. alt .. " + E",
  kbClearNotifs = mod .. " + " .. ctrl .. " + " .. alt .. " + N",
  kbShowPanels = mod .. " + " .. ctrl .. " + " .. alt .. " + P",
  kbLock = mod .. " + " .. ctrl .. " + L",
}
