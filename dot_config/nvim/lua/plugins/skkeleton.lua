return {
	"vim-skk/skkeleton",
	keys = {
		{ "<c-j>", "<Plug>(skkeleton-toggle)"},
	},
	config = function ()
		vim.cmd('call skkeleton#config({"globalDictionaries": ["~/.skk/SKK-JISYO.L"]})')
	end,
}

