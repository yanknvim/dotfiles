return {
    {
        "nvim-lua/plenary.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        keys = {
            { "<leader>Ff", function () require("telescope.builtin").find_files() end},
            { "<leader>Fg", function () require("telescope.builtin").live_grep() end},
            { "<leader>Fb", function () require("telescope.builtin").buffers() end},
        }
    }
}
