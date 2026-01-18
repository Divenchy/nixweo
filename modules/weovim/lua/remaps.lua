  
vim.keymap.set({ "n", "v", "x" }, "<C-c>", "<Esc>")

-------------- Editing -------------------

---- Yanking/Pasting
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Greatest remap ever pt. 2" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Greatest remap ever pt. 2 (caps ver.)" })

-- Deleting
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "TO THE VOID"})

-- greatest remap ever
-- Paste over
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Greatest remap ever"})

------ Create a new file
vim.keymap.set('n', '<leader>N', function()
  local current_dir = vim.fn.expand('%:p:h')  -- Get directory of current file
  local filename = vim.fn.input('New file: ', current_dir .. '/', 'file')
  if filename ~= '' then
    vim.cmd('edit ' .. filename)
  end
end, { desc = "Create file in current path" })


---- LSP/Format
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {desc = "Lsp Buf Format"})

----- Insert/Normal mode
-- Join lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines"})

-- Stay in insert mode and move to next line
vim.keymap.set('i', '<C-n>', '<C-o>A', { desc = "Move to end"})

-- Replacing/Substituting
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Ez write n save
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Chronic saver huh?"})
vim.keymap.set("n", "<leader>w", ":w!<CR>", { desc = "Force write"})
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "I'M FREEEE!!!!"})
vim.keymap.set("n", "<leader>Q", ":q!<CR>", { desc = "Force quit"})

------ Visual mode
-- Moving lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move whole line down"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move whole line up"})



------------------------ Movement -------------------------

-- Half page movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down"})
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up"})

-- Ez movement between neovim panes
vim.keymap.set("n", "<S-h>", "<C-w><C-h>", {desc = 'Move focus to the left window'})
vim.keymap.set("n", "<S-l>", "<C-w><C-l>", {desc = 'Move focus to the right window'})
vim.keymap.set("n", "<S-j>", "<C-w><C-j>", {desc = 'Move focus to the lower window'})
vim.keymap.set("n", "<S-k>", "<C-w><C-k>", {desc = 'Move focus to the upper window'})

-- Tabs 
vim.keymap.set("n", "H", "gt", { desc = "Move to tab in left" })
vim.keymap.set("n", "L", "gT", { desc = "Move to tab in right" })


-- Going up and down drop dowm menus and stuffz
vim.keymap.set("n", "<C-p>", "<cmd>cprev<CR>zz", { desc = "Menu navigation"})
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz", { desc = "Menu navigation"})
vim.keymap.set("n", "<A-p>", "<cmd>lprev<CR>zz", { desc = "Menu navigation"})
vim.keymap.set("n", "<A-n>", "<cmd>lnext<CR>zz", { desc = "Menu navigation"})

----------------------- Searching -----------------------
-- Easy search n replace
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace every instance of the selected word in the file" }
)

-- Search word
vim.keymap.set("n", "<A-n>", "nzzzv", { desc = "Next in search"})
vim.keymap.set("n", "<A-N>", "Nzzzv", { desc = "prev in search"})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Have highlighting on search, but remove highlighting after escaping
vim.keymap.set('n', '<CR>', '<cmd>nohlsearch<CR>', { desc = "Stop highlighting"})

---------------- Closing neovim --------------
-- Fast quit
vim.keymap.set("n", "<leader>Q", ":q<CR>", { desc = "Quit" })

----------------- Miscellaneous -----------------
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "chmodding" })

