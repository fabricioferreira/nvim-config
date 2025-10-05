local ok, conform = pcall(require, "conform")

if not ok then
	return
end

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		cs = { "csharpier" },
		rust = { "rustfmt", lsp_format = "fallback" },
		go = { "goimports", "gofmt" },
		svelte = { "prettier-plugin-svelte" },
		css = { "prettier" },
		html = { "prettier" },
		typescript = { "prettier" },
	},
	format_on_save = {
		lsp_fallback = true,
		timeout_ms = 2000,
	},
	formatters = {
		csharpier = {
			command = "dotnet-csharpier",
			args = { "--write-stdout" },
			stdin = true,
		},
	},
})

vim.keymap.set({ "", "n", "v" }, "<leader>f", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
