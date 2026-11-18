vim.pack.add({
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("^1"),
	},
	{ src = "https://github.com/fang2hou/blink-copilot" },
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = "v2.5.0" },
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
})

-- Lazy-load Copilot: the Node language server only spawns once you start typing
vim.api.nvim_create_autocmd("InsertEnter", {
	group = vim.api.nvim_create_augroup("user_copilot_lazy", { clear = true }),
	once = true,
	callback = function()
		require("copilot").setup({
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				-- never send secrets from .env files
				sh = function()
					return not vim.fs.basename(vim.api.nvim_buf_get_name(0)):match("^%.env")
				end,
			},
			should_attach = function(bufnr, _)
				if not vim.bo[bufnr].buflisted or vim.bo[bufnr].buftype ~= "" then
					return false
				end
				-- skip big files (minified bundles, lockfiles, dumps)
				local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
				return not (ok and stat and stat.size > 100 * 1024)
			end,
		})
	end,
})

require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
	keymap = {
		preset = "default",
		["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-b>"] = { "scroll_documentation_down", "fallback" },
		["<C-f>"] = { "scroll_documentation_up", "fallback" },
		["<C-l>"] = { "snippet_forward", "fallback" },
		["<C-h>"] = { "snippet_backward", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<C-e>"] = { "hide" },
	},

	appearance = {
		nerd_font_variant = "normal",
	},

	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},

	cmdline = {
		keymap = {
			preset = "inherit",
			["<CR>"] = { "accept_and_enter", "fallback" },
		},
	},

	sources = {
		default = { "copilot", "lsp", "snippets", "buffer" },
		providers = {
			copilot = {
				name = "copilot",
				module = "blink-copilot",
				score_offset = 100,
				async = true,
				opts = {
					debounce = 75,
					max_completions = 2,
				},
			},
		},
	},
})
