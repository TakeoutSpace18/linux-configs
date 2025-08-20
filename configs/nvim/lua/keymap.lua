local map = vim.keymap.set

-- File manager
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Move lines
map("n", "<S-j>", ":m .+1<CR>==", { noremap = true })
map("n", "<S-k>", ":m .-2<CR>==", { noremap = true })
map("i", "<S-j>", "<Esc>:m .+1<CR>==gi", { noremap = true })
map("i", "<S-k>", "<Esc>:m .-2<CR>==gi", { noremap = true })
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

-- Global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- Telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "telescope find all files" }
)

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
map("n", "<leader>qS", function()
	require("persistence").select()
end)

-- Load the last session
map("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end)

-- Stop Persistence => session won't be saved on exit
map("n", "<leader>qd", function()
	require("persistence").stop()
end)

-- Hex view toggle
map("n", "<leader>ht", function()
	require("hex").toggle()
end)
