local flit = require("flit")

flit.setup({
	labeled_modes = "nx",
	keys = { f = "f", F = "F", t = "t", T = "T" },
	multiline = true,
	opts = {},
})

-- Set up keymaps for f, F, t, T
local modes = { "n", "x", "o" }
for _, key in ipairs({ "f", "F", "t", "T" }) do
	vim.keymap.set(modes, key, function()
		require("flit").jump(key)
	end, { desc = "Flit " .. key })
end
