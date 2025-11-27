return {
    {
        "nvim-lua/plenary.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        keys = {
            {
                "<leader>tf",
                function () require("telescope.builtin").find_files() end,
                desc = "Telescope: Find files"
            },
            {
                "<leader>tg",
                function () require("telescope.builtin").live_grep() end,
                desc = "Telescope: Live grep",
            },
            {
                "<leader>tb",
                function () require("telescope.builtin").buffers() end,
                desc = "Telescope: Buffers"
            },
        }
    }
}
