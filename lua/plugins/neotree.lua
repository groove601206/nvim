-- plugins/neo-tree.lua
return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                popup_border_style = "rounded",
                window = {
                    position = "left",
                    width = 37,
                    mappings = {
                        ["o"] = "open",
                        ["<CR>"] = "open",
                    },
                },
                filesystem = {
                    window = {
                        mappings = {
                            ["o"] = "open",
                            ["<CR>"] = "open",
                        },
                    },
                    filtered_items = {
                        hide_dotfiles = true,
                        hide_by_name = {
                            ".nvim",
                            ".config/nvim",
                        },
                    },
                    renderers = {
                        folder = {
                            highlight_opened = true,
                            name = "default",
                            highlight = function(node)
                                local path = node.path or ""
                                if path:match("/%.?config/nvim$") or path:match("/nvim$") then
                                    return "NeoTreeNvimFolder"
                                end
                            end,
                        },
                    },
                },
                default_component_configs = {
                    container = {
                        enable_character_fade = true,
                    },
                    indent = {
                        with_markers = true,
                        with_expanders = true,
                        expander_collapsed = "",
                        expander_expanded = "",
                        expander_highlight = "NeoTreeExpander",
                    },
                    icon = {
                        folder_closed = "",
                        folder_open = "",
                        folder_empty = "",
                        default = "",
                    },
                },
            })

            -- Transparent backgrounds
            local highlights = {
                "NeoTreeNormal",
                "NeoTreeFloatNormal",
                "NeoTreeFileNameOpened",
                "NeoTreeWindowTitle",
                "NeoTreeTitle",
                "NeoTreeDirectoryName",
            }
            for _, hl in ipairs(highlights) do
                vim.api.nvim_set_hl(0, hl, { bg = "NONE" })
            end

            -- Cyan indent lines
            vim.api.nvim_set_hl(0, "NeoTreeExpander", { fg = "#00ffff", bg = "NONE" })

            -- Light brown for 'nvim' folder
            vim.api.nvim_set_hl(0, "NeoTreeNvimFolder", { fg = "#d7a060", bg = "NONE", bold = true })

            -- Keybindings
            vim.keymap.set("n", "<leader>n", ":Neotree toggle<CR>", { noremap = true, silent = true })

            -- Smart toggle Neo-tree
            local last_win = nil
            vim.keymap.set("n", "<leader>e", function()
                local current_win = vim.api.nvim_get_current_win()
                local current_buf = vim.api.nvim_win_get_buf(current_win)
                local buf_name = vim.api.nvim_buf_get_name(current_buf)

                if buf_name:match("neo%-tree") then
                    if last_win and vim.api.nvim_win_is_valid(last_win) then
                        vim.api.nvim_set_current_win(last_win)
                    end
                else
                    last_win = current_win
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        local name = vim.api.nvim_buf_get_name(buf)
                        if name:match("neo%-tree") then
                            vim.api.nvim_set_current_win(win)
                            return
                        end
                    end
                end
            end, { desc = "Toggle between Neo-tree and last buffer" })
        end,
    },
}
