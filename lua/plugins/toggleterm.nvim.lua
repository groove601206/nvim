return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 15,
                open_mapping = nil,
                direction = "horizontal",
                shade_terminals = true,
                shading_factor = 2,
                start_in_insert = true,
                persist_size = true,
                close_on_exit = true,
            })

            vim.cmd("colorscheme tokyonight-moon")

            -- Highlight groups for transparent cyan float terminal
            vim.api.nvim_set_hl(0, "CustomFloatBorder", { fg = "#00ffff", bg = "NONE" })
            vim.api.nvim_set_hl(0, "CustomNormalFloat", { bg = "NONE" })

            local Terminal = require("toggleterm.terminal").Terminal

            -- Floating terminal
            local float_term = Terminal:new({
                cmd = "zsh",
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "rounded",
                    width = 160,
                    height = 50,
                    winblend = 0, -- transparency
                },
                on_open = function(term)
                    vim.api.nvim_win_set_option(
                        term.window,
                        "winhl",
                        "NormalFloat:CustomNormalFloat,FloatBorder:CustomFloatBorder"
                    )
                end,
            })

            -- Horizontal terminal
            local horizontal_term = Terminal:new({
                cmd = "zsh",
                hidden = true,
                direction = "horizontal",
            })

            -- Center floating terminal manually
            local function center_float_term()
                local width = vim.o.columns
                local height = vim.o.lines
                local row = math.floor((height - float_term.float_opts.height) / 2)
                local col = math.floor((width - float_term.float_opts.width) / 2)
                float_term:open()
                vim.api.nvim_win_set_config(float_term.window, {
                    row = row,
                    col = col,
                    relative = "editor",
                })
            end

            -- Keybinding for floating terminal
            vim.keymap.set("n", "<Leader>ft", function()
                float_term:toggle()
                center_float_term()
            end, { desc = "Toggle Floating Terminal" })

            -- Keybinding for horizontal terminal
            vim.keymap.set("n", "<Leader>ht", function()
                horizontal_term:toggle()
            end, { desc = "Toggle Horizontal Terminal" })

            -- Smart jump between terminal and buffer
            local last_win = nil

            vim.keymap.set("n", "<Leader>bt", function()
                local cur_win = vim.api.nvim_get_current_win()
                local cur_buf = vim.api.nvim_get_current_buf()
                local buftype = vim.bo[cur_buf].buftype

                if buftype == "terminal" then
                    if last_win and vim.api.nvim_win_is_valid(last_win) then
                        vim.api.nvim_set_current_win(last_win)
                    end
                    return
                end

                last_win = cur_win
                if horizontal_term.window and vim.api.nvim_win_is_valid(horizontal_term.window) then
                    vim.api.nvim_set_current_win(horizontal_term.window)
                else
                    horizontal_term:open()
                end
            end, { desc = "Jump Terminal ↔ Buffer" })

            vim.keymap.set("t", "<Leader>bt", function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)

                vim.schedule(function()
                    if last_win and vim.api.nvim_win_is_valid(last_win) then
                        vim.api.nvim_set_current_win(last_win)
                    end
                end)
            end, { desc = "Jump Terminal ↔ Buffer", noremap = true })

            -- Keybinding for LazyGit floating terminal
            vim.keymap.set("n", "<leader>lg", function()
                local lazygit = Terminal:new({
                    cmd = "lazygit",
                    hidden = true,
                    direction = "float",
                    float_opts = {
                        border = "rounded",
                        width = 160,
                        height = 50,
                        winblend = 0,
                    },
                    on_open = function(term)
                        vim.api.nvim_win_set_option(
                            term.window,
                            "winhl",
                            "NormalFloat:CustomNormalFloat,FloatBorder:CustomFloatBorder"
                        )
                    end,
                })
                lazygit:toggle()
            end, { desc = "Toggle LazyGit" })
        end,
    },
}
