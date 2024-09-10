return {
	{
		"lambdalisue/fern.vim",
		dependencies = {
			{ "lambdalisue/nerdfont.vim" },
			{ "lambdalisue/fern-renderer-nerdfont.vim" },
		},
		keys = {
			{ "<Leader><Leader>", ":Fern . -drawer -toggle<CR>" }
		},
		config = function()
			vim.g["fern#renderer"] = "nerdfont"
		end,
	},
}
