return {
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp", event = { "InsertEnter" } },
			{ "saadparwaiz1/cmp_luasnip", event = { "InsertEnter" } },
			{ "hrsh7th/cmp-path", event = { "InsertEnter" } },
			{ "hrsh7th/cmp-buffer", event = { "InsertEnter" } },
			{ "hrsh7th/cmp-cmdline", event = { "CmdlineEnter" } },
			{ "L3MON4D3/LuaSnip", event = { "InsertEnter"} },
			{ "onsails/lspkind.nvim", event = { "InsertEnter" } }
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
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
					["<C-k>"] = cmp.mapping(function(fallback)
							if luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { "i", "s" }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = "50",
						ellipsis_char = '...',

						before = function (entry, vim_item)
        			return vim_item
      			end
					})
				},
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
	}
}
