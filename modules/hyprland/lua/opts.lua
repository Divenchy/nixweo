hl.config({
  general = {
    border_size = 2,
    gaps_in = 2,
    gaps_out = 4,
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },
  decoration = {
    rounding = 9,
    active_opacity = 1.0,
    inactive_opacity = 0.5,
    blur = {
      enabled = true,
      noise = 0.0352,
      size = 5,
      passes = 2,
      vibrancy = 0.1856,
    },
  },
  animations = {
    enabled = true,
  },
  binds = {
    allow_workspace_cycles = true,
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

hl.window_rule({
  name = "force_spotify_to_special",
  match = {
    class = "^(Spotify)$",
  },
  workspace = "special:magic",
})
