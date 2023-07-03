return {
	{
		"shaunsingh/nord.nvim",
		lazy = false,
		config = function()
			vim.cmd([[colorscheme nord]])
		end,
	},
	{ "kyazdani42/nvim-web-devicons", lazy = true },

	{
		"nvim-tree/nvim-tree.lua",
		keys = {
			{ "<Leader>tt", ":NvimTreeToggle<CR>" },
		},
		config = function()
			require("nvim-tree").setup()
		end
	},

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
			require("hop").setup()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre" },
		config = function()
			require("nvim-treesitter.configs").setup {
				highlight = {
					enable = true,
					auto_install = true,
				},
				indent = {
					enable = true,
				}
			}
		end
		
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre" },
		dependencies = {
			{ "williamboman/mason-lspconfig.nvim", lazy = true },
			{ "williamboman/mason.nvim", lazy = true },
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						on_attach = on_attach,
					})
				end,
			})

			require("lspconfig").metals.setup({})
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp", event = { "InsertEnter" } },
			{ "hrsh7th/vim-vsnip", event = { "InsertEnter" } },
			{ "hrsh7th/cmp-path", event = { "InsertEnter" } },
			{ "hrsh7th/cmp-buffer", event = { "InsertEnter" } },
			{ "hrsh7th/cmp-cmdline", event = { "CmdlineEnter" } },
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anoymous"](args.body)
					end,
				},
				window = {
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-y>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				experimental = {
					ghost_text = true,
				},
			})

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},

	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre" },
		config = function()
			require("gitsigns").setup()
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre" },
		config = function()
			require("indent_blankline").setup({
				show_end_of_line = true,
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "nord",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff" },
					lualine_c = { "filetype", "filename" },
					lualine_x = {},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	{
		"petertriho/nvim-scrollbar",
		config = function()
			require("scrollbar").setup()
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
