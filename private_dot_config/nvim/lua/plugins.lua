vim.cmd [[packadd packer.nvim]]


require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use {'folke/tokyonight.nvim', opt = true}
	use {'shaunsingh/nord.nvim', opt = true}

	use 'kyazdani42/nvim-web-devicons'

	use {
		'nvim-telescope/telescope.nvim',
		module = "telescope",
		requires = { 'nvim-lua/plenary.nvim' },
	}

	use {
		'phaazon/hop.nvim',
		branch = 'v2',
		module = 'hop',
		config = function()
			require('hop').setup()
		end
	}
	
	use {
		'neovim/nvim-lspconfig',
		event = {"BufReadPre"},
		requires = {
			{'williamboman/mason-lspconfig.nvim', module = { "mason-lspconfig" }},
			{'williamboman/mason.nvim', module = {"mason"}}
		},
		wants = {
			"mason-lspconfig.nvim",
			"mason.nvim"
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup_handlers {
				function(server_name)
					require("lspconfig")[server_name].setup {
						on_attach = on_attach,
					}
				end
			}

			require("lspconfig").metals.setup{}
		end
	}

	use {
		"hrsh7th/nvim-cmp",
		module = { "cmp" },
		requires = {
			{"hrsh7th/cmp-nvim-lsp", event = { "InsertEnter" } },
			{"hrsh7th/vim-vsnip", event = { "InsertEnter" } },
			{"hrsh7th/cmp-path", event = { "InsertEnter" } },
			{"hrsh7th/cmp-buffer", event = { "InsertEnter" } },
			{'hrsh7th/cmp-cmdline'},
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
					completion = cmp.config.window.bordered({
						border = 'single'
					}),
					documentation = cmp.config.window.bordered({
						border = 'single'
					})
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-y>"] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm { select = true },
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
					{ name = "buffer" },
					{ name = "path" }
				}),
				experimental = {
					ghost_text = true,
				}
			})
			
			cmp.setup.cmdline('/', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{
						name = 'cmdline',
						option = {
							ignore_cmds = {'Man', '!'}
						}
					}
				})
			})
		end
	}
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup{
				ensure_installed = "all",
				auto_install = true,
				highlight = {
					enable = true
				},
			}
		end
	}

	use {
		'norcalli/nvim-colorizer.lua',
		config = function()
			require("colorizer").setup()
		end
	}

	use {
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup()
		end
	}

	use {
		'lukas-reineke/indent-blankline.nvim',
		event = {"BufReadPre"},
		config = function()
			require('indent_blankline').setup {
				show_end_of_line = true,
			}
		end
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = 'yanknvim/lualine-playerctl',
		config = function()
			require("lualine").setup{
				options = {
					icons_enabled = true,
					theme = 'auto',
					component_separators = { left = "", right = ""},
					section_separators = { left = "", right = ""},
					globalstatus = true
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {'branch', 'diff'},
					lualine_c = {'filetype', 'filename'},
					lualine_x = {'playerctl'},
					lualine_y = {'progress'},
					lualine_z = {'location'}
				}
			}
		end
	}

	
	use {
		'petertriho/nvim-scrollbar',
		config = function()
			require("scrollbar").setup()
		end
	}
	use {
		'akinsho/bufferline.nvim',
		config = function()
			require("bufferline").setup()
		end
	}

	use {"akinsho/toggleterm.nvim", config = function()
		require("toggleterm").setup()
	end}
	use {
		"windwp/nvim-autopairs",
		event = {
			"InsertEnter"
		},
		config = function()
			require("nvim-autopairs").setup()
		end,
	}
	
	use 'dstein64/vim-startuptime'
end)

