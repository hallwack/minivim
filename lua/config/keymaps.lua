local map = vim.keymap.set

--- Keymaps
-- Better paste
map("x", "<leader>v", '"_dP')

-- Exit insert and visual mode
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })
map("v", "aa", "<Esc>", { desc = "Exit visual mode" })

-- Tab navigation
map("n", "<Tab>", "gt", { desc = "Next tab" })
map("n", "<S-Tab>", "gT", { desc = "Previous tab" })
map("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })

-- Resize with arrows
map("n", "<C-M-h>", ":vertical resize -2<CR>", { desc = "Resize window left" })
map("n", "<C-M-l>", ":vertical resize +2<CR>", { desc = "Resize window right" })
map("n", "<C-M-j>", ":resize +2<CR>", { desc = "Resize window down" })
map("n", "<C-M-k>", ":resize -2<CR>", { desc = "Resize window up" })

-- Move text up and down
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })

-- Go to start and end of line
map("n", "==", "gg<S-v>G")
map("n", "gl", "$", { desc = "Go to end of line" })
map("n", "gh", "^", { desc = "Go to start of line" })

-- Location list
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Location List" })
-- Quickfix list
map("n", "<leader>xq", function()
	local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Pack keymaps
map("n", "<leader>pp", "<cmd>Pack<cr>", { desc = "Pack UI" })
map("n", "<leader>pu", "<cmd>lua vim.pack.update()<cr>", { desc = "Pack Update All" })
map("n", "<leader>pd", function()
	vim.ui.input({ prompt = "Plugin name to delete: " }, function(input)
		if input and input ~= "" then
			pcall(vim.pack.del, { input })
		end
	end)
end, { desc = "Pack Delete" })

map("n", "<leader>R", function()
	local session = vim.fn.stdpath("state") .. "/restart_session.vim"
	vim.cmd("mksession! " .. vim.fn.fnameescape(session))
	vim.cmd("restart source " .. vim.fn.fnameescape(session))
end, { desc = "Restart Neovim" })

-- delete marks (use m + character for a mark)
vim.keymap.set("n", "dm", function()
	local mark = vim.fn.getcharstr()
	vim.cmd("delmarks " .. mark)
end, { desc = "Delete mark" })
