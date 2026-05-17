return {
	cmd = { "deno", "lsp" },
	cmd_env = { NO_COLOR = true },
	root_markers = {
		"deno.json",
	},
	workspace_required = true,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	-- and some other stuff
	root_dir = function(_, on_dir)
		local root_path = vim.fs.find("deno.json", {
			upward = true,
			type = "file",
			path = vim.fn.getcwd(),
		})[1]

		if root_path then
			on_dir(vim.fn.fnamemodify(root_path, ":h"))
		end
	end,
}
