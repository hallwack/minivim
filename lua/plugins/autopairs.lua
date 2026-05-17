vim.pack.add({
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
})

require("nvim-autopairs").setup({
	check_ts = true,
	ts_config = {
		lua = { "string", "source" },
		javascript = { "string", "template_string" },
		svelte = { "string", "template_string" },
	},
})

require("nvim-ts-autotag").setup({
	filetypes = { "html", "xml", "php", "javascript", "typescript", "jsx", "tsx" },
})
