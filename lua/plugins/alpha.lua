return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "renerocksai/telekasten.nvim",   -- Telekasten plugin
        "nvim-telescope/telescope.nvim", -- Ensure telescope is installed
    },

    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- ASCII Header on the left side
        dashboard.section.header.val = {
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
        }

        -- Define your slogans
        local slogans = {
            "Stay positive, work hard, make it happen.",
            "Do more of what makes you happy.",
            "Believe you can and you're halfway there.",
            "Success is not the key to happiness. Happiness is the key to success.",
            "Strive for progress, not perfection.",
            "The only limit to our realization of tomorrow is our doubts of today.",
            "The best way to predict the future is to create it."
        }

        -- Function to get a slogan based on the current date
        local function get_slogan_of_the_day()
            local day_of_year = tonumber(os.date("%j"))  -- Get the day of the year (1-365)
            return slogans[(day_of_year % #slogans) + 1] -- Cycle through slogans based on the day
        end

        -- Add the slogan to the footer
        dashboard.section.footer.val = {
            "Slogan of the Day: " .. get_slogan_of_the_day(),
        }

        -- Define buttons with cyan circle dots
        dashboard.section.buttons.val = {
            dashboard.button("h", "Recently opened files", ":Telescope oldfiles<CR>"),
            dashboard.button("f", "Find file", ":Telescope find_files<CR>"),
            dashboard.button("e", "New file", ":lua vim.api.nvim_feedkeys(':e ', 'n', false)<CR>"),
            dashboard.button("b", "Jump to bookmarks", ":Telescope marks<CR>"),
            dashboard.button("n", "Memo New", ":Telekasten new_note<CR>"),
            dashboard.button("t", "Memo Today", ":Telekasten goto_today<CR>"),
            dashboard.button("w", "Memo Week", ":Telekasten goto_thisweek<CR>"),
            dashboard.button("m", "Memo List", ":Telekasten find_notes<CR>"),
            dashboard.button("p", "Update plugins", ":Lazy sync<CR>"),
            dashboard.button("o", "Open NeoTree (Home)", ":Neotree reveal ~/<CR>"),
            dashboard.button("j", "Go to Projects", ":Neotree reveal ~/Projects<CR>"),
            dashboard.button("l", "Find Lua Plugins",
                ":lua require('telescope.builtin').find_files({ search_dirs = { '~/.config/nvim/lua/plugins' }, prompt_title = 'Find Lua Plugins' })<CR>"),
            dashboard.button("q", "Exit", ":qa<CR>"),
        }

        -- Apply the dashboard configuration
        alpha.setup(dashboard.opts)

        -- Set the cursorline background color to dark gray and make it a full line
        vim.cmd([[highlight CursorLine guibg=#2e2e2e]])
        vim.o.cursorline = true -- Enable cursorline

        -- Make the cursor a vertical line
        vim.cmd([[highlight CursorColumn guibg=#2e2e2e]])
    end,
}
