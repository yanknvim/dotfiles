return {
	{
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd([[colorscheme tokyonight-storm]])
		end,
	},

	{ "kyazdani42/nvim-web-devicons", lazy = true },

	require("plugins/fern"),

	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{ "<Leader>ff", function()
				require("telescope.builtin").find_files()
			end },
			{ "<Leader>fg", function()
				require("telescope.builtin").live_grep()
			end },
			{ "<Leader>fb", function()
				require("telescope.builtin").buffers()
			end },
			{ "<Leader>fc", function()
				require("telescope.builtin").current_buffer_fuzzy_find()
			end },
		},
		dependencies = { "nvim-lua/plenary.nvim" },
	},

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
