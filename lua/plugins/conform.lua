vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports", "gofmt", stop_after_first = true },
		python = { "ruff_format", "isort", "black", stop_after_first = true },
		json = { "oxfmt", "prettierd", stop_after_first = true },
		jsonc = { "oxfmt", "prettierd", stop_after_first = true },
		javascript = { "oxfmt", "prettierd", stop_after_first = true },
		typescript = { "oxfmt", "prettierd", stop_after_first = true },
		javascriptreact = { "oxfmt", "prettierd", stop_after_first = true },
		typescriptreact = { "oxfmt", "prettierd", stop_after_first = true },
		css = { "oxfmt", "prettierd", stop_after_first = true },
		scss = { "oxfmt", "prettierd", stop_after_first = true },
		html = { "oxfmt", "prettierd", stop_after_first = true },
		vue = { "oxfmt", "prettierd", stop_after_first = true },
		svelte = { "oxfmt", "prettierd", stop_after_first = true },
		astro = { "oxfmt", "prettierd", stop_after_first = true },
		yaml = { "oxfmt", "prettierd", stop_after_first = true },
		markdown = { "oxfmt", "prettierd", stop_after_first = true },
		["markdown.mdx"] = { "oxfmt", "prettierd", stop_after_first = true },
		graphql = { "oxfmt", "prettierd", stop_after_first = true },
		xml = { "prettierd", stop_after_first = true }, -- oxfmt doesn't support xml
		toml = { "taplo" },
		nix = { "nixfmt" },
		rust = { "rustfmt" },
		php = { "pint", "php-cs-fixer", stop_after_first = true },
		blade = { "blade-formatter" },
	},

	formatters = {
		oxfmt = {
			args = function(_, ctx)
				local search_dir = ctx.dirname or vim.fn.getcwd()

				-- only search at git root level, not walking up infinitely
				local git_root =
					vim.fn.systemlist("git -C " .. vim.fn.shellescape(search_dir) .. " rev-parse --show-toplevel")[1]

				local project_config = nil
				if git_root and vim.fn.isdirectory(git_root) == 1 then
					for _, name in ipairs({ ".oxfmtrc.jsonc", ".oxfmtrc.json" }) do
						local candidate = git_root .. "/" .. name
						if vim.fn.filereadable(candidate) == 1 then
							project_config = candidate
							break
						end
					end
				end

				-- fallback to global ~/.oxfmtrc.jsonc or ~/.oxfmtrc.json
				if not project_config then
					for _, candidate in ipairs({
						vim.fn.expand("~/.oxfmtrc.jsonc"),
						vim.fn.expand("~/.oxfmtrc.json"),
					}) do
						if vim.fn.filereadable(candidate) == 1 then
							project_config = candidate
							break
						end
					end
				end

				local args = { "--stdin-filepath", ctx.filename }
				if project_config then
					vim.list_extend(args, { "--config", project_config })
				end
				return args
			end,
		},
	},

	default_format_opts = { lsp_format = "fallback" },
})

vim.keymap.set({ "n", "v" }, "<leader>fi", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })

vim.keymap.set({ "n", "v" }, "<leader>fr", function()
	require("conform").format({ async = true }, function(err, did_edit)
		if not err and did_edit then
			vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
		end
	end)
end, { desc = "Format buffer" })
