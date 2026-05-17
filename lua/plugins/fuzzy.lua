vim.pack.add({
	{ src = "https://github.com/dmtrKovalenko/fff.nvim" },
})

require("fff").setup({
	lazy_sync = true,
	debug = { enabled = true, show_scores = true },
	preview = { enabled = true },
	keymaps = {
		close = "<Esc>",
		move_up = "<C-k>",
		move_down = "<C-j>",
	},
})

local map = vim.keymap.set

map("n", "<leader>ff", "<cmd>lua require('fff').find_files()<cr>")
map("n", "<leader>sg", "<cmd>lua require('fff').live_grep()<cr>")
