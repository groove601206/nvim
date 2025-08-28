return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local tokyonight = require("tokyonight")

        -- Set up theme
        tokyonight.setup({
            style = "night",
            transparent = true,
            terminal_colors = true,
            dim_inactive = true,
        })

        -- Apply colorscheme
        vim.cmd.colorscheme("tokyonight")

        -- Define custom color
        local teal = "#7aa2f7"

        -- Highlight groups to make background transparent
        local transparent_groups = {
            -- Core UI
            "Normal",
            "NormalNC",
            "NormalFloat",
            "FloatBorder",
            "CursorLine",
            "EndOfBuffer",
            "StatusLine",
            "SignColumn",
            "VertSplit",
            "WinSeparator",

            -- Neo-tree
            "NeoTreeNormal",
            "NeoTreeNormalNC",
            "NeoTreeFloatNormal",
            "NeoTreeEndOfBuffer",

            -- Telescope
            "TelescopeNormal",
            "TelescopeBorder",
            "TelescopePromptNormal",
            "TelescopePromptBorder",
            "TelescopeResultsNormal",
            "TelescopeResultsBorder",
            "TelescopePreviewNormal",
            "TelescopePreviewBorder",
        }

        for _, group in ipairs(transparent_groups) do
            vim.api.nvim_set_hl(0, group, { bg = "NONE" })
        end

        -- Apply teal to float and Telescope borders
        local float_border_groups = {
            "FloatBorder",
            "TelescopeBorder",
            "TelescopePromptBorder",
            "TelescopeResultsBorder",
            "TelescopePreviewBorder",
        }

        for _, group in ipairs(float_border_groups) do
            vim.api.nvim_set_hl(0, group, { fg = teal, bg = "NONE" })
        end

        -- EndOfBuffer as background color to hide '~'
        vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#1a1b26", bg = "NONE" })

        -- Remove vertical line between splits
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "NONE", bg = "NONE", nocombine = true })
        vim.opt.fillchars:append({ vert = " " })

        -- Re-apply highlights on colorscheme reload
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                for _, group in ipairs(transparent_groups) do
                    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
                end
                for _, group in ipairs(float_border_groups) do
                    vim.api.nvim_set_hl(0, group, { fg = teal, bg = "NONE" })
                end
                vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#1a1b26", bg = "NONE" })
                vim.api.nvim_set_hl(0, "WinSeparator", { fg = "NONE", bg = "NONE", nocombine = true })
                vim.opt.fillchars:append({ vert = " " })
            end,
        })
    end,
}
