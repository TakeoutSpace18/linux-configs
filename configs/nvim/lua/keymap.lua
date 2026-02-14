local map = vim.keymap.set

-- File manager
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Move lines
map("n", "<S-j>", ":m .+1<CR>==", { noremap = true })
map("n", "<S-k>", ":m .-2<CR>==", { noremap = true })
map("v", "<S-j>", ":m '>+1<CR>gv=gv", { noremap = true })
map("v", "<S-k>", ":m '<-2<CR>gv=gv", { noremap = true })

-- Navigation
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

-- Formatter
map({ "n", "x" }, "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- Telescope
local tb = require("telescope.builtin")
map("n", "<leader>fw", tb.live_grep, { desc = "telescope live grep" })
map("n", "<leader>fb", tb.buffers, { desc = "telescope find buffers" })
map("n", "<leader>fh", tb.help_tags, { desc = "telescope help page" })
map("n", "<leader>ma", tb.marks, { desc = "telescope find marks" })
map("n", "<leader>fo", tb.oldfiles, { desc = "telescope find oldfiles" })
map("n", "<leader>fz", tb.current_buffer_fuzzy_find, { desc = "telescope find in current buffer" })
map("n", "<leader>cm", tb.git_commits, { desc = "telescope git commits" })
map("n", "<leader>gt", tb.git_status, { desc = "telescope git status" })
map("n", "<leader>br", tb.git_branches, { desc = "Git branches" })
map("n", "<leader>ff", tb.find_files, { desc = "telescope find files" })

map("n", "<leader>fa", function()
	tb.find_files({
		follow = true,
		no_ignore = true,
		hidden = true,
	})
end, { desc = "telescope find all files" })

-- Terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- New terminals
map("n", "<leader>th", function()
	vim.cmd("split | term")
	vim.cmd("startinsert")
end, { desc = "New horizontal terminal" })

map("n", "<leader>tv", function()
	vim.cmd("vsplit | term")
	vim.cmd("startinsert")
end, { desc = "New vertical terminal" })

-- Day/night theme switch
map("n", "<leader>tt", function()
	local light = "catppuccin-latte"
	local dark = "kanagawa-wave"

	-- WARN: 'kanagawa-wave' theme name returned by vim.g.colors_name is just 'kanagawa',
	-- so check for light currentTheme first
	local currentTheme = vim.g.colors_name or "none"
	if currentTheme == light then
		vim.cmd("colorscheme " .. dark)
	else
		vim.cmd("colorscheme " .. light)
	end
end, { noremap = true })

-- Theme switch
map("n", "<leader>ts", function()
	require("telescope.builtin").colorscheme({ enable_preview = true })
end, { desc = "Theme switcher" })

-- Session management
-- Load the session for the current directory
map("n", "<leader>qs", function()
	require("persistence").load()
end)

-- Select a session to load
map("n", "<leader>qS", require("persistence").select)

-- Load the last session
map("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end)

-- Stop Persistence => session won't be saved on exit
map("n", "<leader>qd", require("persistence").stop)

-- Hex view toggle
map("n", "<leader>ht", function()
	require("hex").toggle()
end)

-- Show diagnostic message
map('n', '<leader>k', function()
	vim.diagnostic.open_float()
end)

---@param jumpCount number
local function jumpWithVirtLineDiags(jumpCount)
	pcall(vim.api.nvim_del_augroup_by_name, "jumpWithVirtLineDiags") -- prevent autocmd for repeated jumps

	vim.diagnostic.jump { count = jumpCount }

	local initialVirtTextConf = vim.diagnostic.config().virtual_text
	vim.diagnostic.config {
		virtual_text = false,
		virtual_lines = { current_line = true },
	}

	vim.defer_fn(function() -- deferred to not trigger by jump itself
		vim.api.nvim_create_autocmd("CursorMoved", {
			desc = "User(once): Reset diagnostics virtual lines",
			once = true,
			group = vim.api.nvim_create_augroup("jumpWithVirtLineDiags", {}),
			callback = function()
				vim.diagnostic.config { virtual_lines = false, virtual_text = initialVirtTextConf }
			end,
		})
	end, 1)
end

map("n", "ge", function() jumpWithVirtLineDiags(1) end, { desc = "󰒕 Next diagnostic" })
map("n", "gE", function() jumpWithVirtLineDiags(-1) end, { desc = "󰒕 Prev diagnostic" })

-- Toggle zen mode
map("n", "<leader>zz", ":ZenMode<CR>")
