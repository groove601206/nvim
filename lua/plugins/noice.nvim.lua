return {
    {
        -- For cmdline completion integration
        "hrsh7th/cmp-cmdline",
        requires = {
            "hrsh7th/nvim-cmp", -- nvim-cmp is a dependency for cmp-cmdline
        },
        config = function()
            local cmp = require("cmp")

            -- Setup cmp for cmdline completion
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "cmdline" }, -- Use the cmdline completion source
                    { name = "path" },    -- Add file path completions (optional)
                },
                window = {
                    completion = {
                        border = "rounded",                                                  -- Rounded borders for the popup menu
                        winhighlight = "Normal:TelescopeNormal,FloatBorder:TelescopeBorder", -- Apply Telescope border highlight
                    },
                },
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" }, -- Use buffer completions for search
                },
                window = {
                    completion = {
                        border = "rounded",                                                  -- Rounded borders
                        winhighlight = "Normal:TelescopeNormal,FloatBorder:TelescopeBorder", -- Apply Telescope border highlight
                    },
                },
            })

            -- Set up custom highlights for a colored UI
            vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#1e1e2e", fg = "#cba6f7" })       -- Purple border
            vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#1e1e2e", fg = "#f5e0dc" })       -- Light text
            vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#1e1e2e", bg = "#f38ba8" })  -- Red title
            vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#f38ba8", bg = "#1e1e2e" }) -- Red border for prompt
            vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = "#f5e0dc", bg = "#1e1e2e" }) -- Text inside prompt
            vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#1e1e2e", bg = "#89b4fa" })    -- Blue highlight for selected item
            vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#fab387", bold = true })        -- Orange highlight for matched text
        end,
    },

    -- Noice.nvim
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify", -- OPTIONAL: For notification support
        },
    },
}
