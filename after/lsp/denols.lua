return {
	cmd = { "deno", "lsp" },
	cmd_env = { NO_COLOR = true },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	workspace_required = true,
	-- only attach inside a Deno project (resolved from the buffer, not cwd)
	root_dir = function(bufnr, on_dir)
		local root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
		if root then
			on_dir(root)
		end
	end,
}
