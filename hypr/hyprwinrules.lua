hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

hl.window_rule({
  name = "batteruUI",
  match = { title = "BatteryUI" },
  size = { "30%", "30%" },
  move = { "83%", "30" },
  float = true,
})

hl.window_rule({
  name = "calendar",
  match = { title = "Calendar" },
  size = { "19%", "55%" },
  move = { "81%", "30" },
  float = true,
})

hl.window_rule({
  name = "blueman-manager",
  match = { class = "blueman-manager" },
  float = true,
  size = { "30%", "30%" },
  move = { "68%", "30" },
})

hl.window_rule({
  name = "nwg-look",
  match = { title = "nwg-look" },
  float = true,
})

hl.window_rule({
  name = "volume-control",
  match = { title = "Volume Control" },
  float = true,
  move = { "70%", "30" },
  size = { "25%", "30%" },
})

hl.window_rule({
  name = "picture-in-picture",
  match = { title = "Picture-in-Picture" },
  float = true,
})

hl.window_rule({
  name = "fira-sim",
  match = { class = "FIRASim - [Simulator]" },
  float = true,
  size = { "60%", "75%" },
})

hl.window_rule({
  name = "rviz",
  match = { title = "RViz" },
  float = true,
  size = { "50%", "50%" },
})

hl.window_rule({
  name = "nautilus",
  match = { class = "org.gnome.Nautilus" },
  float = true,
  size = { "60%", "60%" },
})
