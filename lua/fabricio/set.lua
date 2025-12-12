vim.hl.priorities.semantic_tokens = 95

vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.opt.nu = true

-- linue numbers
vim.o.relativenumber = true
vim.opt.number = true
vim.o.numberwidth = 4


-- tabstops
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- indentation
vim.o.autoindent = true
vim.o.smartindent = true

vim.o.showmode = false
vim.o.showtabline = 1
vim.o.pumheight = 10
vim.o.cmdheight = 1

vim.o.smartcase = true
vim.o.completeopt = "menuone,noselect"

vim.opt.wrap = false
vim.opt.cursorline = true

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard:append("unnamedplus")

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.swapfile = false
vim.opt.backup = false
print(os.getenv("HOME") or os.getenv("USERPROFILE"))
vim.opt.undodir = (os.getenv("HOME") or os.getenv("USERPROFILE")) .. "/.vim/undodir"
vim.opt.undofile = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")


vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"
vim.g.mapleader = " "
