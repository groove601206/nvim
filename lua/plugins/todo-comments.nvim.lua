return {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    optional = true,
    config = function()
        local todo_comments = require("todo-comments")

        todo_comments.setup({
            keywords = {
                FIX = {
                    icon = " ",
                    color = "error",
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning", alt = { "DON SKIP" } },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO", "READ", "COLORS" } },
                TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
        })

        -- Re-sync syntax highlighting on certain events
        vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
            pattern = "*",
            callback = function()
                vim.cmd("syntax sync fromstart")
            end,
        })

        -- Navigation keymaps
        vim.keymap.set("n", "]t", function()
            todo_comments.jump_next()
        end, { desc = "Next todo comment" })

        vim.keymap.set("n", "[t", function()
            todo_comments.jump_prev()
        end, { desc = "Previous todo comment" })

        -- Snacks keymaps (if snacks is installed)
        local has_snacks, snacks = pcall(require, "snacks")
        if has_snacks and snacks.picker then
            vim.keymap.set("n", "<leader>pt", function()
                snacks.picker.todo_comments()
            end, { desc = "Todo" })

            vim.keymap.set("n", "<leader>pT", function()
                snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
            end, { desc = "Todo/Fix/Fixme" })
        end
    end,
}
