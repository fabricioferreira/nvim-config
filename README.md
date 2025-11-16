# Fabricio's Neovim Configuration

This setup lives in `~/.config/nvim` and is loaded from `init.lua`, which simply requires the `fabricio` module. The layout follows the common `lua/` and `after/plugin/` structure so individual responsibilities stay organized.

## Layout

- `init.lua` → requires the Lua module that bootstraps the rest of the config.
- `lua/fabricio/`
  - `init.lua` → pulls in remaps, options, plugins, and formatter bootstrap.
  - `remap.lua` → all custom key bindings.
  - `set.lua` → editor options (UI, tabs, search, undo, etc.).
  - `packer.lua` → plugin list and bootstrap logic.
  - `formatters/` → custom formatter implementations.
    - `init.lua` → generic formatter system that auto-registers modules in this directory.
    - `ruby.lua` → commented example showing how to register `rubyfmt`.
- `after/plugin/` → per-plugin configuration (telescope, nvim-tree, lualine, LSP, conform, etc.).
- `ftplugin/java.lua` → on-attaching Java helper that configures `jdtls` for Gradle/Maven/git projects.

## Plugin Management

Packer installs itself on first load (`lua/fabricio/packer.lua`) and manages the plugin collection. Run `:PackerSync` after editing the plugin list.

Highlighted plugins:

- **UI & Navigation**: `nvcode` colorscheme, `nvim-tree`, `nvim-web-devicons`, `nvim-lualine/lualine.nvim`, `harpoon` (harpoon2 branch), `undotree`.
- **Search**: `telescope.nvim` (tag `0.1.8`) with the FZF native extension and `ripgrep`.
- **Editing**: `Comment.nvim`, `vim-surround`, `ReplaceWithRegister`.
- **Syntax & Trees**: `nvim-treesitter` (plus `playground`), `jlcrochet/vim-cs`, `evanleck/vim-svelte`.
- **Git**: `vim-fugitive`.
- **Language Tools**: `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, completion stack (`nvim-cmp`, `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp-nvim-lua`, `cmp_luasnip`), snippets (`LuaSnip`, `friendly-snippets`), Java tooling (`mfussenegger/nvim-jdtls`), Kotlin/extra sources (`nvimtools/none-ls.nvim`), and Lua dev helpers (`folke/neodev.nvim`).
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

`after/plugin/lsp.lua` uses the native `vim.lsp.config` + `vim.lsp.enable` APIs with capabilities from `cmp_nvim_lsp`. Servers explicitly configured:

- `lua_ls` with LuaJIT runtime, Neovim runtime library exposure, and telemetry disabled.
- `rust_analyzer` with `allFeatures = true` and `clippy` on save.
- `eslint` with auto-fix on save enabled for the JS/TS family.
- `svelte`.
- `ruby_lsp`.
- `omnisharp` (configured but **not enabled**; supply the binary—`~/.local/share/nvim/mason/bin/OmniSharp` on macOS—and call `vim.lsp.enable('omnisharp')` if you want it).

The config also calls `vim.lsp.enable('jdtls')` and `vim.lsp.enable('kotlin_language_server')`, leaning on their default setups. Java buffers receive extra setup via `ftplugin/java.lua`, which builds the `jdtls` command and workspace path using project roots (`gradlew`, `mvnw`, `pom.xml`, `.git`). Update the launcher path there if Mason ships a JAR with a different version string.

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

`after/plugin/mason.lua` auto-installs language servers for `lua_ls`, `rust_analyzer`, `eslint`, `csharp_ls`, `gopls`, `kotlin_language_server`, `jdtls`, `ts_ls`, and `svelte`, keeping automatic installation enabled. Adjust the list if you prefer OmniSharp over `csharp_ls` or need additional tooling.

`after/plugin/conform.lua` configures formatters by filetype:

- **Lua**: `stylua`
- **C#**: `csharpier` (`dotnet-csharpier --write-stdout`)
- **Rust**: `rustfmt`
- **Go**: `goimports` + `gofmt`
- **Svelte/CSS/HTML/JS/TS/React variants**: `prettier` (searches for plugins in the project root via package/lock files or Svelte config files)
- **ERB**: `erb_format`

Format on save is enabled with Conform (LSP fallback, 2s timeout). Before Conform runs, the custom formatter framework (`lua/fabricio/formatters/`) is consulted: if it formats successfully the rest is skipped. The repo currently only includes the commented `ruby.lua` example, so no custom formatter is active until you add one. `<leader>f` and `<leader>vcf` share the same logic—custom formatter first, then Conform, finally LSP if required.

## Notes

- `vim.opt.clipboard` append assumes Neovim is built with clipboard support.
- The nvcode colorscheme is set directly in `after/plugin/colors.lua` with transparent backgrounds.
- Update the OmniSharp path in `after/plugin/lsp.lua` if the binary lives elsewhere, ensure it's executable, and call `vim.lsp.enable('omnisharp')` once present.
- Conform expects these binaries on your `PATH`: `stylua`, `dotnet-csharpier`, `rustfmt`, `goimports`, `gofmt`, `prettier`, and `erb_format`.
- Custom formatter modules should return `{ filetype, command, name?, args? }` and live under `lua/fabricio/formatters/`; they register automatically during startup.
- Harpoon uses version 2 (harpoon2 branch) with both quick menu (`<C-E>`) and Telescope integration (`<C-e>`).
- Comment.nvim is enabled with default settings for easy code commenting.

Use this README as a quick refresher after loading the repository to understand where everything lives and which shortcuts are available.
