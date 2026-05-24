vim.lsp.enable("rust_analyzer")

-- LSP
local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

local default_keymaps = {
	{ keys = "<leader>ca", func = vim.lsp.buf.code_action, desc = "Code Actions" },
	{
		keys = "<leader>cl",
		func = function()
			if vim.fn.exists(":LspOxlintFixAll") > 0 then
				vim.cmd("LspOxlintFixAll")
			elseif vim.fn.exists(":LspEslintFixAll") > 0 then
				vim.cmd("LspEslintFixAll")
			else
				vim.lsp.buf.code_action({
					apply = true,
					context = { only = { "source.fixAll" }, diagnostics = {} },
				})
			end
		end,
		desc = "LSP Fix All",
	},
	{ keys = "<leader>rn", func = vim.lsp.buf.rename, desc = "Code Rename" },
	{ keys = "K", func = vim.lsp.buf.hover, desc = "Hover Documentation", has = "hoverProvider" },
	{ keys = "gd", func = vim.lsp.buf.definition, desc = "Goto Definition", has = "definitionProvider" },
	{ keys = "grt", func = vim.lsp.buf.type_definition, desc = "Goto Type Definition", has = "typeDefinitionProvider" },
	{ keys = "grx", func = vim.lsp.codelens.run, desc = "Run Codelens", has = "codeLensProvider" },
	{ keys = "<leader>cw", func = vim.lsp.buf.workspace_diagnostics, desc = "Workspace Diagnostics" },
}

local completion = vim.g.completion_mode or "blink" -- or 'native'
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("lsp_attach"),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local buf = args.buf
		if client then
			-- Built-in completion
			if completion == "native" and client:supports_method("textDocument/completion") then
				vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
			end

			if client:supports_method("textDocument/inlayHint") then
				vim.defer_fn(function()
					vim.lsp.inlay_hint.enable(true, { bufnr = buf })
				end, 500)

				if not vim.b[buf].inlay_hints_autocmd_set then
					vim.api.nvim_create_autocmd("InsertEnter", {
						buffer = buf,
						callback = function()
							vim.lsp.inlay_hint.enable(false, { bufnr = buf })
						end,
					})
					vim.api.nvim_create_autocmd("InsertLeave", {
						buffer = buf,
						callback = function()
							vim.lsp.inlay_hint.enable(true, { bufnr = buf })
						end,
					})
					vim.b[buf].inlay_hints_autocmd_set = true
				end
			end

			if client:supports_method("textDocument/documentColor") then
				vim.lsp.document_color.enable(true, { bufnr = buf }, {
					style = "virtual",
				})
			end

			for _, km in ipairs(default_keymaps) do
				-- Only bind if there's no `has` requirement, or the server supports it
				if not km.has or client.server_capabilities[km.has] then
					vim.keymap.set(
						km.mode or "n",
						km.keys,
						km.func,
						{ buffer = buf, desc = "LSP: " .. km.desc, nowait = km.nowait }
					)
				end
			end
		end
	end,
})

vim.api.nvim_create_user_command("LspActive", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })

	if #clients == 0 then
		vim.notify("󰚌 No active LSP", vim.log.levels.WARN)
		return
	end

	vim.ui.select(clients, {
		prompt = "󰒋 Active LSP Clients",
		format_item = function(client)
			local root = client.config.root_dir or "No Root"

			return string.format("%s (%s)", client.name, vim.fn.fnamemodify(root, ":t"))
		end,
	}, function(choice)
		if not choice then
			return
		end

		vim.notify(
			string.format("󰒋 %s\n󰉋 %s", choice.name, choice.config.root_dir or "No Root"),
			vim.log.levels.INFO,
			{
				title = "LSP Info",
			}
		)
	end)
end, {
	desc = "Show active LSP clients",
})
