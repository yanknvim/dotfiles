vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function ()
        vim.pack.add({ 'https://github.com/saghen/blink.lib', 'https://github.com/saghen/blink.cmp' })

        local cmp = require('blink.cmp')
        cmp.build():pwait()
        cmp.setup {
            keymap = { preset = "default" },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer'},
            },
        }
    end
})
