return {

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- Recommended but optional
            "MunifTanjim/nui.nvim",        -- Required for the UI components
        },
        config = function()
            -- Keybinding for toggling Neo-tree
            vim.keymap.set('n', '<leader>n', ':Neotree toggle<CR>') -- Toggling NeoTree with the same keybinding

            -- Neo-tree configuration
            require("neo-tree").setup({
                git_status = {
                    symbols = {
                        untracked = "", -- Removes the "?" mark
                    },
                },
            })

            -- Set transparency for Neo-tree background to simulate blur
            vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })     -- Transparent background for NeoTree
            vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })   -- Transparent background for NeoTree when not focused
            vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "NONE" }) -- Transparent cursor line
            vim.api.nvim_set_hl(0, "NeoTreeTabLine", { bg = "NONE" })    -- Transparent background for tab line
            vim.api.nvim_set_hl(0, "NeoTreeTabLineSel", { bg = "NONE" }) -- Transparent selected tab line
        end,
    },
    -- Add other plugins here if needed, with proper commas
}
