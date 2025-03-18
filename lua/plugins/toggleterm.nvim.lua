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

            -- Load the theme (ensure it's loaded before any custom highlight settings)
            vim.cmd('colorscheme tokyonight-moon')

            local Terminal = require("toggleterm.terminal").Terminal

            -- Define floating terminal with Zsh and adjusted size for a "popup" feel
            local float_term = Terminal:new({
                cmd = "zsh -c 'cd ~/Projects && zsh'", -- Change directory to ~/Projects before starting Zsh
                hidden = true,
                direction = "float",                   -- Floating terminal
                float_opts = {
                    border = "none",                   -- Remove the border
                    width = 100,                       -- Increased width to make the terminal larger
                    height = 30,                       -- Increased height to make the terminal larger
                    winblend = 3,                      -- Adjust the transparency (higher value means more transparent)
                },
                highlights = {
                    Normal = { fg = "#c0caf5", bg = "#1a1b26" },      -- Adjust foreground and background colors to match Tokyo Night Moon
                    FloatBorder = { fg = "#1a1b26", bg = "#1a1b26" }, -- Make the border color match the background (effectively making it borderless)
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

            -- Apply custom highlights after theme load to avoid conflicts
            vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#1a1b26', bg = '#1a1b26' })

            -- Keybinding for floating terminal that won't conflict with Neotest
            vim.keymap.set("n", "<Leader>ft", function()
                float_term:toggle()
                -- Recalculate and center the floating terminal after toggling
                center_float_term()
            end, { desc = "Toggle Floating Terminal" })
        end,
    },
}
