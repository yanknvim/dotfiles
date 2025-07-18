return {
    { "vim-denops/denops.vim", event = "VeryLazy" },
    {
        "vim-skk/skkeleton",
        event = "InsertEnter",
        config = function ()
            vim.fn["skkeleton#config"]({
                globalDictionaries = { "~/SKK-JISYO.L" },
            })
        end
    },
}
