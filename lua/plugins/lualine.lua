return {
    'nvim-lualine/lualine.nvim',
    config = function()
        -- Adapted from: https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/themes/onedark.lua
        local colors = {
            blue = '#61afef',
            green = '#98c379',
            purple = '#c678dd',
            cyan = '#56b6c2',
            red1 = '#e06c75',
            red2 = '#be5046',
            yellow = '#e5c07b',
            fg = '#abb2bf',
            bg = '#282c34',
            gray1 = '#828997',
            gray2 = '#2c323c',
            gray3 = '#3e4452',
            brown = '#8B4513', -- Brown color
        }

        local onedark_theme = {
            normal = {
                a = { fg = colors.bg, bg = colors.blue, gui = 'bold' }, -- Normal mode = Blue
                b = { fg = colors.fg, bg = colors.gray3 },
                c = { fg = colors.fg, bg = colors.gray2 },
            },
            command = { a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' } },
            insert = { a = { fg = colors.bg, bg = colors.green, gui = 'bold' } }, -- Insert mode = Green
            visual = { a = { fg = colors.bg, bg = colors.red1, gui = 'bold' } },  -- Visual mode = Red
            terminal = { a = { fg = colors.bg, bg = colors.cyan, gui = 'bold' } },
            replace = { a = { fg = colors.bg, bg = colors.red1, gui = 'bold' } },
            inactive = {
                a = { fg = colors.gray1, bg = colors.bg, gui = 'bold' },
                b = { fg = colors.gray1, bg = colors.bg },
                c = { fg = colors.gray1, bg = colors.gray2 },
            },
        }

        -- Import color theme based on environment variable NVIM_THEME
        local env_var_nvim_theme = os.getenv 'NVIM_THEME' or 'onedark'

        -- Define a table of themes
        local themes = {
            onedark = onedark_theme,
            nord = 'nord',
        }

        local mode = {
            'mode',
            fmt = function(str)
                return ' ' .. str
            end,
        }

        local filename = {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 0,           -- 0 = just filename, 1 = relative path, 2 = absolute path
        }

        local hide_in_width = function()
            return vim.fn.winwidth(0) > 100
        end

        local diagnostics = {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            sections = { 'error', 'warn' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            colored = false,
            update_in_insert = false,
            always_visible = false,
            cond = hide_in_width,
        }

        local diff = {
            'diff',
            colored = false,
            symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
            cond = hide_in_width,
        }

        local lsp_progress = {
            function()
                local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
                if #clients > 0 then
                    return require('lsp-progress').status() -- Show LSP progress
                end
                return ''
            end,
            cond = hide_in_width,
        }

        local mason_status = {
            function()
                local installed = require('mason-tool-installer').installed()
                local missing = require('mason-tool-installer').missing()
                if #installed > 0 then
                    return " Tools: " .. #installed .. " installed"
                elseif #missing > 0 then
                    return " Tools: " .. #missing .. " missing"
                end
                return " Tools: No tools"
            end,
            cond = hide_in_width,
        }

        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = themes[env_var_nvim_theme], -- Set theme based on environment variable
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                disabled_filetypes = { 'alpha', 'neo-tree', 'dashboard', 'Avante' },
                always_divide_middle = true,
                winblend = 20, -- Transparency (higher values make it more transparent)
            },
            sections = {
                lualine_a = { mode },
                lualine_b = { 'branch' },
                lualine_c = { filename },
                lualine_x = {
                    diagnostics,
                    diff,
                    { 'encoding', cond = hide_in_width },
                    { 'filetype', cond = hide_in_width },
                    lsp_progress, -- Add LSP progress to the statusline
                    mason_status, -- Add mason tool status to the statusline
                },
                lualine_y = { 'location' },
                lualine_z = { 'progress' },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { 'filename', path = 1 } },
                lualine_x = { { 'location', padding = 0 } },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = { 'fugitive' },
        }
    end,
}
