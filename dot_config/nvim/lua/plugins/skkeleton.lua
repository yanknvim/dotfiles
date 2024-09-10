return {
	"vim-skk/skkeleton",
	event = "VimEnter",
	config = function ()
		vim.cmd('call skkeleton#config({"globalDictionaries": ["~/.skk/SKK-JISYO.L"]})')
	end,
}
