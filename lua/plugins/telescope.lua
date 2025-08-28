return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-file-browser.nvim",
            "nvim-telescope/telescope-symbols.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            "folke/trouble.nvim",
            { "nvim-telescope/telescope-frecency.nvim",   dependencies = { "kkharji/sqlite.lua" } },
            "jvgrootveld/telescope-zoxide",
            "debugloop/telescope-undo.nvim", -- Added undo history extension here
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")
            local map = vim.keymap.set

            -- 🖌️ UI Customization
            vim.cmd.colorscheme("tokyonight")
            vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", fg = "NONE" })
            vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2d3149", fg = "#c0caf5" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = "#565f89" })

            telescope.setup({
                defaults = {
                    prompt_prefix = "🔭 ",
                    selection_caret = " ",
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.5,
                            results_width = 0.5,
                        },
                        width = 0.9,
                        height = 0.65,
                        preview_cutoff = 100,
                    },
                    preview = { title = false },
                    dynamic_preview_title = true,
                    mappings = {
                        i = {
                            ["<C-h>"] = "which_key",
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                        },
                        n = {
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                        },
                    },
                },
                pickers = {
                    colorscheme = {
                        enable_preview = true,
                    },
                },
                extensions = {
                    file_browser = {
                        hijack_netrw = true,
                        grouped = true,
                        hidden = true,
                        previewer = true,
                        layout_config = { height = 40 },
                        mappings = {
                            i = {
                                ["<C-c>"] = actions.close,
                                ["<C-p>"] = require("telescope._extensions.file_browser.actions").create,
                                ["<C-d>"] = require("telescope._extensions.file_browser.actions").remove,
                                ["<C-r>"] = require("telescope._extensions.file_browser.actions").rename,
                            },
                            n = {
                                ["h"] = require("telescope._extensions.file_browser.actions").goto_parent_dir,
                            },
                        },
                    },
                    undo = {
                        use_delta = true,
                        side_by_side = true,
                        layout_strategy = "horizontal",
                        layout_config = {
                            preview_width = 0.6,
                        },
                    },
                },
            })

            -- 🔌 Load Extensions
            telescope.load_extension("fzf")
            telescope.load_extension("file_browser")
            telescope.load_extension("ui-select")
            telescope.load_extension("live_grep_args")
            telescope.load_extension("frecency")
            telescope.load_extension("zoxide")
            telescope.load_extension("undo") -- Load undo extension

            -- 🔍 General Search
            map("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find files" })
            map("n", "<leader>lg", builtin.live_grep, { desc = "Telescope: Live grep" })
            map("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
            map("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope: Old files" })

            -- 🛠️ Developer Productivity
            map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })
            map("n", "<leader>fk", builtin.keymaps, { desc = "Telescope: Keymaps" })
            map("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope: Diagnostics" })
            map("n", "<leader>fs", builtin.symbols, { desc = "Telescope: Symbols" })
            map("n", "<leader>fv", builtin.treesitter, { desc = "Telescope: Treesitter symbols" })
            map("n", "<leader>fc", builtin.commands, { desc = "Telescope: Commands" })
            map("n", "<leader>fH", builtin.command_history, { desc = "Telescope: Command history" })
            map("n", "<leader>f/", builtin.search_history, { desc = "Telescope: Search history" })
            map("n", "<leader>fm", builtin.man_pages, { desc = "Telescope: Man pages" })
            map("n", "<leader>fw", builtin.grep_string, { desc = "Telescope: Find word under cursor" })

            -- 🧠 Project and LSP Tools
            map("n", "<leader>fg", builtin.git_files, { desc = "Telescope: Git files (tracked only)" })
            map("n", "<leader>lr", builtin.lsp_references, { desc = "Telescope: LSP references under cursor" })
            map("n", "<leader>ld", builtin.lsp_definitions, { desc = "Telescope: LSP definitions" })
            map("n", "<leader>lt", builtin.lsp_type_definitions, { desc = "Telescope: LSP type definitions" })
            map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Telescope: Document symbols" })
            map("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Telescope: Workspace symbols" })

            -- ✅ FIXED: Safe Implementation Fallback
            map("n", "<leader>li", function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if clients[1] and clients[1].server_capabilities.implementationProvider then
                    builtin.lsp_implementations()
                else
                    vim.notify("LSP: textDocument/implementation not supported", vim.log.levels.WARN)
                end
            end, { desc = "Telescope: LSP implementations" })

            -- 📁 File Browser
            map("n", "<leader>fe", function()
                telescope.extensions.file_browser.file_browser({
                    grouped = true,
                    hidden = true,
                    previewer = true,
                    initial_mode = "insert",
                    layout_config = { height = 40 },
                })
            end, { desc = "Telescope: File browser (with preview)" })

            -- 🧠 Config Search
            map("n", "<leader>kn", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "Telescope: Find in Neovim config" })

            map("n", "<leader>cn", builtin.builtin, { desc = "Telescope: Builtin pickers" })

            -- 🔍 Advanced Grep
            map("n", "<leader>fa", function()
                if telescope.extensions.live_grep_args then
                    telescope.extensions.live_grep_args.live_grep_args({ prompt_title = "Live Grep with Args" })
                else
                    builtin.live_grep({ prompt_title = "Live Grep (Fallback)" })
                end
            end, { desc = "Telescope: Live grep with args" })

            map("n", "<leader>fr", function()
                telescope.extensions.frecency.frecency({ prompt_title = "Recent Files" })
            end, { desc = "Telescope: Frecency (Recent files)" })

            map("n", "<leader><leader>", function()
                builtin.find_files({
                    prompt_title = "Smart Open",
                    cwd = vim.fn.expand("~/"),
                })
            end, { desc = "Telescope: Smart open" })

            -- 📌 TODO/FIXME
            map("n", "<leader>tf", function()
                local search = [[TODO|FIXME|HACK]]
                if telescope.extensions.live_grep_args then
                    telescope.extensions.live_grep_args.live_grep_args({
                        prompt_title = "TODO/FIXME/HACK",
                        default_text = string.format("-e %s", search),
                    })
                else
                    builtin.live_grep({ prompt_title = "TODO/FIXME/HACK", search = search })
                end
            end, { desc = "Telescope: Search TODO/FIXME/HACK" })

            -- 🔁 Git Utilities
            map("n", "<leader>lgp", function()
                local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
                if git_root == nil or git_root == "" then
                    print("Not inside a Git repository")
                    return
                end
                telescope.extensions.live_grep_args.live_grep_args({
                    prompt_title = "Live Grep with Args (Git Root)",
                    cwd = git_root,
                })
            end, { desc = "Telescope: Live grep with args in Git root" })

            map("n", "<leader>gc", builtin.git_commits, { desc = "Telescope: Git commits" })
            map("n", "<leader>gb", builtin.git_branches, { desc = "Telescope: Git branches" })
            map("n", "<leader>gs", builtin.git_status, { desc = "Telescope: Git status" })

            -- 🌈 UI Utilities
            map("n", "<leader>fR", "<cmd>Telescope resume<cr>", { desc = "Telescope: Resume previous picker" })
            map("n", "<leader>fC", "<cmd>Telescope colorscheme<cr>", { desc = "Telescope: Colorscheme with preview" })

            -- 📂 Zoxide
            map("n", "<leader>fz", function()
                telescope.extensions.zoxide.list({
                    prompt_title = "Zoxide Jump",
                })
            end, { desc = "Telescope: Zoxide (Frequent dirs)" })

            -- 🚀 Undo History keymap added here
            map("n", "<leader>fu", telescope.extensions.undo.undo, { desc = "Telescope: Undo History" })

            -- ✅  Prevent recursion in handler override
            local original_definition_handler = vim.lsp.handlers["textDocument/definition"]
            vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
                ctx.params.position_encoding_kind = "utf-16"
                return original_definition_handler(err, result, ctx, config)
            end
        end,
    },
}
