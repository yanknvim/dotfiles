vim.api.nvim_create_autocmd("FileType", {
    pattern = "flix",
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/flix/nvim" })
        require("flix").setup()
        vim.lsp.enable("flix")
    end,
})
