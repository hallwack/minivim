vim.pack.add({ "https://gitlab.com/motaz-shokry/gruvbox.nvim" })

require("gruvbox").setup({
  dark_variant = "hard",
	styles = {
		transparency = false,
	},
	before_highlight = function(_, highlight, _)
		if highlight.undercurl then
			highlight.undercurl = false
			highlight.underline = true
		end
	end,
})

-- vim.cmd("colorscheme gruvbox-light") 
vim.cmd("colorscheme gruvbox")
