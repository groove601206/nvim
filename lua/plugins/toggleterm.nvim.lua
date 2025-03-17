return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 15,                -- Default height for horizontal terminals
                open_mapping = nil,       -- Disable default mappings
                direction = "horizontal", -- Default direction (horizontal)
                shade_terminals = true,
                shading_factor = 2,
                start_in_insert = true,
                persist_size = true,
                close_on_exit = true,
            })

            local Terminal = require("toggleterm.terminal").Terminal

            -- Define horizontal terminal with Zsh
            local horizontal_term = Terminal:new({
                cmd = "zsh",              -- Change to Zsh shell
                hidden = true,
                direction = "horizontal", -- Horizontal terminal
            })

            -- Define vertical terminal with Zsh (making it wider by setting size to 60)
            local vertical_term = Terminal:new({
                cmd = "zsh",            -- Change to Zsh shell
                hidden = true,
                direction = "vertical", -- Vertical terminal
                size = 60,              -- Increased size to make the terminal even wider
            })

            -- Define floating terminal with Zsh and adjusted size for a "popup" feel
            local float_term = Terminal:new({
                cmd = "zsh",            -- Change to Zsh shell
                hidden = true,
                direction = "float",    -- Floating terminal
                float_opts = {
                    border = "rounded", -- Rounded border for a smoother look
                    width = 100,        -- Increased width to make the terminal larger
                    height = 30,        -- Increased height to make the terminal larger
                    winblend = 0,       -- No transparency (clear background)
                },
                -- Apply green border color to the floating terminal
                highlights = {
                    Normal = { fg = "#c0caf5", bg = "#1a1b26" },      -- Adjust foreground and background colors to match Tokyo Night
                    FloatBorder = { fg = "#50fa7b", bg = "#1a1b26" }, -- Green border color for the floating terminal
                },
            })

            -- Function to center the floating terminal
            local function center_float_term()
                -- Get the dimensions of Neovim's window
                local width = vim.o.columns
                local height = vim.o.lines
                -- Calculate the position (center the terminal)
                local row = math.floor((height - float_term.float_opts.height) / 2)
                local col = math.floor((width - float_term.float_opts.width) / 2)

                -- Update the floating terminal position after it's opened
                float_term:open() -- Open the terminal to apply position
                vim.api.nvim_win_set_config(float_term.window, {
                    row = row,
                    col = col,
                    relative = "editor", -- Set relative to the editor for floating windows
                })                       -- Set window position
            end

            -- Keybinding for floating terminal that won't conflict with Neotest
            vim.keymap.set("n", "<Leader>ft", function()
                float_term:toggle()
                -- Recalculate and center the floating terminal after toggling
                center_float_term()
            end, { desc = "Toggle Floating Terminal" })

            -- Keybindings to toggle different terminals
            vim.keymap.set("n", "<Leader>th", function()
                horizontal_term:toggle()
            end, { desc = "Toggle Horizontal Terminal" })

            vim.keymap.set("n", "<Leader>tv", function()
                vertical_term:toggle()
            end, { desc = "Toggle Vertical Terminal" })

            -- Keybinding to close all terminals
            vim.keymap.set("n", "<Leader>tq", function()
                vim.cmd("ToggleTermExit")
            end, { desc = "Close All Terminals" })
        end,
    },
}
