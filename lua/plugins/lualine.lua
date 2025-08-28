return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
        local colors = {
            blue = "#7aa2f7",
            green = "#9ece6a",
            purple = "#bb9af7",
            cyan = "#7dcfff",
            red1 = "#f7768e",
            red2 = "#db4b4b",
            yellow = "#e0af68",
            fg = "#c0caf5",
            bg = "#1a1b26",
            gray1 = "#565f89",
            gray2 = "#1f2335",
            gray3 = "#292e42",
        }

        local tokyonight_theme = {
            normal = {
                a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
                b = { fg = colors.fg, bg = colors.gray3 },
                c = { fg = colors.fg, bg = colors.gray2 },
            },
            insert = { a = { fg = colors.bg, bg = colors.green, gui = "bold" } },
            visual = { a = { fg = colors.bg, bg = colors.red1, gui = "bold" } },
            replace = { a = { fg = colors.bg, bg = colors.red2, gui = "bold" } },
            command = { a = { fg = colors.bg, bg = colors.yellow, gui = "bold" } },
            terminal = { a = { fg = colors.bg, bg = colors.cyan, gui = "bold" } },
            inactive = {
                a = { fg = colors.gray1, bg = colors.bg, gui = "bold" },
                b = { fg = colors.gray1, bg = colors.bg },
                c = { fg = colors.gray1, bg = colors.gray2 },
            },
        }

        local mode = {
            "mode",
            fmt = function(str)
                return " " .. str
            end,
        }

        local filename = {
            "filename",
            file_status = true,
            path = 0,
        }

        local hide_in_width = function()
            return vim.fn.winwidth(0) > 100
        end

        local diagnostics = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            colored = false,
            update_in_insert = false,
            always_visible = false,
            cond = hide_in_width,
        }

        local diff = {
            "diff",
            colored = false,
            symbols = { added = " ", modified = " ", removed = " " },
            cond = hide_in_width,
        }

        local lsp_progress = {
            function()
                local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
                if #clients > 0 then
                    return require("lsp-progress").status()
                end
                return ""
            end,
            cond = hide_in_width,
        }

        local mason_status = {
            function()
                local installed = require("mason-tool-installer").installed()
                local missing = require("mason-tool-installer").missing()
                if #installed > 0 then
                    return " Tools: " .. #installed .. " installed"
                elseif #missing > 0 then
                    return " Tools: " .. #missing .. " missing"
                end
                return " Tools: No tools"
            end,
            cond = hide_in_width,
        }

        local dap_status = {
            function()
                return " " .. require("dap").status()
            end,
            cond = function()
                return require("dap").session() ~= nil
            end,
        }

        local debug_status = {
            function()
                if _G.debug_autocmd_enabled then
                    return " Dbg: ON"
                else
                    return " Dbg: OFF"
                end
            end,
            color = function()
                if _G.debug_autocmd_enabled then
                    return { fg = "#000000" }
                else
                    return { fg = "#565f89" }
                end
            end,
        }

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = tokyonight_theme,
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                disabled_filetypes = { "alpha", "neo-tree", "dashboard", "Avante" },
                always_divide_middle = true,
                globalstatus = true,
                winblend = 20,
            },
            sections = {
                lualine_a = { mode },
                lualine_b = { "branch" },
                lualine_c = { filename },
                lualine_x = {
                    diagnostics,
                    diff,
                    dap_status,
                    { "encoding", cond = hide_in_width },
                    { "filetype", cond = hide_in_width },
                    lsp_progress,
                    mason_status,
                },
                lualine_y = { "location" },
                lualine_z = {
                    debug_status,
                    "progress",
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { { "location", padding = 0 } },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = { "fugitive" },
        })
    end,
}
