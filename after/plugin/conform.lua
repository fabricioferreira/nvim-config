local ok, conform = pcall(require, "conform")
local util = ok and require("conform.util")

if not ok then
  return
end

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		cs = { "csharpier" },
		rust = { "rustfmt" },
		go = { "goimports", "gofmt" },
		svelte = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		typescript = { "prettier" },
		javascript = { "prettier" },
		typescriptreact = { "prettier" },
		javascriptreact = { "prettier" },
		ruby = { "rubocop" },
		eruby = { "erb_format" },
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
		rubocop = require("fabricio.formatters.rubocop"),
		prettier = {
			prepend_args = { "--plugin-search-dir=." },
			cwd = util.root_file({
				"package.json",
				"pnpm-workspace.yaml",
				"pnpm-lock.yaml",
				"yarn.lock",
				"package-lock.json",
				"bun.lockb",
				"svelte.config.js",
				"svelte.config.cjs",
				"svelte.config.ts",
				"node_modules",
			}),
		},
	},
})

vim.keymap.set({ "", "n", "v" }, "<leader>f", function()
  conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
