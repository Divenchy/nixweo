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
  caelestia_launcher = "caelestia shell drawers toggle launcher",
  caelestia_panel = "caelestia shell drawers toggle sidebar",
  caelestia_dash = "caelestia shell drawers toggle dashboard",
  caelestia_toggle = "caelestia shell drawers toggle bar",
  initial_workspace = "sleep 1 && hyprctl dispatch workspace 2",

  -- keybinds
  kbToggleDash = mod .. " + " .. ctrl .. " + D",
  kbToggleBar = mod .. " + " .. ctrl .. " + B",
  kbTogglePanel = mod .. " + " .. ctrl .. " + P",
  kbLock = mod .. " + " .. ctrl .. " + L",
}
