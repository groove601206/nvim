return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        local bufferline = require("bufferline")

        bufferline.setup({
            options = {
                mode = "buffers",
                numbers = "ordinal",
                close_command = "bdelete! %d", -- Close command for buffer
                right_mouse_command = "bdelete! %d",
                left_mouse_command = "buffer %d",
                middle_mouse_command = nil,
                indicator = { style = "underline" },
                buffer_close_icon = "",
                modified_icon = "●",
                close_icon = "",
                left_trunc_marker = "",
                right_trunc_marker = "",
                max_name_length = 18,
                max_prefix_length = 15,
                tab_size = 20,
                diagnostics = "nvim_lsp",
                diagnostics_update_in_insert = false,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Explorer",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                show_close_icon = false,
                separator_style = { "/", "/" },
                enforce_regular_tabs = false,
                always_show_bufferline = true,
                hover = { enabled = true, delay = 200, reveal = { "close" } },
                sort_by = "insert_after_current",
            },
            highlights = {
                buffer_visible = {
                    fg = "#bbbbbb", -- Inactive buffer text color (gray)
                    italic = true,
                },
                buffer_selected = {
                    fg = "#ffffff", -- Active buffer stays white
                    bold = true,
                },
                diagnostic = { fg = "#ffcc00" }, -- Diagnostic text color
            },
        })

        -- Set inactive Python icon to blue
        vim.api.nvim_set_hl(0, "BufferLineDevIconPythonInactive", { fg = "#7aa2f7" }) -- Blue for inactive Python icon

        -- Set active Python icon to yellow
        vim.api.nvim_set_hl(0, "BufferLineDevIconPython", { fg = "#ffcc00" }) -- Yellow for active Python icon

        -- Keybindings ( Ctrl-b for buffer switching)
        vim.api.nvim_set_keymap("n", "<C-b>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })

        -- Keybinding to close the current buffer with Ctrl+c
        vim.api.nvim_set_keymap("n", "<C-c>", ":bdelete<CR>", { noremap = true, silent = true }) -- Ctrl+c to close the buffer

        -- Hide bufferline on Alpha dashboard
        vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaReady",
            callback = function()
                vim.opt.showtabline = 0
            end,
        })

        -- Restore bufferline when leaving Alpha
        vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaClosed",
            callback = function()
                vim.opt.showtabline = 2
            end,
        })
    end,
}
