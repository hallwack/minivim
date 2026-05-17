vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("nvim-web-devicons").setup({
	default = true,
})

require("snacks").setup({
	dashboard = { enabled = false },
	explorer = { enabled = true },
  git = { enabled = true },
  indent = { enabled = true },
	notifier = { enabled = false },
  picker = {
    enabled = true,
    hidden = true,
    ignored = true,
    git_branches = {
      show_current_branch = true,
    },
  },
	scroll = { enabled = false },
	terminal = {
		start_insert = false,
		auto_insert = false,
	},
})

-- Keymaps
local map = vim.keymap.set
local snacks = require("snacks")

map("n", "<leader>e", function()
	snacks.explorer({
		layout = {
			layout = {
				position = "right",
			},
		},
	})
end, { desc = "File Explorer" })
map("n", "<leader>gb", function()
	snacks.picker.git_branches()
end, { desc = "Git branches" })
map("n", "<leader>gl", function()
	snacks.picker.git_log()
end, { desc = "Git log" })
map("n", "<leader>gL", function()
	snacks.picker.git_log_line()
end, { desc = "Git log line" })
map("n", "<leader>gs", function()
	snacks.picker.git_status()
end, { desc = "Git status" })
map("n", "<leader>gS", function()
	snacks.picker.git_stash()
end, { desc = "Git stash" })
map("n", "git", function()
	snacks.lazygit.open()
end, { desc = "Git stash" })
map("n", "<M-t>", function()
	snacks.terminal()
end, { desc = "Terminal" })
map("n", "<M-w>", function()
	snacks.terminal.toggle()
end, { desc = "Toggle terminal" })
