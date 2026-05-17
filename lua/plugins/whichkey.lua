vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})

local ok, wk = pcall(require, "which-key")
if not ok then
	return
end

wk.setup({
	preset = "modern",
	delay = 500,
	plugins = {
		marks = true,
		registers = true,
		spelling = {
			enabled = true,
			suggestions = 20,
		},
	},
	spec = {
		{ "<leader>c", group = "Code" },
		{ "<leader>f", group = "Find / Format" },
		{ "<leader>g", group = "Git" },
		{ "<leader>gh", group = "Git Hunks" },
		{ "<leader>p", group = "Pack" },
		{ "<leader>t", group = "Tabs" },
		{ "<leader>x", group = "Lists" },
		{ "<leader>r", group = "Rename / Restart" },
		{ "<leader>s", group = "Search" },
	},
})

wk.add({
	{ "<leader>ca", desc = "Code Actions" },
	{ "<leader>cd", desc = "Line Diagnostics" },
	{ "<leader>cl", desc = "LSP Fix All" },
	{ "<leader>cw", desc = "Workspace Diagnostics" },

	{ "<leader>e", desc = "File Explorer" },
	{ "<leader>ff", desc = "Find Files" },
	{ "<leader>fi", desc = "Conform Info", mode = { "n", "v" } },
	{ "<leader>fr", desc = "Format Buffer", mode = { "n", "v" } },
	{ "<leader>sg", desc = "Live Grep" },

	{ "<leader>gb", desc = "Git Branches" },
	{ "<leader>gc", desc = "Git Compare" },
	{ "<leader>gC", desc = "Git Compare Refs" },
	{ "<leader>gd", desc = "Git Working Tree Diff" },
	{ "<leader>gD", desc = "Git Staged Diff" },
	{ "<leader>gf", desc = "Git File Diff" },
	{ "<leader>gF", desc = "Git File Diff With Ref" },
	{ "<leader>gL", desc = "Git Log Line" },
	{ "<leader>gl", desc = "Git Log" },
	{ "<leader>gm", desc = "Git Merge Conflicts" },
	{ "<leader>gS", desc = "Git Stash" },
	{ "<leader>gs", desc = "Git Status" },
	{ "<leader>gV", desc = "Git File History" },
	{ "<leader>gv", desc = "Git Line History", mode = "v" },
	{ "<leader>gx", desc = "Git Close Diffs" },
	{ "<leader>g2", desc = "Git Compare Two Files" },

	{ "<leader>ghB", desc = "Blame Buffer" },
	{ "<leader>ghb", desc = "Blame Line" },
	{ "<leader>ghD", desc = "Diff This ~" },
	{ "<leader>ghd", desc = "Diff This" },
	{ "<leader>ghp", desc = "Preview Hunk Inline" },
	{ "<leader>ghR", desc = "Reset Buffer" },
	{ "<leader>ghr", desc = "Reset Hunk", mode = { "n", "v" } },
	{ "<leader>ghS", desc = "Stage Buffer" },
	{ "<leader>ghs", desc = "Stage Hunk", mode = { "n", "v" } },
	{ "<leader>ghu", desc = "Undo Stage Hunk" },

	{ "<leader>pd", desc = "Pack Delete" },
	{ "<leader>pp", desc = "Pack UI" },
	{ "<leader>pu", desc = "Pack Update All" },

	{ "<leader>R", desc = "Restart Neovim" },
	{ "<leader>rn", desc = "Rename Symbol" },

	{ "<leader>tn", desc = "New Tab" },
	{ "<leader>xl", desc = "Location List" },
	{ "<leader>xq", desc = "Quickfix List" },

	{ "[d", desc = "Previous Diagnostic" },
	{ "]d", desc = "Next Diagnostic" },
	{ "[e", desc = "Previous Error" },
	{ "]e", desc = "Next Error" },
	{ "[h", desc = "Previous Hunk" },
	{ "]h", desc = "Next Hunk" },
	{ "[H", desc = "First Hunk" },
	{ "]H", desc = "Last Hunk" },
	{ "[m", desc = "Previous Function Start", mode = { "n", "x", "o" } },
	{ "]m", desc = "Next Function Start", mode = { "n", "x", "o" } },
	{ "[M", desc = "Previous Function End", mode = { "n", "x", "o" } },
	{ "]M", desc = "Next Function End", mode = { "n", "x", "o" } },
	{ "[o", desc = "Previous Loop", mode = { "n", "x", "o" } },
	{ "]o", desc = "Next Loop", mode = { "n", "x", "o" } },
	{ "[q", desc = "Previous Quickfix" },
	{ "]q", desc = "Next Quickfix" },
	{ "[w", desc = "Previous Warning" },
	{ "]w", desc = "Next Warning" },
	{ "[[", desc = "Previous Class Start", mode = { "n", "x", "o" } },
	{ "]]", desc = "Next Class Start", mode = { "n", "x", "o" } },

	{ "<Tab>", desc = "Next Tab" },
	{ "<S-Tab>", desc = "Previous Tab" },
	{ "<M-t>", desc = "Open Terminal" },
	{ "<M-w>", desc = "Toggle Terminal" },
	{ "dm", desc = "Delete Mark" },
	{ "gh", desc = "Line Start" },
	{ "gl", desc = "Line End" },
	{ "grt", desc = "Type Definition" },
	{ "grx", desc = "Run Codelens" },
	{ "K", desc = "Hover Documentation" },
})
