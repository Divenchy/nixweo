local mod = "SUPER"
local shift = "SHIFT"
local ctrl = "CTRL"
local alt = "ALT"

return {
  -- default apps
  terminal = "wezterm",
  file_manager = "luciole",
  editor = "emacs",
  browser = "zen-beta",

  -- cmds
  suspend = "systemctl suspend",
  screenshot_region_clipboard = 'grim -g "$(slurp)" - | wl-copy',
  screenshot_region_to_file = 'grim -g "$(slurp)" $(HOME)/$(date + "%Y-%m-%d-%H%M%S.png")',
  noctalia_init = "noctalia",
  noctalia_launcher = "noctalia msg panel-toggle launcher",
  noctalia_panel = "noctalia msg panel-toggle control-center",
  noctalia_settings = "noctalia msg settings-toggle",
  noctalia_toggle = "noctalia msg bar-toggle",
  noctalia_lock = "noctalia msg session lock",
  initial_workspace = "sleep 1 && hyprctl dispatch workspace 2",

  -- keybinds
  kbToggleSettings = mod .. " + " .. ctrl .. " + D",
  kbToggleBar = mod .. " + " .. ctrl .. " + B",
  kbTogglePanel = mod .. " + " .. ctrl .. " + P",
  kbLock = mod .. " + " .. ctrl .. " + L",
}
