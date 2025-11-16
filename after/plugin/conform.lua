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
		eruby = { "erb_format" },
	},
	format_on_save = function(bufnr)
		-- Disable format-on-save for filetypes handled by custom formatters
		local custom_formatters = require("fabricio.formatters")
		local filetype = vim.bo[bufnr].filetype
		
		-- Check if this filetype has a custom formatter (handled manually)
	for _, formatter_file in ipairs(vim.fn.glob(vim.fn.stdpath('config') .. '/lua/fabricio/formatters/*.lua', false, true)) do
		local filename = vim.fn.fnamemodify(formatter_file, ':t:r')
		if filename ~= 'init' then
			local ok, config = pcall(require, 'fabricio.formatters.' .. filename)
			-- Require returns `true` when a module doesn't return a table; guard before indexing
			if ok and type(config) == "table" and config.filetype == filetype then
				return -- Disable format-on-save for this filetype
			end
		end
	end
		
		return {
			lsp_fallback = true,
			timeout_ms = 2000,
		}
	end,
	formatters = {
		csharpier = {
			command = "dotnet-csharpier",
			args = { "--write-stdout" },
			stdin = true,
		},
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
  -- Try custom formatters first
  local custom_formatters = require("fabricio.formatters")
  if custom_formatters.format() then
    return
  end
  -- Fall back to Conform
  conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
