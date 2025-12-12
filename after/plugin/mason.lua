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
    'kotlin_language_server',
    'jdtls',
    'ts_ls',
    'svelte',
    'terraformls',
  },
  automatic_installation = true,
})
