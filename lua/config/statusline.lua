local M = {}

local NONE = "NONE"
local palette = {
	bg_main = "#282828",
	bg_second = "#32302F",
	bg_third = "#3C3836",

	bg1 = "#3C3836",
	bg2 = "#504945",
	bg3 = "#665C54",
	bg4 = "#7C6F64",

	fg = "#FBF1C7",
	fg1 = "#EBDBB2",
	fg2 = "#D5C4A1",
	fg3 = "#BDAE93",
	fg4 = "#A89984",

	gray = "#928374",

	red = "#FB4934",
	red_dark = "#CC241D",

	green = "#B8BB26",
	green_dark = "#98971A",

	yellow = "#FABD2F",
	yellow_dark = "#D79921",

	blue = "#83A598",
	blue_dark = "#458588",

	purple = "#D3869B",
	purple_dark = "#B16286",

	aqua = "#8EC07C",
	aqua_dark = "#689D6A",

	orange = "#FE8019",
	orange_dark = "#D65D0E",
}

-- Helper to issue highlight commands
local function hi(group, opts)
	local cmd = { "highlight!", group }
	if opts.guibg then
		table.insert(cmd, "guibg=" .. opts.guibg)
	end
	if opts.guifg then
		table.insert(cmd, "guifg=" .. opts.guifg)
	end
	if opts.gui then
		table.insert(cmd, "gui=" .. opts.gui)
	end
	vim.cmd(table.concat(cmd, " "))
end

hi("StatusLine", { guibg = NONE, guifg = palette.fg3 })
hi("StatusLineNC", { guibg = NONE, guifg = palette.gray })

hi("StatusMode", { guibg = palette.green_dark, guifg = palette.bg_main, gui = "bold" })
hi("StatusModeToNorm", { guibg = NONE, guifg = palette.green_dark })

-- git
hi("StatusGit", { guibg = palette.bg1, guifg = palette.fg1, gui = "bold" })
hi("StatusGitToNorm", { guibg = palette.bg1, guifg = palette.bg1 })
hi("StatusDiffAdd", { guibg = palette.bg1, guifg = palette.green, gui = "bold" })
hi("StatusDiffChange", { guibg = palette.bg1, guifg = palette.yellow, gui = "bold" })
hi("StatusDiffDelete", { guibg = palette.bg1, guifg = palette.red, gui = "bold" })

--file
hi("StatusFile", { guibg = NONE, guifg = palette.fg1, gui = "bold" })
hi("StatusFileToNorm", { guibg = NONE, guifg = palette.bg1 })

hi("StatusLSP", { guibg = NONE, guifg = palette.blue, gui = "bold" })
hi("StatusLSPToNorm", { guibg = NONE, guifg = palette.bg1 })

hi("StatusErrorIcon", { guibg = NONE, guifg = palette.red, gui = "bold" })
hi("StatusWarnIcon", { guibg = NONE, guifg = palette.yellow, gui = "bold" })
hi("StatusInfoIcon", { guibg = NONE, guifg = palette.blue, gui = "bold" })
hi("StatusHintIcon", { guibg = NONE, guifg = palette.aqua })

hi("StatusBuffer", { guibg = palette.bg1, guifg = palette.fg1 })
hi("StatusType", { guibg = palette.bg2, guifg = palette.fg1 })
hi("StatusNorm", { guibg = NONE, guifg = NONE })
hi("StatusLocation", { guibg = palette.purple_dark, guifg = palette.fg })
hi("StatusPercent", { guibg = palette.blue_dark, guifg = palette.bg_main, gui = "bold" })

local fn = vim.fn

local _diag_cache = {} -- [bufnr] -> { e=n, w=n, i=n, h=n }

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function(args)
		local buf = args.buf
		local sev = vim.diagnostic.severity
		local counts = vim.diagnostic.count(buf)
		_diag_cache[buf] = {
			e = counts[sev.ERROR] or 0,
			w = counts[sev.WARN] or 0,
			i = counts[sev.INFO] or 0,
			h = counts[sev.HINT] or 0,
		}
	end,
})

local _wc_state = { words = 0, timer = nil }

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
	callback = function()
		local ft = vim.bo.filetype
		if not (ft:match("md") or ft:match("markdown") or ft == "text") then
			return
		end
		if _wc_state.timer then
			_wc_state.timer:stop()
			_wc_state.timer:close()
		end
		_wc_state.timer = vim.defer_fn(function()
			_wc_state.timer = nil
			_wc_state.words = fn.wordcount().words or 0
		end, 500)
	end,
})

local _icon_cache = {} -- [bufnr] -> icon string

vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
	callback = function(args)
		_icon_cache[args.buf] = nil
	end,
})

-- Git repo/branch with caching - uses gitsigns buffer variables for performance
local function get_git_branch()
	local branch = vim.b.gitsigns_head
	if not branch or branch == "" then
		return " ?"
	end

	-- Get repo name from gitsigns status dict if available
	local gs = vim.b.gitsigns_status_dict
	if gs and gs.root then
		-- Extract repo name from the root path
		local repo_name = vim.fn.fnamemodify(gs.root, ":t")
		return " " .. repo_name .. "/" .. branch
	end

	return " " .. branch
end

local function build_git_diff()
	local gs = vim.b.gitsigns_status_dict or {}
	local added = gs.added or 0
	local changed = gs.changed or 0
	local removed = gs.removed or 0

	local diff_str = ""
	if added > 0 then
		diff_str = diff_str .. "%#StatusDiffAdd#  " .. added .. " "
	end
	if changed > 0 then
		diff_str = diff_str .. "%#StatusDiffChange#  " .. changed .. " "
	end
	if removed > 0 then
		diff_str = diff_str .. "%#StatusDiffDelete#  " .. removed .. " "
	end

	-- reset to StatusLine for everything that follows
	return diff_str .. "%#StatusLine#"
end

-- Diagnostics symbols
local function get_diagnostics()
	local buf = vim.api.nvim_get_current_buf()
	local c = _diag_cache[buf] or {}
	local s = ""
	if (c.e or 0) > 0 then
		s = s .. "%#StatusErrorIcon#   " .. c.e .. " "
	end
	if (c.w or 0) > 0 then
		s = s .. "%#StatusWarnIcon#   " .. c.w .. " "
	end
	if (c.i or 0) > 0 then
		s = s .. "%#StatusInfoIcon#   " .. c.i .. " "
	end
	if (c.h or 0) > 0 then
		s = s .. "%#StatusHintIcon#   " .. c.h .. " "
	end
	-- reset to StatusLine for following text
	return s .. "%#StatusLine#"
end

-- File icon
local function get_file_icon()
	local bufnr = vim.api.nvim_get_current_buf()
	if _icon_cache[bufnr] ~= nil then
		return _icon_cache[bufnr]
	end

	local ok, icons = pcall(require, "nvim-web-devicons")
	if not ok then
		_icon_cache[bufnr] = ""
		return ""
	end
	local name = vim.api.nvim_buf_get_name(bufnr)
	local f = fn.fnamemodify(name, ":t")
	local e = fn.fnamemodify(name, ":e")
	local icon = icons.get_icon(f, e, { default = true })
	local result = icon and icon .. " " or ""
	_icon_cache[bufnr] = result
	return result
end

-- Word count & reading time
local function word_reading()
	local ft = vim.bo.filetype
	if ft:match("md") or ft:match("markdown") or ft == "text" then
		local w = _wc_state.words
		if w == 0 then
			return ""
		end
		return w .. "w " .. " " .. math.ceil(w / 200) .. "m"
	end
	return ""
end

-- Mode icons
local mode_icons = {
	n = "N",
	c = "C",
	t = "T",
	i = "I",
	R = "R",
	V = "V-L",
	[""] = "V-B", -- Visual Block
	r = "R-P",
	v = "V",
}

-- Mode colors
local mode_colors = {
	n = palette.green_dark,
	i = palette.yellow_dark,
	v = palette.blue_dark,
	V = palette.blue_dark,
	[""] = palette.blue_dark,
	c = palette.purple_dark,
	R = palette.red_dark,
	t = palette.aqua_dark,
	r = palette.orange_dark,
}

local function set_mode_highlight(mode)
	local color = mode_colors[mode] or palette.green
	hi("StatusMode", { guibg = color, guifg = palette.bg_main, gui = "bold" })
	hi("StatusModeToNorm", { guibg = NONE, guifg = color })
end

local function get_lsp_clients()
	local clients = vim.lsp.get_clients({ bufnr = 0 })

	if #clients == 0 then
		return ""
	end

	local names = {}

	for _, client in ipairs(clients) do
		-- optional:
		-- hide some pseudo-clients
		if client.name ~= "copilot" then
			table.insert(names, client.name)
		end
	end

	if #names == 0 then
		return ""
	end

	return table.concat(names, ", ")
end

-- 4) Build statusline
function M.build()
	local st = ""

	-- A: mode
	local m = fn.mode()
	st = st .. "%#StatusMode# " .. (mode_icons[m] or m) .. " " .. "%#StatusModeToNorm#"

	-- B: git
	local br = get_git_branch()
	if br ~= "" then
		st = st .. "%#StatusGit# " .. " " .. br .. " " .. "%#StatusGitToNorm#"

		local git_diff = build_git_diff()
		if git_diff ~= "" then
			st = st .. git_diff .. "%#StatusGitToNorm#"
		end
	end

	-- C: filename
	-- local fnm = fn.expand("%:t")
	local fnm = fn.expand("%:.")
	if fnm ~= "" then
		st = st .. "%#StatusFile# " .. fnm .. " " .. (vim.bo.modified and " " or "") .. "%#StatusFileToNorm#"
	end

	local di = get_diagnostics()
	if di ~= "" then
		st = st .. "%#StatusLSP# " .. di .. " " .. "%#StatusLSPToNorm#"
	end

	-- right align
	st = st .. "%="

	local lsp = get_lsp_clients()

	if lsp ~= "" then
		st = st .. "%#StatusLSP#   " .. lsp .. " %#StatusLine#"
	end

	-- LSP progress (e.g. "indexing…" from language servers)
	local progress = vim.ui.progress_status and vim.ui.progress_status() or ""
	if progress ~= "" then
		st = st .. "%#StatusLSP# " .. progress .. " %#StatusLine# "
	end

	-- X: filetype
	local ft = vim.bo.filetype
	if ft ~= "" then
		st = st .. "%#StatusType# " .. get_file_icon() .. ft .. " %#StatusTypeToNorm#"
	end

	-- Y: word/reading
	local wr = word_reading()
	if wr ~= "" then
		st = st .. " %#StatusBuffer# " .. " " .. wr
	end

	-- Z: encoding, format, location, percent
	st = st
		.. "%#StatusBuffer# "
		.. vim.bo.fileencoding
		.. " "
		.. vim.bo.fileformat
		.. " "
		.. "%#StatusLocation# %l:%c "
		.. "%#StatusPercent# %p%% "

	return st
end

vim.opt.laststatus = 3 -- global statusline
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.o.statusline = "%!v:lua.require('config.statusline').build()"

local mode_group = vim.api.nvim_create_augroup("StatuslineMode", {
	clear = true,
})

vim.api.nvim_create_autocmd("ModeChanged", {
	group = mode_group,
	callback = function()
		local mode = fn.mode()

		set_mode_highlight(mode)

		-- redraw statusline immediately
		vim.cmd("redrawstatus")
	end,
})

set_mode_highlight(fn.mode()) -- set initial mode highlight

return M
