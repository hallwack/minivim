return {
	-- prefer the composer root (monorepos may have .git higher up)
	root_markers = { "composer.json", ".git" },
	-- cap the Node heap so a huge project can't eat all RAM
	cmd_env = { NODE_OPTIONS = "--max-old-space-size=1536" },
	init_options = {
		-- keep the index cache out of /tmp so it survives reboots (faster reindex)
		storagePath = vim.fn.stdpath("cache") .. "/intelephense",
	},
	settings = {
		intelephense = {
			telemetry = { enabled = false },
			files = {
				maxSize = 1000000, -- skip files > ~1 MB (dumps, generated code)
				-- intelephense defaults + Laravel/build folders. Keep `vendor`
				-- indexed: framework completions depend on it.
				exclude = {
					"**/.git/**",
					"**/.svn/**",
					"**/.hg/**",
					"**/CVS/**",
					"**/.DS_Store/**",
					"**/node_modules/**",
					"**/bower_components/**",
					"**/vendor/**/{Tests,tests}/**",
					"**/.history/**",
					"**/vendor/**/vendor/**",
					"**/storage/**",
					"**/bootstrap/cache/**",
					"**/public/build/**",
					"**/public/vendor/**",
					"**/.phpunit.cache/**",
				},
			},
		},
	},
}
