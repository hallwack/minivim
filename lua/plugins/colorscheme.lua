vim.pack.add({
	{
		src = "https://gitlab.com/motaz-shokry/gruvbox.nvim",
	},
	{
		src = "https://github.com/marekh19/meowsoot.nvim",
	},
	{
		src = "https://github.com/mitander/flume.nvim",
	},
})

--[[ require("gruvbox").setup({
	dark_variant = "hard",
	styles = {
		italic = false,
		transparency = true,
	},
	before_highlight = function(_, highlight, _)
		if highlight.undercurl then
			highlight.undercurl = false
			highlight.underline = true
		end
	end,
}) ]]

-- vim.cmd("colorscheme gruvbox-light")
-- vim.cmd("colorscheme gruvbox")

require("meowsoot").setup({
	style = "night",
	transparent = true,
	terminal_colors = true,
	styles = {
		comments = { italic = false },
	},
})

vim.cmd.colorscheme("meowsoot")

-- require("flume").setup({
-- 	transparent = false,
-- 	styles = {
-- 		comments = { italic = false },
-- 	},
-- })
--
-- vim.cmd.colorscheme("flume")
