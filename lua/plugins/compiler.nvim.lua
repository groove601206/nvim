return {
    -- Compiler plugin (wrapper around overseer)
    {
        "Zeioth/compiler.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        dependencies = { "stevearc/overseer.nvim" },
        opts = {
            -- Automatically save the current file before running compiler
            auto_save = true,

            -- Choose which compiler to use by default
            default_compiler = "gcc", -- You can change this to "clang", "python", etc.

            -- Enable or disable notifications
            notify_on_compile = true,

            -- Automatically open results after compile
            open_results = true,

            -- Automatically focus the result window
            focus_on_open = true,

            -- Add key mappings to easily select compilers or presets
            show_compilers = true,
        },
        keys = {
            { "<leader>co", "<cmd>CompilerOpen<CR>",          desc = "Compiler Open" },
            { "<leader>ct", "<cmd>CompilerToggleResults<CR>", desc = "Compiler Toggle Results" },
            { "<leader>cr", "<cmd>CompilerRedo<CR>",          desc = "Compiler Redo" },
        },
    },

    -- Overseer task runner
    {
        "stevearc/overseer.nvim",
        commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1,
            },
        },
        keys = {
            { "<leader>cq", "<cmd>OverseerClose<CR>", desc = "Overseer Close" },
        },
    },
}
