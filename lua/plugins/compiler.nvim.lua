return {
    -- This plugin
    {
        "Zeioth/compiler.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
        opts = {},
    },

    -- The task runner we use
    {
        "stevearc/overseer.nvim",
        commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1,
            },
        },
    },

    -- Keymaps for the commands
    vim.api.nvim_set_keymap("n", "<leader>co", ":CompilerOpen<CR>", { noremap = true, silent = true }),
    vim.api.nvim_set_keymap("n", "<leader>ct", ":CompilerToggleResults<CR>", { noremap = true, silent = true }),
    vim.api.nvim_set_keymap("n", "<leader>cr", ":CompilerRedo<CR>", { noremap = true, silent = true }),

    -- Keymap to quit or close the task list
    vim.api.nvim_set_keymap("n", "<leader>cq", ":OverseerClose<CR>", { noremap = true, silent = true }),
}
