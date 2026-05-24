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
		prettier = {
			args = function(_, ctx)
				local search_dir = ctx.dirname or vim.fn.getcwd()
				local config_files = {
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yaml",
					".prettierrc.yml",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.mjs",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
					"prettier.config.ts",
				}
				-- Cache config per direktori, reset saat buf write
				local cache = vim.b[ctx.buf or 0]._prettier_config_cache
				if cache then
					return { "--config", cache, "--stdin-filepath", ctx.filename }
				end

				local root_monorepo = vim.fs.root(ctx.dirname, { "turbo.json" })
				local project_config = nil

				local function find_config_in_dir(dir)
					for _, name in ipairs(config_files) do
						local candidate = dir .. "/" .. name
						if vim.uv.fs_stat(candidate) then
							return candidate
						end
					end
					return nil
				end

				if root_monorepo then
					local pkg_json = vim.fn.findfile("package.json", search_dir .. ";" .. root_monorepo)
					local pkg_dir = pkg_json ~= "" and vim.fn.fnamemodify(pkg_json --[[@as string]], ":p:h") or search_dir

					project_config = find_config_in_dir(pkg_dir) or find_config_in_dir(root_monorepo)
				else
					project_config = find_config_in_dir(search_dir)
				end

				local config = project_config or vim.fn.expand("~/.prettierrc")

				-- Simpan ke cache
				vim.b[ctx.buf or 0]._prettier_config_cache = config

				return { "--config", config, "--stdin-filepath", ctx.filename }
			end,
		},
		default_format_opts = { lsp_format = "fallback" },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>fi", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })

vim.keymap.set({ "n", "v" }, "<leader>fr", function()
	require("conform").format({ async = true }, function(err, did_edit)
		if not err and did_edit then
			vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
		end
	end)
end, { desc = "Format buffer" })
