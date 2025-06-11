-- Set up completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Configure language servers
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
  capabilities = capabilities,
})

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = 'clippy',
      },
    },
  },
  capabilities = capabilities,
})

vim.lsp.config('eslint', {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  root_markers = { '.eslintrc.js', '.eslintrc.json', '.eslintrc.yaml', '.eslintrc.yml', 'package.json', '.git' },
  settings = {
    eslint = {
      enable = true,
      autoFixOnSave = true,
    },
  },
  capabilities = capabilities,
})

-- Enable the language servers
vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('eslint')

-- Set up nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-s>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
})

-- Set up LSP keymaps when LSP attaches to buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, remap = false }

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- LSP keymaps
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts) -- goto definition
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts) -- show quick description of the selected symbol
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts) -- view workspace symbol
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts) -- view definition on a floating window
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1 }) end, opts) -- goto next diagnostic
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1 }) end, opts) -- goto previous diagnostic
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts) -- view code action
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts) -- search references
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts) -- rename symbol
    vim.keymap.set("n", "<leader>vh", function() vim.lsp.buf.signature_help() end, opts) -- help with the highlighted signature
  end,
})

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

-- Add diagnostic signs
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
