return {
	{ "windwp/nvim-ts-autotag" },
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup {
				highlight = {
					enable = true,
					auto_install = true,
				},
				indent = {
					enable = true,
				},
				autotag = {
					enable = true,
				}
			}
		end,
	}
}
