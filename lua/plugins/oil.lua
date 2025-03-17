return {
    "stevearc/oil.nvim",
    config = function()
        local oil = require("oil")
        oil.setup({
            -- You can customize the setup as per your needs here
            -- For example, you can specify filetypes you want to work with
            filetypes = { "python", "lua", "javascript", "html" }, -- Ensure it handles Python files
        })

        -- Keymap for closing oil
        vim.keymap.set("n", "q", function()
            oil.close()
        end, { desc = "Close Oil" })
    end,
}
