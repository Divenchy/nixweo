-- "easeOutQuint,0.23,1,0.32,1"
-- "easeInOutCubic,0.65,0.05,0.36,1"
-- "linear,0,0,1,1"
-- "almostLinear,0.5,0.5,0.75,1.0"
-- "quick,0.15,0,0.1,1"

-- transition: all 0.6s cubic-bezier(0.84, 0.01, 0.62, 0.95);
hl.curve("weo_bezier", { type = "bezier", points = { { 0.84, 0.01 }, { 0.62, 0.95 } } })

hl.curve("overshoot", { type = "bezier", points = { { 0.5, 0.9 }, { 0.1, 1.1 } } })
hl.curve("rubber", { type = "spring", mass = 1, stiffness = 70, dampening = 10 })

hl.animation({ leaf = "global", enabled = true, speed = 8, curve = "weo_bezier", style = "slidefade 20%" })
hl.animation({ leaf = "border", enabled = true, speed = 8, curve = "rubber", style = "slide" })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "weo_bezier", style = "slide" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 8, curve = "overshoot", style = "slide" })
hl.animation({ leaf = "fade", enabled = 0 })
