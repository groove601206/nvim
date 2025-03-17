return {
    -- Neotest with Python adapter and DAP for debugging
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/neotest-python", -- Python adapter for neotest
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "mfussenegger/nvim-dap",             -- DAP support
            "rcarriga/nvim-dap-ui",              -- DAP UI for better visual debugging
            "nvim-telescope/telescope-dap.nvim", -- Optional: To integrate with telescope
        },
        config = function()
            local neotest = require("neotest")

            neotest.setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        args = { "--log-level", "DEBUG" },
                        runner = "pytest",
                        python = "/Users/admin/.pyenv/shims/python3", -- Adjust for pyenv or venv
                        is_test_file = function(file_path)
                            return file_path:match("test_") or file_path:match("_test%.py$")
                        end,
                        pytest_discover_instances = true,
                        test_suite = function(file_path)
                            if file_path:match("tests/unit/") then
                                return "Unit Tests"
                            elseif file_path:match("tests/integration/") then
                                return "Integration Tests"
                            else
                                return "Miscellaneous Tests"
                            end
                        end,
                    }),
                },
                loglevel = vim.log.levels.INFO,
                floating = nil,          -- Disable floating windows entirely
                strategy = "integrated", -- Use integrated terminal strategy
                summary = { enabled = true },
                output = { open_on_run = true },
                diagnostics = { virtual_text = true },
                icons = { passed = "✔️", running = "⏳", failed = "❌" },
            })

            -- DAP Configuration for Python Debugging
            local dap = require("dap")
            dap.adapters.python = {
                type = "executable",
                command = "/Users/admin/.pyenv/shims/python3", -- Path to your python executable
                args = { "-m", "debugpy.adapter" },
            }
            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    pythonPath = "/Users/admin/.pyenv/shims/python3", -- Adjust as needed
                },
            }

            -- Keymaps for Neotest with Debugging
            -- Leader-based keymaps
            vim.keymap.set("n", "<leader>tt", function() neotest.run.run() end, { desc = "Run nearest test" })
            vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,
                { desc = "Run all tests in file" })
            vim.keymap.set("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end,
                { desc = "Debug nearest test" })
            vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
            vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end,
                { desc = "Show test output" })
            vim.keymap.set("n", "<leader>tO", function() neotest.output_panel.toggle() end,
                { desc = "Toggle output panel" })
            vim.keymap.set("n", "<leader>tn", function() neotest.run.run({ suite = false }) end,
                { desc = "Run next test" })
            vim.keymap.set("n", "<leader>ta", function() neotest.run.run({ suite = true }) end,
                { desc = "Run all tests" })
            vim.keymap.set("n", "<leader>tS", function() neotest.run.stop() end, { desc = "Stop running tests" })

            -- Control-based keymaps for DAP and Neotest
            vim.keymap.set("n", "<C-t>n", "<Cmd>Neotest run<CR>", { desc = "Run all tests" })
            vim.keymap.set("n", "<C-t>f", "<Cmd>Neotest run file<CR>", { desc = "Run tests in current file" })
            vim.keymap.set("n", "<C-t>s", "<Cmd>Neotest run suite<CR>", { desc = "Run tests in current suite" })
            vim.keymap.set("n", "<C-t>S", "<Cmd>Neotest run selected<CR>", { desc = "Run selected tests" })
            vim.keymap.set("n", "<C-t>t", "<Cmd>Neotest summary<CR>", { desc = "Toggle Neotest summary UI" })
            vim.keymap.set("n", "<C-t>d", "<Cmd>Neotest jump diagnostics<CR>", { desc = "Jump to test diagnostics" })
            vim.keymap.set("n", "<C-t>r", "<Cmd>Neotest run<CR>", { desc = "Run tests" })

            -- Override Neotest's floating terminal to use horizontal split terminal
            vim.api.nvim_create_autocmd("User", {
                pattern = "NeotestTestOutput",
                callback = function()
                    -- Open a horizontal terminal split for test output
                    vim.cmd("split | terminal")
                end,
            })
        end,
    },
}
