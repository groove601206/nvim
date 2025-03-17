return {
    {
        "folke/which-key.nvim", -- Specifies the plugin name
        event = "VeryLazy",     -- Loads the plugin lazily when needed
        opts = {},              -- Default options for the plugin
        keys = {
            {
                "<leader>?", -- Keybinding for which-key
                function()
                    require("which-key").show({ global = false })
                end,                                       -- Displays buffer-local keymaps
                desc = "Buffer Local Keymaps (which-key)", -- Description for the keybinding
            },
            {
                "<leader>da",            -- Keybinding for opening the dashboard
                ":Alpha<CR>",            -- Command to open the dashboard (Alpha plugin)
                desc = "Open Dashboard", -- Description for the keybinding
            },
        },
    },
}
