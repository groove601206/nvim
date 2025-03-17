return {
    "stevearc/dressing.nvim",
    config = function()
        require('dressing').setup({
            input = {
                default_prompt = "> ", -- Custom prompt text for input
                relative = "editor", -- Open input prompt relative to editor
            },
            select = {
                backend = { "telescope", "fzf", "builtin" }, -- Customize selection UI
                builtin = {
                    width = 0.5,                     -- Window width for the selection UI
                    max_width = 0.8,                 -- Max width for the window
                    min_width = 30,                  -- Min width for the window
                },
            },
        })
    end,
}
