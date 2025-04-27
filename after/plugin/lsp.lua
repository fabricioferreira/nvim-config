local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.ensure_installed({
	'eslint',
	'lua_ls',
	'rust_analyzer',
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select), -- CTRL+p - select previous item from the LSP suggestion list
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select), -- CTRL+n - next item
	['<C-s>'] = cmp.mapping.confirm({ select = true }), -- CTRL+s - confirms selection
	["<C-Space>"] = cmp.mapping.complete(), -- CTRL+space - complete selection
})


lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts) -- goto definition
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts) -- show quick description of the selected symbol
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts) -- view workspace symbol
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts) -- view definition on a floating window
	vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1}) end, opts) -- goto next diagnostic
	vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1}) end, opts) -- goto previous diagnostic
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts) -- view code action
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts) -- search references
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts) -- rename symbol
	vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts) -- help with the highlighted signature

end)

lsp.setup()
