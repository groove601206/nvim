-- 📜 Clear LSP Log Command
vim.api.nvim_create_user_command("ClearLspLog", function()
    local log_path = vim.lsp.get_log_path()
    if not log_path then
        print("❌ LSP log path not found!")
        return
    end
    local file = io.open(log_path, "w")
    if file then
        file:close()
        print("✅ LSP log cleared: " .. log_path)
    else
        print("❌ Failed to clear LSP log")
    end
end, {})

-- ⌨️ Keybinding for Clearing LSP Log
vim.keymap.set("n", "<leader>cl", function()
    vim.cmd("ClearLspLog")
end, { desc = "Clear LSP log" })
