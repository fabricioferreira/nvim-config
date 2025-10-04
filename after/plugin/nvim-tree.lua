local setup, nvimtree = pcall(require, "nvim-tree")

if not setup then
    return
end

local api = require("nvim-tree.api");

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

nvimtree.setup()

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.fn.bufname(vim.fn.bufnr()) ~= "NVimTree_1" then
      api.tree.find_file({ buf = vim.fn.bufnr() })
    end
  end,
  nested = true
})
