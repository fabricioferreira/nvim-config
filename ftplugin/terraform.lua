-- Terraform-specific keymaps (only loaded for .tf files)
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>ti", ":!terraform init<CR>", opts)
vim.keymap.set("n", "<leader>tv", ":!terraform validate<CR>", opts)
vim.keymap.set("n", "<leader>tp", ":!terraform plan<CR>", opts)
vim.keymap.set("n", "<leader>ta", ":!terraform apply<CR>", opts)
