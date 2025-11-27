vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "J", "10j")
vim.keymap.set("n", "K", "10k")
vim.keymap.set("n", "L", "$")

-- vim.keymap.set("n", "s", "<C-w>")

vim.keymap.set("i", "<C-j>", "<Plug>(skkeleton-enable)", { noremap = false })

vim.keymap.set("n", "<leader>]", function() vim.diagnostic.jump({ count = 1, float = true }) end)
vim.keymap.set("n", "<leader>[", function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end)
vim.keymap.set("n", "gn", function() vim.lsp.buf.rename() end)
vim.keymap.set("n", "<leader>K", function() vim.lsp.buf.hover() end)
