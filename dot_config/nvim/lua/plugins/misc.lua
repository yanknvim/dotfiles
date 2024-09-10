return {
	{
		"folke/tokyonight.nvim",
		event = "VimEnter",
		config = function()
			vim.cmd([[colorscheme tokyonight-storm]])
		end,
	},

	{ "kyazdani42/nvim-web-devicons" },

	{
		"phaazon/hop.nvim",
		keys = {
			{ "<Leader>hl", function()
				require("hop").hint_lines()
			end },
			{ "<Leader>hc", function()
				require("hop").hint_char1()
			end },
			{ "<Leader>hw", function()
				require("hop").hint_words()
			end },
		},
		config = function()
			require("hop").setup({
				keys = "etovxqpdygfblzhckisuran"
			})
		end,
	},

	{ "MunifTanjim/nui.nvim" },
	{ "rcarriga/nvim-notify" },
	{
		"folke/noice.nvim",
		event = "CmdLineEnter",
		config = function()
			require("noice").setup{}
		end
	},

	{
		"vim-denops/denops.vim",
		lazy = false,
	},
}
