local M = {}

local SEP = ""
local NO_NAME = "[NO NAME]"

local function augroup(name)
	return vim.api.nvim_create_augroup("MyTabline_" .. name, {
		clear = true,
	})
end

function M.set_highlights()
	vim.api.nvim_set_hl(0, "MyTabInactive", {
		fg = "#A89984",
		bg = "#282828",
	})

	vim.api.nvim_set_hl(0, "MyTabActive", {
		fg = "#FBF1C7",
		bg = "#3C3836",
		bold = true,
	})

	vim.api.nvim_set_hl(0, "MyTabSeparator", {
		fg = "#1b1b1b",
		bg = "",
	})

	vim.api.nvim_set_hl(0, "MyTabIndex", {
		fg = "#83A598",
		bg = "#3C3836",
		bold = true,
	})
end

local function get_icon(filename, name)
	local ok, devicons = pcall(require, "nvim-web-devicons")

	if not ok or not name or name == "" then
		return ""
	end

	local ext = vim.fn.fnamemodify(name, ":e")

	local icon = devicons.get_icon(filename, ext, {
		default = true,
	})
	return icon and (icon .. " ") or ""
end

local function get_display_name(path)
	if path == "" then
		return NO_NAME
	end

	local parts = vim.split(path, "/", { plain = true })

	if #parts == 1 then
		return parts[1]
	elseif #parts == 2 then
		return parts[#parts - 1] .. "/" .. parts[#parts]
	else
		return parts[#parts - 2] .. "/" .. parts[#parts - 1] .. "/" .. parts[#parts]
	end
end

--[[ local function get_project_relative_path(path)
	if path == "" then
		return NO_NAME
	end

	local root = vim.fs.root(path, {
		".git",
		"package.json",
		"turbo.json",
		"pnpm-workspace.yaml",
		"go.mod",
		"Cargo.toml",
	})

	-- fallback jika root tidak ditemukan
	if not root then
		return vim.fn.fnamemodify(path, ":~:.")
	end

	local rel = vim.fs.relpath(root, path)

	return rel or vim.fn.fnamemodify(path, ":~:.")
end ]]

local function render_tab(tabpage, index, current)
	-- IMPORTANT:
	-- get ACTIVE window of tabpage,
	-- not first window
	local win = vim.api.nvim_tabpage_get_win(tabpage)

	if not win or not vim.api.nvim_win_is_valid(win) then
		return ""
	end

	local bufnr = vim.api.nvim_win_get_buf(win)

	if not vim.api.nvim_buf_is_loaded(bufnr) then
		return ""
	end

	local name = vim.api.nvim_buf_get_name(bufnr)

	local display_name = get_display_name(name)

	local filename = (name ~= "" and vim.fn.fnamemodify(name, ":t")) or NO_NAME

	local icon = get_icon(filename, name)

	local modified = vim.bo[bufnr].modified and " ●" or ""

	local content = icon .. display_name .. modified

	if current then
		return table.concat({
			"%#MyTabActive# ",
			"%#MyTabIndex#",
			index,
			" ",
			"%#MyTabActive#",
			content,
			" %#MyTabSeparator#",
			SEP,
		})
	else
		return table.concat({
			"%#MyTabInactive# ",
			index,
			" ",
			content,
			"  %#MyTabSeparator#",
			SEP,
		})
	end
end

function _G.tabline()
	local current_tab = vim.api.nvim_get_current_tabpage()

	local tabs = vim.api.nvim_list_tabpages()

	local parts = {}

	for index, tabpage in ipairs(tabs) do
		local current = tabpage == current_tab

		local chunk = render_tab(tabpage, index, current)

		if chunk ~= "" then
			table.insert(parts, chunk)
		end
	end

	if #parts == 0 then
		return ""
	end

	return table.concat(parts)
end

function M.setup()
	M.set_highlights()

	local group = augroup("main")

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = M.set_highlights,
	})

	vim.api.nvim_create_autocmd({
		"TabNew",
		"TabClosed",
		"TabEnter",
		"TabLeave",

		"WinEnter",
		"WinClosed",
		"WinNew",

		"BufEnter",
		"BufModifiedSet",
		"BufWinEnter",
		"BufWinLeave",
	}, {
		group = group,
		callback = function()
			-- force redraw tabline
			vim.cmd.redrawtabline()
		end,
	})
	vim.opt.showtabline = 2

	vim.opt.tabline = "%!v:lua.tabline()"
end

M.setup()

return M
