# Fabricio's Neovim Configuration

This setup lives in `~/.config/nvim` and is loaded from `init.lua`, which simply requires the `fabricio` module. The layout follows the common `lua/` and `after/plugin/` structure so individual responsibilities stay organized.

## Layout

- `init.lua` → requires the Lua module that bootstraps the rest of the config.
- `lua/fabricio/`
  - `init.lua` → pulls in remaps, options, and plugin definitions.
  - `remap.lua` → all custom key bindings.
  - `set.lua` → editor options (UI, tabs, search, undo, etc.).
  - `packer.lua` → plugin list and bootstrap logic.
  - `formatters/` → custom formatter implementations.
    - `init.lua` → Generic formatter system that auto-registers formatters.
    - `ruby.lua` → Ruby formatter using rubyfmt (opinionated, minimal config).
- `after/plugin/` → per-plugin configuration (telescope, nvim-tree, lualine, LSP, conform, etc.).

## Plugin Management

Packer installs itself on first load (`lua/fabricio/packer.lua`) and manages the plugin collection. Run `:PackerSync` after editing the plugin list.

Highlighted plugins:

- **UI & Navigation**: `nvcode` colorscheme, `nvim-tree`, `nvim-web-devicons`, `nvim-lualine/lualine.nvim`, `harpoon` (branch harpoon2), `undotree`.
- **Search**: `telescope.nvim` (v0.1.8) with the FZF native extension and `ripgrep`.
- **Editing**: `Comment.nvim`, `vim-surround`, `ReplaceWithRegister`.
- **Syntax & Trees**: `nvim-treesitter` with parsers for C, C#, CSS, Go, HTML, JavaScript, Lua, Markdown (including inline), Rust, Svelte, TypeScript, Vimscript; `nvim-treesitter/playground`; `jlcrochet/vim-cs` for C# helpers; `evanleck/vim-svelte` for Svelte support.
- **Git**: `vim-fugitive`.
- **Language Tools**: `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, completion stack (`nvim-cmp`, `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp-nvim-lua`, `cmp_luasnip`), snippets (`LuaSnip`, `friendly-snippets`).
- **Formatting**: `stevearc/conform.nvim` with language-specific formatters.
- **Go**: `fatih/vim-go` (runs `:GoUpdateBinaries` on install).

## Core Options (`lua/fabricio/set.lua`)

- Block cursor for normal modes, thin cursor for insert (`guicursor`).
- Relative + absolute line numbers, highlighted cursorline, `colorcolumn = 120`.
- Tabs expand to two spaces; smart indent with no soft wrap.
- Termguicolors on, dark background, persistent sign column, extended filename chars (`isfname += @-@`).
- Clipboard integrates with system register (`unnamedplus`); backspace works across indents/EOL.
- Splits favor the right/bottom for new windows.
- Swap/backup disabled; undo history stored in `~/.vim/undodir` (cross-platform compatible with HOME/USERPROFILE).
- Search ignores case unless uppercase appears, no highlight search (`hlsearch = false`), incremental search enabled, centered scrolling (`scrolloff = 8`, `updatetime = 50`).

## Key Mappings (`lua/fabricio/remap.lua`)

Leader is `<Space>`. Selected highlights:

- **Explorer**: `<leader>pv` (netrw), `<leader>e` (toggle NvimTree), `<leader>ef` (focus tree), `<leader>vb` enters visual block mode quickly.
- **Telescope**: `<leader>ff` (find files), `<C-p>` (git files), `<leader>fs` (live grep), `<leader>ps` (prompted grep).
- **Window/Tab control**: `<leader>sv` (split vertical), `<leader>sh` (split horizontal), `<leader>se` (equal splits), `<leader>sx` (close split), `<leader>to` (new tab), `<leader>tx` (close tab), `<leader>tn` (next tab), `<leader>tp` (previous tab).
- **Harpoon**: `<leader>a` (add file), `<C-e>` (toggle quick menu or Telescope picker), `<C-h/j/k/l>` (select slots 1-4), `<C-S-P/N>` (cycle prev/next).
- **Undo tree**: `<leader>u`.
- **Terminal**: `<leader>term` (open terminal in insert mode).
- **Clipboard helpers**: `<leader>p` (paste without clobber in visual/select mode), `<leader>y`/`<leader>Y` (yank to system clipboard), `<C-c>` (exit insert mode), `Y` (yank to end of line).
- **Formatting**: `<leader>f` (Conform with LSP fallback).
- **Git**: `<leader>gs` (Git status), `<leader>diff` (Git diff split).
- **Testing**: `<leader>ur` (run RSpec on current file - Ruby files only).
- **Movement tweaks**: `J`/`K` in visual mode move lines up/down, `<C-d>/<C-u>` keep cursor centered, `n`/`N` keep search results centered, `J` in normal mode joins lines without moving cursor.

## Colors & UI

`after/plugin/colors.lua` sets the `nvcode` colorscheme and forces transparent backgrounds for Normal and NormalFloat highlights. NvimTree auto-scrolls to the current buffer on entry (`BufEnter` autocmd), highlights opened files, and shows modified file icons. Lualine uses a customized Nightfly palette with custom colors for normal (blue), insert (green), visual (violet), and command (yellow) modes (`after/plugin/lua-line.lua`).

## Treesitter

`after/plugin/treesitter.lua` ensures installation of parsers for C, C#, CSS, Go, HTML, JavaScript, Lua, Markdown (including inline), Rust, Svelte, TypeScript, and Vimscript. Auto-install is enabled for missing parsers. Highlighting and indentation support are enabled, with `additional_vim_regex_highlighting` disabled for performance.

## Language Servers & Completion

`after/plugin/lsp.lua` uses the native `vim.lsp.config` and `vim.lsp.enable` APIs with capabilities from `cmp_nvim_lsp`. Servers enabled on startup:

- `lua_ls` with LuaJIT runtime, Neovim runtime library, and telemetry disabled.
- `rust_analyzer` with `allFeatures = true` and `clippy` checks on save.
- `eslint` for JavaScript/TypeScript with auto-fix on save enabled.
- `svelte` with support for svelte config files.

An OmniSharp configuration is provided but **not enabled** by default. It expects `~/.local/omnisharp/OmniSharp` and can be enabled by adding `vim.lsp.enable('omnisharp')` once the binary is present.

Completion is handled by `nvim-cmp` with LuaSnip and buffer/path/nvim_lua sources. Completion mappings include:
- `<C-p>/<C-n>` - navigate items
- `<C-s>`, `<CR>`, `<Tab>` - confirm selection
- `<C-Space>` - trigger completion
- `<C-d>/<C-f>` - scroll docs
- `<C-e>` - close completion

The LSP attach autocmd (`LspAttach`) wires buffer-local keymaps:
- `gd` - goto definition
- `K` - hover documentation
- `<leader>vws` - workspace symbol search
- `<leader>vd` - open diagnostic float
- `[d`/`]d` - jump to next/previous diagnostic
- `<leader>vca` - code actions
- `<leader>vrr` - find references
- `<leader>vrn` - rename symbol
- `<leader>vh` - signature help
- `<leader>vcf` - format with Conform (LSP fallback)

Diagnostics display virtual text, signs, underlines with custom Nerd Font icons (Error: 󰅚, Warn: 󰀪, Hint: 󰌶, Info: ).

## Mason & Formatting

`after/plugin/mason.lua` auto-installs language servers for `lua_ls`, `rust_analyzer`, `eslint`, `csharp_ls`, `gopls`, `ts_ls`, and `svelte` with automatic installation enabled. Update the list if you prefer OmniSharp over `csharp_ls`.

`after/plugin/conform.lua` configures formatters by filetype:

- **Lua**: `stylua`
- **C#**: `csharpier` (using `dotnet-csharpier` command)
- **Rust**: `rustfmt`
- **Go**: `goimports` + `gofmt`
- **Svelte/CSS/HTML/JS/TS**: `prettier` (searches for plugins in project root, detects project via package.json, lock files, or svelte.config files)
- **Ruby**: `rubyfmt` (via custom formatter system, opinionated formatter with minimal config)
- **ERB**: `erb_format`

Format on save is enabled for all languages except Ruby (which uses manual formatting only) with LSP fallback and 2-second timeout. `<leader>f` and `<leader>vcf` trigger manual formatting - they first check for custom formatters (defined in `lua/fabricio/formatters/`), then fall back to Conform with LSP fallback. The custom formatter system auto-registers all formatter configurations on startup.

## Notes

- `vim.opt.clipboard` append assumes Neovim is built with clipboard support.
- The nvcode colorscheme is set directly in `after/plugin/colors.lua` with transparent backgrounds.
- Update the OmniSharp path in `after/plugin/lsp.lua` if the binary lives elsewhere (note: there's a typo in the path using `˜` instead of `~`), and ensure the executable is marked as runnable. You'll need to manually enable it with `vim.lsp.enable('omnisharp')`.
- Conform expects these binaries on your `PATH`: `stylua`, `dotnet-csharpier`, `rustfmt`, `goimports`, `gofmt`, `prettier`, and `erb_format`.
- Custom formatters expect: `rubyfmt` for Ruby formatting. Note: `rubyfmt` is opinionated and doesn't support `.rubocop.yml` configuration.
- To add a new custom formatter, create a new file in `lua/fabricio/formatters/` that returns a table with `filetype`, `command`, `name`, and optionally `args` fields. It will be auto-registered on startup.
- Harpoon uses version 2 (harpoon2 branch) with both quick menu (`<C-E>`) and Telescope integration (`<C-e>`).
- Comment.nvim is enabled with default settings for easy code commenting.

Use this README as a quick refresher after loading the repository to understand where everything lives and which shortcuts are available.
