vim.pack.add({
	{
		src = "https://github.com/obsidian-nvim/obsidian.nvim",
		version = vim.version.range("*"),
	},
})

require("obsidian").setup({
  legacy_commands = false,
	picker = {
		name = "snacks.picker",
	},
	workspaces = {
		{ name = "Obsidian Vault", path = "~/Documents/Obsidian/para-obsidian" },
	},
})
