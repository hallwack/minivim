-- Official Laravel language server (https://github.com/laravel/lsp).
-- Installed via Mason (`laravel_lsp`); nvim-lspconfig doesn't ship a config yet.
-- Go to definition works for Blade components (<x-...>), Livewire, views,
-- routes, config, env, translations, etc.
return {
	cmd = { "laravel-lsp" },
	filetypes = { "php", "blade" },
	-- only start inside a Laravel app
	root_dir = function(bufnr, on_dir)
		local root = vim.fs.root(bufnr, "artisan")
		if root then
			on_dir(root)
		end
	end,
	init_options = {
		-- auto = Herd, Valet, Sail, Lando, DDEV, then local php
		phpEnvironment = "auto",
		memoryLimit = "512M",
	},
}
