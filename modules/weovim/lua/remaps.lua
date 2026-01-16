  
vim.keymap.set({ "n", "v", "x" }, "<C-c>", "<Esc>")

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Greatest remap ever pt. 2" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Greatest remap ever pt. 2 (caps ver.)" })

-- Easy search n replace
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace every instance of the selected word in the file" }
)

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Fast quit
vim.keymap.set("n", "<leader>Q", ":q<CR>", { desc = "Quit" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
