vim.g.skk_jisyo = "/usr/share/skk/SKK-JISYO.L"

vim.api.nvim_create_autocmd("InsertEnter", {
    group = vim.api.nvim_create_augroup("skkeleton", { clear = true }),
    callback = function()
        vim.pack.add({
            "https://github.com/vim-skk/skkeleton"
        })
        vim.fn["denops#plugin#discover"]()
        vim.fn["skkeleton#config"]({
            globalDictionaries = { vim.g.skk_jisyo },
            eggLikeNewline = true,
        })
        vim.keymap.set({ "i", "c" }, [[<C-j>]], [[<Plug>(skkeleton-enable)]], { noremap = false })
    end,
    once = true,
})
