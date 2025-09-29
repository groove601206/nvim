return {
    {
        -- For cmdline completion integration
        "hrsh7th/cmp-cmdline",
        dependencies = {
            "hrsh7th/nvim-cmp", -- nvim-cmp is a dependency for cmp-cmdline
        },
        config = function()
            local cmp = require("cmp")

            -- Setup cmp for cmdline completion
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "cmdline" }, -- Use the cmdline completion source
                    { name = "path" }, -- Add file path completions (optional)
                },
                window = {
                    completion = {
                        border = "rounded",
                        winhighlight = "Normal:TelescopeNormal,FloatBorder:TelescopeBorder",
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
                        border = "rounded",
                        winhighlight = "Normal:TelescopeNormal,FloatBorder:TelescopeBorder",
                    },
                },
            })

            -- Set up custom highlights for Telescope UI
            vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#1e1e2e", fg = "#cba6f7" })
            vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#1e1e2e", fg = "#f5e0dc" })
            vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#1e1e2e", bg = "#f38ba8" })
            vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#f38ba8", bg = "#1e1e2e" })
            vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = "#f5e0dc", bg = "#1e1e2e" })
            vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#1e1e2e", bg = "#89b4fa" })
            vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#fab387", bold = true })
        end,
    },

    -- Noice.nvim with notify disabled
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            notify = {
                enabled = false, -- Disable Noice from overriding vim.notify
            },
        },
    },

    -- Keybindings for Telescope functionality
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local actions = require("telescope.actions")
            local telescope = require("telescope")

            -- Telescope keymaps
            vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true })

            -- Optional: Set up other Telescope mappings
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<Esc>"] = actions.close, -- Close the Telescope prompt with Escape
                            ["<C-u>"] = false, -- Disable Ctrl+u (to avoid default scroll behavior)
                            ["<C-d>"] = false, -- Disable Ctrl+d (to avoid default scroll behavior)
                        },
                    },
                },
            })
        end,
    },
}
