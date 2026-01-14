return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({
      settings = {
        save_on_toggle = true,
      },
    })

    -- Remaps
    vim.keymap.set("n", "<A-l>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end)
    vim.keymap.set("n", "<A-1>", function()
      harpoon:list():select(1)
    end)
    vim.keymap.set("n", "<A-2>", function()
      harpoon:list():select(2)
    end)
    vim.keymap.set("n", "<A-3>", function()
      harpoon:list():select(3)
    end)
    vim.keymap.set("n", "<A-4>", function()
      harpoon:list():select(4)
    end)
    vim.keymap.set("n", "<A-5>", function()
      harpoon:list():select(5)
    end)
    vim.keymap.set("n", "<A-6>", function()
      harpoon:list():select(6)
    end)
    vim.keymap.set("n", "<A-7>", function()
      harpoon:list():select(7)
    end)
    vim.keymap.set("n", "<A-8>", function()
      harpoon:list():select(8)
    end)
    vim.keymap.set("n", "<A-9>", function()
      harpoon:list():select(9)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    -- Remaps
    vim.keymap.set("n", "<C-.>", function()
      harpoon:list():prev()
    end)
    vim.keymap.set("n", "<C-,>", function()
      harpoon:list():next()
    end)
  end,
}