vim.g.mapleader = " "
vim.cmd[[set completeopt+=menuone,noselect,popup,fuzzy]]

local opt = vim.opt

opt.number = true
opt.cursorline = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = false
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.wrap = true

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = false

opt.splitbelow = true
