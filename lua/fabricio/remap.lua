vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)  -- returns to the directory listing

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- in VISUAL, move the entire line below
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- in VISUAL, move the enire line above

vim.keymap.set("n", "Y", "yg$") -- in NORMAL, yank all contents until the end of the line
vim.keymap.set("n", "J", "mzJ`z") -- in NORMAL, copy the line below to the end of the current line

vim.keymap.set("n", "<C-d>", "<C-d>zz") -- in NORMAL, move to the next page keeping cursor at the center
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- in NORMAL, move to the previous page keeping cursor at the center

vim.keymap.set("n", "n", "nzzzv") -- ?
vim.keymap.set("n", "N", "Nzzv") -- ?

-- mode "x" means any mode
vim.keymap.set("x", "<leader>p", "\"_dP") -- paste

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("i", "<C-c>", "<Esc>")
