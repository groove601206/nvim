return {
    {
        "goolord/alpha-nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-telescope/telescope.nvim",
            "renerocksai/telekasten.nvim", -- Telekasten for note management
        },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.header.val = {
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
            }

            local slogans = {
                "Stay positive, work hard, make it happen.",
                "Do more of what makes you happy.",
                "Believe you can and you're halfway there.",
                "Success is not the key to happiness. Happiness is the key to success.",
                "Strive for progress, not perfection.",
                "The only limit to our realization of tomorrow is our doubts of today.",
                "The best way to predict the future is to create it.",
            }

            local function get_slogan_of_the_day()
                local day_of_year = tonumber(os.date("%j"))
                return slogans[(day_of_year % #slogans) + 1]
            end

            dashboard.section.footer.val = {
                "Slogan of the Day: " .. get_slogan_of_the_day(),
            }

            dashboard.section.buttons.val = {
                dashboard.button("h", "Recently opened files", ":Telescope oldfiles<CR>"),
                dashboard.button("f", "Find file", ":Telescope find_files<CR>"),
                dashboard.button("e", "New file", ":lua vim.api.nvim_feedkeys(':e ', 'n', false)<CR>"),
                dashboard.button("b", "Jump to bookmarks", ":Telescope marks<CR>"),

                -- Telekasten buttons
                dashboard.button("n", "New Note", ":Telekasten new_note<CR>"),
                dashboard.button("t", "Today’s Note", ":Telekasten goto_today<CR>"),

                dashboard.button("F", "Find Notes", ":Telekasten find_notes<CR>"),
                dashboard.button("s", "Search Notes", ":Telekasten search_notes<CR>"),

                -- Utility
                dashboard.button("u", "Update plugins", ":Lazy sync<CR>"),
                dashboard.button("o", "Open NeoTree (Home)", ":Neotree reveal ~/<CR>"),
                dashboard.button("j", "Go to Projects", ":Neotree reveal " .. vim.fn.expand("~/Project") .. "<CR>"),
                dashboard.button(
                    "l",
                    "Find Lua Plugins",
                    ":lua require('telescope.builtin').find_files({ search_dirs = { '~/.config/nvim/lua/plugins' }, prompt_title = 'Find Lua Plugins' })<CR>"
                ),
                dashboard.button("q", "Exit", ":qa<CR>"),
            }

            alpha.setup(dashboard.opts)

            -- Highlight tweaks
            vim.cmd([[highlight CursorLine guibg=#2e2e2e]])
            vim.o.cursorline = true
            vim.cmd([[highlight CursorColumn guibg=#2e2e2e]])
        end,
    },
}
