return {
	"echasnovski/mini.nvim",
	event = "VimEnter",
	config = function ()
		require("mini.diff").setup()
		require("mini.indentscope").setup({
			draw = {
				animation = require("mini.indentscope").gen_animation.none(),
			},
			symbol = "╎",
		})
		require("mini.pairs").setup()
		require("mini.hipatterns").setup({
			highlighters = {
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		})
		require("mini.statusline").setup()
	end
}
