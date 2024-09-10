vim.g.mapleader = " "

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "J", "10j")
vim.keymap.set("n", "K", "10k")
vim.keymap.set("n", "L", "$")

vim.keymap.set("n", "<Leader>K", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

vim.keymap.set("n", "<Leader>p", "<cmd>:BufferLineCycleNext<CR>")
vim.keymap.set("n", "<Leader>o", "<cmd>:BufferLineCyclePrev<CR>")

vim.keymap.set("n", "ss", "<cmd>:split<CR>")
vim.keymap.set("n", "sv", "<cmd>:vsplit<CR>")
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sl", "<C-w>l")
vim.keymap.set("n", "sH", "<C-w>H")
vim.keymap.set("n", "sJ", "<C-w>J")
vim.keymap.set("n", "sK", "<C-w>K")
vim.keymap.set("n", "sL", "<C-w>L")
vim.keymap.set("n", "s>", "<C-w>>")
vim.keymap.set("n", "s<", "<C-w><")
vim.keymap.set("n", "s+", "<C-w>+")
vim.keymap.set("n", "s-", "<C-w>-")
vim.keymap.set("n", "sc", "<C-w>c")


