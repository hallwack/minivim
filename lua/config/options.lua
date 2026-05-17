vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.colorcolumn = "80"
opt.signcolumn = "yes:1"
opt.termguicolors = true
opt.ignorecase = true
opt.swapfile = false
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.list = false
opt.number = true
opt.relativenumber = true opt.numberwidth = 4
opt.wrap = false
opt.cursorline = true
opt.scrolloff = 8
opt.inccommand = "nosplit"
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.completeopt = { "menu", "menuone", "noselect" }
opt.winborder = ""
opt.hlsearch = false
opt.encoding = "utf-8"
opt.smartindent = true
opt.tabpagemax = 10
opt.mouse = "a"
opt.hidden = true
opt.laststatus = 3
opt.timeoutlen = 500
opt.showtabline = 2
opt.pumheight = 10
opt.cmdheight = 1
opt.smartcase = true
opt.guifont = "monospace:h17"
opt.sidescrolloff = 8
opt.clipboard = "unnamedplus"

local ok_ui2, ui2 = pcall(require, "vim._core.ui2")
if ok_ui2 then
	ui2.enable({
		msg = {
			targets = "cmd",
		},
	})
end
