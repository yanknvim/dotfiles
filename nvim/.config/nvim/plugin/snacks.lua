vim.pack.add({
    "https://github.com/folke/snacks.nvim"
})

require("snacks").setup {
    indent = {
        enabled = true,
        animate = {
            enabled = false
        }
    },
    picker = {
        enabled = true,
        layout = {
            layout = {
                backdrop = false,
            }
        }
    },
    explorer = {
        enabled = true,
    },
}

vim.keymap.set("n", "<Leader>fb", function()
    Snacks.picker.buffer()
end)

vim.keymap.set("n", "<Leader>ff", function()
    Snacks.picker.git_files()
end)

vim.keymap.set("n", "<Leader>fg", function()
    Snacks.picker.grep()
end)

vim.keymap.set("n", "<Leader>fk", function()
    Snacks.picker.keymaps()
end)

vim.keymap.set("n", "<Leader><Leader>", function()
    Snacks.explorer.open()
end)
