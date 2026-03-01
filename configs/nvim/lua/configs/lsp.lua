local on_attach = function(client, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end

	local map = vim.keymap.set
	local tb = require("telescope.builtin")

	-- Hardcode 'Ctrl+]' to cscope for linux repo
	if vim.fn.getcwd() == "/home/pavel/repos/linux" then
		map("n", "<C-]>", ":Cstag <CR>", opts("Go to definition"))
	else
		map("n", "<C-]>", tb.lsp_definitions, opts("Go to definition"))
	end

	map("n", "gd", tb.lsp_definitions, opts("Go to definition"))
	map("n", "gt", tb.lsp_type_definitions, opts("Go to type definition"))
	map("n", "gi", tb.lsp_implementations, opts("Go to implementations"))
	map("n", "gr", tb.lsp_references, opts("Go to references"))

	-- symbols
	map("n", "<leader>ws", tb.lsp_dynamic_workspace_symbols, opts("Workspace symbols"))
	map("n", "<leader>wS", tb.lsp_document_symbols, opts("Document symbols"))

	-- hover
	map("n", "<leader>K", vim.lsp.buf.hover, opts("Symbol documentation"))

	-- call hierarchy
	map("n", "<leader>co", tb.lsp_outgoing_calls, opts("Outgoing calls"))
	map("n", "<leader>ci", tb.lsp_incoming_calls, opts("Incoming calls"))

	-- diagnostics
	map("n", "<leader>ds", tb.diagnostics, opts("Diagnostics"))

	-- code action by Alt+Enter like in JetBrains IDEs
	map("n", "<M-CR>", function()
		vim.lsp.buf.code_action()
	end)

	-- workspace folders
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("List workspace folders"))

	-- clangd special
	map("n", "<leader>ss", ":LspClangdSwitchSourceHeader <cr>", opts("Switch between source/header"))
	map("n", "<leader>si", ":LspClangdShowSymbolInfo <cr>", opts("Show symbol info"))
end

local servers = {
	"gopls",
	"lua_ls",
	"sqlls",
	"clangd",
	"cmake",
	"bashls",
	"basedpyright",
	"ts_ls",
	"jsonls",
	"docker_language_server",
	"yamlls",
	"asm_lsp",
}

local cap = vim.lsp.protocol.make_client_capabilities()

for _, lsp in ipairs(servers) do
	vim.lsp.config(lsp, {
		capabilities = cap,
	})

	vim.lsp.enable(lsp)
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local bufnr = ev.buf
		on_attach(client, bufnr)
	end,
})
