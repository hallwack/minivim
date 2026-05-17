vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mason").setup({})

require("mason-lspconfig").setup({
	ensure_installed = {
		"rust_analyzer",
		"lua_ls",
		"ts_ls",
		"denols",
		"astro",
		"cssls",
		"dockerls",
		"html",
		"intelephense",
		"jsonls",
		"laravel_ls",
		"quick_lint_js",
		"sqlls",
		"svelte",
		"tailwindcss",
		"yamlls",
	},
})
