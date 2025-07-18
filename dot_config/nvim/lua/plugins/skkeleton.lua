return {
    {
        "vim-skk/skkeleton",
        event = "VeryLazy",
        config = function ()
            vim.fn["skkeleton#config"]({
                globalDictionaries = { "~/SKK-JISYO.L" },
            })
        end
    },
}
