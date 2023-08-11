return {
	{
		"lambdalisue/fern.vim",
		lazy = true,
		keys = {
			{ "<Leader><Leader>", ":Fern . -drawer -toggle<CR>" }
		},
		config = function()
			vim.g["fern#renderer"] = "nerdfont"
		end,
		dependencies = {
			{ "lambdalisue/nerdfont.vim" },
			{ "lambdalisue/fern-renderer-nerdfont.vim" },
		}
	},
}
