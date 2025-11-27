return {
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        event = { "BufNewFile", "BufReadPre" },
        opts = {},
    },
}
