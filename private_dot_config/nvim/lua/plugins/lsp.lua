return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
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
}
