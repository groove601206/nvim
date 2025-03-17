return {
    -- https://github.com/kylechui/nvim-surround
    'kylechui/nvim-surround',
    version = "*",    -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy", -- Load plugin only when needed

    opts = {
        keymaps = {
            -- Add surrounding characters (e.g., ys" for quotes, ys( for parentheses)
            add = "ys", -- "ys" for adding surrounding characters (e.g., ys" to add quotes)

            -- Change surrounding characters (e.g., cs"' to change quotes, cs[]() to change brackets)
            change = "cs", -- "cs" for changing surrounding characters (e.g., cs'\" to change quotes)

            -- Delete surrounding characters (e.g., ds' to delete single quotes)
            delete = "ds", -- "ds" for deleting surrounding characters (e.g., ds' to delete single quotes)
        },

        -- Optional: Additional mappings for adding surrounding characters for different pairs
        mappings = {
            add = {
                ["/*"] = "comment block", -- For adding comment blocks in Python or Lua
                ["<"] = "HTML tag", -- For adding HTML tags (optional, you can remove this if you want)
            },
        },

        -- Customize which filetypes the plugin should be active for (optional)
        filetypes = { "lua", "python" }, -- Only enable for Lua and Python

        -- Customize the motion for selecting surrounding text (e.g., inner word, inner sentence)
        surround_motion = "iw", -- Use "iw" for inner word motion (default)
    }
}
