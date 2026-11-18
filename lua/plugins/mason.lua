vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mason").setup({})

require("mason-lspconfig").setup({
	-- mason-lspconfig auto-enables every installed server; skip the ones we
	-- don't want running (denols/laravel_lsp are enabled manually in config/lsp.lua;
	-- laravel_ls is replaced by the official laravel_lsp)
	automatic_enable = {
		exclude = { "denols", "laravel_ls", "laravel_lsp" },
	},
	ensure_installed = {
		"lua_ls",
		"ts_ls",
		"denols",
		"astro",
		"cssls",
		"dockerls",
		"html",
		"hyprls",
		"intelephense",
		"jsonls",
		"laravel_lsp",
		"quick_lint_js",
		"sqlls",
		"svelte",
		"tailwindcss",
		"yamlls",
	},
})
