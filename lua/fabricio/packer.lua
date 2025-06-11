-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only  required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  use('BurntSushi/ripgrep')
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({
	  'rose-pine/neovim',
	  as = 'rose-pine',
	  config = function()
		  vim.cmd('colorscheme rose-pine')
	  end
  })

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/playground')
 
  use ({
	  "ThePrimeagen/harpoon",
	  branch = "harpoon2",
	  requires = { {"nvim-lua/plenary.nvim"} }
  })
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use('fatih/vim-go', {run=':GoUpdateBinaries'})

  -- LSP Support
  use({'neovim/nvim-lspconfig'})             -- Required
  use({'williamboman/mason.nvim'})           -- Optional
  use({'williamboman/mason-lspconfig.nvim'}) -- Optional

  -- Autocompletion
  use({'hrsh7th/nvim-cmp'})         -- Required
  use({'hrsh7th/cmp-nvim-lsp'})     -- Required
  use({'hrsh7th/cmp-buffer'})       -- Optional
  use({'hrsh7th/cmp-path'})         -- Optional
  use({'saadparwaiz1/cmp_luasnip'}) -- Optional
  use({'hrsh7th/cmp-nvim-lua'})     -- Optional

  -- Snippets
  use({'L3MON4D3/LuaSnip'})             -- Required
  use({'rafamadriz/friendly-snippets'}) -- Optional

end)
