vim.keymap.set({"n", "x", "o"}, "s", function()
    vim.pack.add({ { src = "https://github.com/folke/flash.nvim" } })
    require("flash").jump {}
end)
