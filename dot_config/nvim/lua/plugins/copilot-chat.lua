return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        opts = {
            auto_trigger = false,
        }
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        build = "make tiktoken",
        cmd = "CopilotChat",
        opts = {},
    }
}
