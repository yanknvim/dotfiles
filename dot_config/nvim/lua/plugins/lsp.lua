return {
	{ "williamboman/mason-lspconfig.nvim" },
	{ "williamboman/mason.nvim" },
	{
		"folke/lazydev.nvim",
		ft = "lua",
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
					},
		config = function()
			local lspconfig = require("lspconfig")
			require("mason").setup()
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({})
				end,
				lua_ls = function()
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								completion = {
									callSnippet = "Replace"
								}}}})
				end,
			})
		end,
	}
}
