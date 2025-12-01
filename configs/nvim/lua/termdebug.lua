-- Enable termdebug
vim.cmd [[packadd termdebug]]

-- Optional: customize window behavior
vim.g.termdebug_wide = 1 -- vertical split layout

-- Enable Variables window automatically
vim.g.termdebug_config = {
    variables_window = 1,         -- show variables automatically
    variables_window_height = 15, -- height if horizontal
    wide = 1,
}

-- Define keys (in a table so we can iterate)
local debug_keys = {
    ["<leader>dg"] = ":Gdb<CR>",
    ["<leader>dr"] = ":Run<CR>",
    ["<leader>db"] = ":Break<CR>",
    ["<leader>dc"] = ":Clear<CR>",
    ["<S-K>"]      = ":Evaluate<CR>",

    ["<F5>"]       = ":Continue<CR>", -- Continue
    ["<F10>"]      = ":Over<CR>",     -- Step over
    ["<F11>"]      = ":Step<CR>",     -- Step into
    ["<F12>"]      = ":Finish<CR>",   -- Step out
    ["<F8>"]       = ":Tbreak<CR>",   -- Add temporary b:reakpoint
    ["<F9>"]       = ":Break<CR>",    -- Add breakpoint
    ["<C-F9>"]     = ":Clear<CR>",    -- Clear breakpoint
}

-- Add mappings when GDB starts
vim.api.nvim_create_autocmd("User", {
    pattern = "TermdebugStartPost",
    callback = function()
        for lhs, rhs in pairs(debug_keys) do
            vim.keymap.set("n", lhs, rhs, { silent = true, buffer = false })
        end
        print("Termdebug: keymaps enabled")
    end,
})

-- Remove mappings when GDB exits
vim.api.nvim_create_autocmd("User", {
    pattern = "TermdebugStopPost",
    callback = function()
        for lhs, _ in pairs(debug_keys) do
            pcall(vim.keymap.del, "n", lhs) -- safe removal
        end
        print("Termdebug: keymaps removed")
    end,
})
