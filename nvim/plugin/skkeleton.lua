-- Pacman でインストールした skk-jisyo 辞書 (pacman -S skk-jisyo)
vim.g.skk_jisyo = "/usr/share/skk/SKK-JISYO.L"

vim.api.nvim_create_autocmd("InsertEnter", {
    group = vim.api.nvim_create_augroup("skkeleton", { clear = true }),
    callback = function()
        vim.pack.add({
            "https://github.com/vim-skk/skkeleton"
        })
        -- denops は起動時に一度 plugin discover を実行済みのため、
        -- 後から追加した skkeleton の denops プラグインを認識させるために再スキャンする
        vim.fn["denops#plugin#discover"]()
        vim.fn["skkeleton#config"]({
            globalDictionaries = { vim.g.skk_jisyo },
            eggLikeNewline = true,
        })
        vim.keymap.set({ "i", "c" }, [[<C-j>]], [[<Plug>(skkeleton-enable)]], { noremap = false })
    end,
    once = true,
})
