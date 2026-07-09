vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opt = vim.opt

opt.number = true
opt.cursorline = true

opt.autoindent = true
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.showmatch = true

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wildmenu = true

opt.backup = false
opt.writebackup = false
opt.swapfile = false

opt.cmdheight = 0
opt.laststatus = 0
opt.statusline = "─"
opt.fillchars:append({ stl = "─", stlnc = "─" })

vim.g.pumblend = 15
vim.g.pumborder = "rounded"
