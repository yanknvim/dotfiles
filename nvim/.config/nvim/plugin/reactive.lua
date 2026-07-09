vim.schedule(function ()
    vim.pack.add({
        { src = "https://github.com/rasulomaroff/reactive.nvim" },
    })
    require("reactive").setup {
        builtin = {
            cursorline = true,
            cursor = true,
        }
    }
end)
