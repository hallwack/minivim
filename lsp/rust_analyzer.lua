return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json" },
	before_init = function(_, config)
		local sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
		config.settings["rust-analyzer"].rustcSource = "discover"
		config.settings["rust-analyzer"].cargo = {
			sysroot = sysroot,
		}
	end,
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
			rustc = {
				source = "discover",
			},
		},
	},
}
