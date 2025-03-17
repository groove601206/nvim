return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local tokyonight = require("tokyonight")

        -- Set up theme options
        local opts = {
            style = "moon",     -- Options: night, storm, day, moon
            transparent = true, -- Enable transparent background for Neovim
            terminal_colors = true,
        }
        tokyonight.setup(opts)

        -- Apply colorscheme
        vim.cmd.colorscheme("tokyonight")

        -- Load theme colors
        local colors = require("tokyonight.colors").setup()
        local util = require("tokyonight.util")

        -- Define custom colors (optional)
        local aplugin = {}
        aplugin.background = colors.bg_dark
        aplugin.my_error = util.darken(colors.red1, 0.3) -- Darken red for error highlights

        -- Apply custom highlights (optional)
        vim.api.nvim_set_hl(0, "MyErrorHighlight", { fg = aplugin.my_error, bold = true })

        -- Set transparent background for CursorLine and Normal (for "blurred" effect)
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" }) -- Simulate transparency with NONE
        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })     -- Simulate transparency for normal background
    end,
}

