require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

local mason_config = require('mason-lspconfig')

mason_config.setup({
    ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'eslint',
        'csharp_ls',
        'gopls',
        'ts_ls',
        'svelte',
        'ruby_lsp',
    },
    automatic_installation = true,
})
