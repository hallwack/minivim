return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json" },
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
			files = {
				excludeDirs = { ".direnv", ".git", "target" },
			},
			inlayHints = {
				chainingHints = { enable = false },
			},
		},
	},
}
