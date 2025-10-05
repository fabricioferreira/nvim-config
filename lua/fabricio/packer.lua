local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- This file can be loaded by calling `lua require('plugins')` from your init.vim
return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  use('BurntSushi/ripgrep')
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use({
    'christianchiarulli/nvcode-color-schemes.vim',
    as = 'nvcode',
    config = function()
      vim.cmd('colorscheme nvcode')
    end
  })

  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
  use('nvim-treesitter/playground')

  use({
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { { "nvim-lua/plenary.nvim" } }
  })
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use('fatih/vim-go', { run = ':GoUpdateBinaries' })

  -- LSP Support
  use({ 'neovim/nvim-lspconfig' })             -- Required
  use({ 'williamboman/mason.nvim' })           -- Optional
  use({ 'williamboman/mason-lspconfig.nvim' }) -- Optional

  -- Autocompletion
  use({ 'hrsh7th/nvim-cmp' })         -- Required
  use({ 'hrsh7th/cmp-nvim-lsp' })     -- Required
  use({ 'hrsh7th/cmp-buffer' })       -- Optional
  use({ 'hrsh7th/cmp-path' })         -- Optional
  use({ 'saadparwaiz1/cmp_luasnip' }) -- Optional
  use({ 'hrsh7th/cmp-nvim-lua' })     -- Optional

  -- Snippets
  use({ 'L3MON4D3/LuaSnip' })             -- Required
  use({ 'rafamadriz/friendly-snippets' }) -- Optional

  -- essential plugins
  use("tpope/vim-surround")
  use("vim-scripts/ReplaceWithRegister")

  -- commenting
  use("numToStr/Comment.nvim")

  -- file explorer
  use("nvim-tree/nvim-tree.lua")

  -- icons
  use("nvim-tree/nvim-web-devicons")

  -- lualine
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true }
  }

  use("jlcrochet/vim-cs")

  -- Formatting
  use {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup()
    end,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    requires = "nvim-lspconfig"
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
