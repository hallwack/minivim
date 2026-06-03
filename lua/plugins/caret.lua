vim.pack.add({
	"https://github.com/ronish-maharjan/caret.nvim",
})

require("caret").setup({
	width = 80,
	height = 10,
	border = "rounded",
	title = "caret",
	title_pos = "center",
})
