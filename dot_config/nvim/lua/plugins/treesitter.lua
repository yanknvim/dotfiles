return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        }
    }
}

