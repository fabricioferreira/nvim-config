# Fabricio's Neovim Configuration

This setup lives in `~/.config/nvim` and is loaded from `init.lua`, which simply requires the `fabricio` module. The layout follows the common `lua/` and `after/plugin/` structure so individual responsibilities stay organized.

## Layout

- `init.lua` → requires the Lua module that bootstraps the rest of the config.
- `lua/fabricio/`
  - `init.lua` → pulls in remaps, options, and plugin definitions.
  - `remap.lua` → all custom key bindings.
  - `set.lua` → editor options (UI, tabs, search, undo, etc.).
  - `packer.lua` → plugin list and bootstrap logic.
- `after/plugin/` → per-plugin configuration (telescope, nvim-tree, lualine, LSP, conform, etc.).

## Plugin Management

Packer installs itself on first load (`lua/fabricio/packer.lua`) and manages the plugin collection. Run `:PackerSync` after editing the plugin list.

Highlighted plugins:

- **UI & Navigation**: `nvcode` colorscheme, `nvim-tree`, `nvim-web-devicons`, `nvim-lualine/lualine.nvim`, `harpoon`, `undotree`.
- **Search**: `telescope.nvim` with the FZF native extension and `ripgrep`.
- **Editing**: `Comment.nvim`, `vim-surround`, `ReplaceWithRegister`.
- **Syntax & Trees**: `nvim-treesitter` with parsers for C, C#, CSS, Go, HTML, JS/TS, Lua, Markdown, Rust, Svelte, Vimscript; `jlcrochet/vim-cs` for C# helpers.
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
- Swap/backup disabled; undo history stored in `~/.vim/undodir`.
- Search ignores case unless uppercase appears, incremental highlight, centered scrolling (`scrolloff = 8`, `updatetime = 50`).

## Key Mappings (`lua/fabricio/remap.lua`)

Leader is `<Space>`. Selected highlights:

- Explorer: `<leader>pv` (netrw), `<leader>e` (toggle NvimTree), `<leader>ef` (focus tree), `<leader>vb` enters visual block mode quickly.
- Telescope: `<leader>ff` (files), `<C-p>` (git files), `<leader>fs` (live grep), `<leader>ps` (prompted grep).
- Window/Tab control: `<leader>sv`, `<leader>sh`, `<leader>se`, `<leader>sx`, `<leader>to`, `<leader>tx`, `<leader>tn`, `<leader>tp`.
- Harpoon: `<leader>a` add, `<C-e>` toggle Telescope picker, `<C-h/j/k/l>` quick slots, `<C-S-P/N>` cycle the list.
- Undo tree: `<leader>u`; terminal: `<leader>term`.
- Clipboard helpers: `<leader>p` (paste without clobber), `<leader>y`/`<leader>Y`, `<C-c>` exits insert mode.
- Formatting: `<leader>f` (Conform) and `<leader>vcf` (Conform with LSP fallback) reformat the current buffer.
- Git: `<leader>gs` (status), `<leader>diff` (diff split).
- Movement tweaks: `J`/`K` in visual mode move lines, `<C-d>/<C-u>` keep cursor centered, `n`/`N` keep search results centered, `J` in normal mode joins lines without moving the cursor.

## Colors & UI

`after/plugin/colors.lua` defines a `ColorMyPencils` helper and defaults to the `nvcode` theme while forcing transparent backgrounds. NvimTree auto-scrolls to the current buffer on entry. Lualine uses a customized Nightfly palette (`after/plugin/lua-line.lua`).

## Treesitter

`after/plugin/treesitter.lua` installs and enables language parsers, incremental highlighting, and indentation support. Missing parsers auto-install when `tree-sitter` CLI is available.

## Language Servers & Completion

`after/plugin/lsp.lua` uses the native `vim.lsp.config` API with capabilities from `cmp_nvim_lsp`. Servers enabled on startup:

- `lua_ls` with LuaJIT runtime defaults and Neovim runtime library.
- `rust_analyzer` with `allFeatures = true` and `clippy` checks on save.
- `eslint` for JavaScript/TypeScript (auto-fix on save).
- `svelte`.

An OmniSharp definition is provided as well; it expects `~/.local/omnisharp/OmniSharp` and can be enabled once that binary is present (either add `vim.lsp.enable('omnisharp')` or start it manually).

Completion is handled by `nvim-cmp` with LuaSnip and buffer/path sources. The LSP attach autocmd wires buffer-local keymaps for definition lookup (`gd`), hover (`K`), diagnostics (`[d`/`]d`, `<leader>vd`), code actions (`<leader>vca`), rename (`<leader>vrn`), formatting (`<leader>vcf`), etc. Diagnostics show virtual text, signs, underlines, and custom Nerd Font icons.

## Mason & Formatting

`after/plugin/mason.lua` auto-installs toolchains for `lua_ls`, `rust_analyzer`, `eslint`, `csharp_ls`, `gopls`, `ts_ls`, and `svelte`. Update the list if you prefer OmniSharp over `csharp_ls`.

`after/plugin/conform.lua` wires formatters:

- `stylua`, `csharpier`, `rustfmt`, `goimports` + `gofmt`, Prettier for Svelte and the broader JS/TS/CSS/HTML stack (runs from the project root so local plugins like `prettier-plugin-svelte` are picked up automatically).
- `<leader>f` uses Conform directly; `<leader>vcf` invokes the same formatter, falling back to LSP when Prettier is unavailable.

## Notes

- `vim.opt.clipboard` append assumes Neovim is built with clipboard support.
- `ColorMyPencils()` can be called manually with another colorscheme name.
- Update the OmniSharp path in `after/plugin/lsp.lua` if the binary lives elsewhere, and ensure the executable is marked as runnable.
- Conform expects `dotnet-csharpier`, `goimports`, and `prettier` binaries to be available on your `PATH`.

Use this README as a quick refresher after loading the repository to understand where everything lives and which shortcuts are available.
