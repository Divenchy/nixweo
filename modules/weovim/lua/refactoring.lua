local r = require("refactoring")
local rd = require("refactoring.debug")

require("which-key").add({ { "<leader>r", group = "refactor", mode = { "n", "x" } } })
vim.keymap.set({ "n", "x" }, "<leader>rs", function()
  return r.select_refactor()
end, { desc = "Select Refactor" })

vim.keymap.set({ "n", "x" }, "<leader>ri", function()
  return r.inline_var()
end, { expr = true, desc = "Inline Variable" })

vim.keymap.set({ "n", "x" }, "<leader>rf", function()
  return r.extract_func()
end, { expr = true, desc = "Extract Function" })

vim.keymap.set({ "n", "x" }, "<leader>rF", function()
  return r.extract_func_to_file()
end, { expr = true, desc = "Extract Function To File" })

vim.keymap.set({ "n", "x" }, "<leader>rx", function()
  return r.extract_var()
end, { expr = true, desc = "Extract Variable" })

-- Debug helpers
vim.keymap.set("n", "<leader>rP", function()
  return rd.print_loc({ output_location = "below" })
end, { expr = true, desc = "Debug Print Location" })

vim.keymap.set({ "n", "x" }, "<leader>rp", function()
  return rd.print_var({ output_location = "below" }) .. "iw"
end, { expr = true, desc = "Debug Print Variable" })

vim.keymap.set("n", "<leader>rc", function()
  return rd.cleanup({ restore_view = true }) .. "ag"
end, { expr = true, desc = "Debug Cleanup" })
