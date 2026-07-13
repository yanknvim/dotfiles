vim.schedule(function()
    vim.pack.add({ "https://github.com/folke/which-key.nvim" })
    require("which-key").setup {}
end)

vim.keymap.set("n", "<Leader>?", function()
    require("which-key").show {}
end)
