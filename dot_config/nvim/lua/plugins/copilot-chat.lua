return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            auto_trigger = false,
        }
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        build = "make tiktoken",
        opts = {},
    }
}
