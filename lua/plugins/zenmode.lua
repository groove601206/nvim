return {
    {
        "folke/zen-mode.nvim",
        opts = {
            -- You can add your Zen Mode configuration here
        },
        config = function()
            local zen_mode = require("zen-mode")

            -- Keymap to toggle Zen Mode
            vim.keymap.set("n", "<leader>z", zen_mode.toggle, { desc = "Toggle Zen Mode" })
        end
    }
}
