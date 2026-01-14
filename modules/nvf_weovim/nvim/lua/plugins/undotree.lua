return {
  "mbbill/undotree",
  config = function()
    vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Undotree Toggle" })
  end,
}