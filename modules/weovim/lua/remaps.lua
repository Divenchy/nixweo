vim.keymap.set({ "n", "v", "x" }, "<C-c>", "<Esc>")

-------------- Editing -------------------

---- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

---- Yanking/Pasting
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Greatest remap ever pt. 2" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Greatest remap ever pt. 2 (caps ver.)" })

-- Deleting
vim.keymap.set({ "n", "v" }, "<leader>D", [["_d]], { desc = "TO THE VOID" })

-- greatest remap ever
-- Paste over
vim.keymap.set("x", "<leader>P", [["_dP]], { desc = "Greatest remap ever" })

------ Create a new file
vim.keymap.set("n", "<leader>N", function()
	local current_dir = vim.fn.expand("%:p:h") -- Get directory of current file
	local filename = vim.fn.input("New file: ", current_dir .. "/", "file")
	if filename ~= "" then
		vim.cmd("edit " .. filename)
	end
end, { desc = "Create file in current path" })

---- LSP/Format
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Lsp Buf Format" })

----- Insert/Normal mode
-- Join lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

-- Stay in insert mode and move to next line
vim.keymap.set("i", "<C-n>", "<C-o>A", { desc = "Move to end" })

-- Replacing/Substituting
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

-- Ez write n save
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Chronic saver huh?" })
vim.keymap.set("n", "<leader>w", ":w!<CR>", { desc = "Force write" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "I'M FREEEE!!!!" })
vim.keymap.set("n", "<leader>Q", ":q!<CR>", { desc = "Force quit" })

------ Visual mode
-- Moving lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move whole line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move whole line up" })

------------------------ Movement -------------------------

-- Half page movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

-- Ez movement between neovim panes
vim.keymap.set("n", "<A-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<A-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<A-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<A-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Going up and down drop down menus and stuffz
vim.keymap.set("n", "<C-p>", "<cmd>cprev<CR>zz", { desc = "Menu navigation" })
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz", { desc = "Menu navigation" })
vim.keymap.set("n", "<A-p>", "<cmd>lprev<CR>zz", { desc = "Menu navigation" })
vim.keymap.set("n", "<A-n>", "<cmd>lnext<CR>zz", { desc = "Menu navigation" })

---- Harpooon
local harpoon = require("harpoon")
vim.keymap.set("n", "<C-l>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)
vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
-- Remaps
vim.keymap.set("n", "<C-A-P>", function()
	harpoon:list():prev()
end)
vim.keymap.set("n", "<C-A-N>", function()
	harpoon:list():next()
end)

----------------------- Searching -----------------------
-- Easy search n replace
vim.keymap.set(
	"n",
	"<leader>S",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace every instance of the selected word in the file" }
)

-- Search word
vim.keymap.set("n", "<A-n>", "nzzzv", { desc = "Next in search" })
vim.keymap.set("n", "<A-N>", "Nzzzv", { desc = "prev in search" })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Have highlighting on search, but remove highlighting after escaping
vim.keymap.set("n", "<CR>", "<cmd>nohlsearch<CR>", { desc = "Stop highlighting" })

---------------- Closing neovim --------------
-- Fast quit
vim.keymap.set("n", "<leader>Q", ":q<CR>", { desc = "Quit" })

-- Close a buffer
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Quit current buffer" })
----------------- Miscellaneous -----------------
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "chmodding" })

------------- Telescope ------------------
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "[P]roject [F]iles search" })
vim.keymap.set("n", "<leader>pg", builtin.git_files, { desc = "[P]roject [G]it Files search" })
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "[P]roject [S]earch word" })
vim.keymap.set("n", "<leader>pl", builtin.live_grep, { desc = "[P]roject [l]ive grep" })
vim.keymap.set("n", "<leader>pr", builtin.oldfiles, { desc = "[P]roject [R]ecent files" })
vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "[V]iew [H]elp tags" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
