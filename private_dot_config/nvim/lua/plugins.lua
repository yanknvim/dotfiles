return {
	{
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd([[colorscheme tokyonight-storm]])
		end,
	},

	{ "kyazdani42/nvim-web-devicons", lazy = true },

	require("plugins/fern"),
	require("plugins/noice"),
	require("plugins/telescope"),

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

	require("plugins/treesitter"),
	require("plugins/lsp"),
	require("plugins/cmp"),
	require("plugins/lualine"),

	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("colorizer").setup()
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup()
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("indent_blankline").setup({
				show_end_of_line = true,
			})
		end,
	},

	{
		"akinsho/bufferline.nvim",
		config = function()
			require("bufferline").setup()
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = { "InsertEnter" },
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
}
