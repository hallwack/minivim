vim.pack.add({
	{ src = "https://github.com/folke/sidekick.nvim" },
})

require("sidekick").setup({
	-- Next Edit Suggestions disabled for now (Copilot completions in blink.cmp
	-- stay as they are). Set to true to re-enable.
	nes = { enabled = false },
	cli = {
		mux = { enabled = false }, -- use the built-in terminal split, no tmux/zellij
		win = {
			layout = "left", -- "right" | "left" | "bottom" | "top" | "float"
			split = {
				width = 80, -- used by left/right
				height = 20, -- used by bottom/top
			},
		},
	},
})

-- Cycle the AI CLI window position; open windows are moved right away.
local layouts = { "left", "bottom", "right", "float" }
local function cycle_cli_layout()
	local win = require("sidekick.config").cli.win
	local idx = 0
	for i, l in ipairs(layouts) do
		if l == win.layout then
			idx = i
		end
	end
	win.layout = layouts[idx % #layouts + 1]
	for _, term in pairs(require("sidekick.cli.terminal").terminals) do
		term.opts.layout = win.layout
		if term:is_open() then
			term:hide()
			term:show()
		end
	end
	vim.notify("Sidekick layout: " .. win.layout)
end

local map = vim.keymap.set

-- AI CLI (Claude Code, Codex, opencode, Copilot CLI, ...)
map({ "n", "t", "i", "x" }, "<C-.>", function()
	require("sidekick.cli").focus()
end, { desc = "Sidekick Focus" })
map("n", "<leader>aa", function()
	require("sidekick.cli").toggle()
end, { desc = "Toggle AI CLI" })
map("n", "<leader>as", function()
	require("sidekick.cli").select({ filter = { installed = true } })
end, { desc = "Select AI CLI" })
map("n", "<leader>ac", function()
	require("sidekick.cli").toggle({ name = "claude", focus = true })
end, { desc = "Toggle Claude" })
map("n", "<leader>al", cycle_cli_layout, { desc = "Cycle AI CLI Layout" })
map("n", "<leader>ad", function()
	require("sidekick.cli").close()
end, { desc = "Detach AI CLI Session" })
map({ "n", "x" }, "<leader>at", function()
	require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send This" })
map("n", "<leader>af", function()
	require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Send File" })
map("x", "<leader>av", function()
	require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Selection" })
map({ "n", "x" }, "<leader>ap", function()
	require("sidekick.cli").prompt()
end, { desc = "Select Prompt" })
