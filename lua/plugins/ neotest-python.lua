return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/neotest-python",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            local neotest = require("neotest")
            local runtime = require("utils.runtime")

            local function notify(msg, level)
                vim.notify(msg, level or vim.log.levels.INFO)
            end

            neotest.setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        args = { "--log-level", "DEBUG" },
                        runner = "pytest",
                        python = runtime.get_python_path() or "python",
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
                log_level = vim.log.levels.INFO,
                strategy = "integrated",
                summary = { enabled = true },
                output = { enabled = true, open_on_run = "short" },
            })

            local keymaps = {
                -- Close output if open
                ["<leader>tc"] = function()
                    local buf = vim.api.nvim_get_current_buf()
                    if vim.bo[buf].filetype == "neotest-output" then
                        vim.cmd("quit")
                        notify("Test output closed")
                    else
                        notify("No test output window open", vim.log.levels.WARN)
                    end
                end,
                -- Run tests in current file
                ["<leader>tt"] = function()
                    local file = vim.fn.expand("%")
                    notify("Running tests in " .. file)
                    neotest.run.run(file)
                end,
                -- Run nearest test
                ["<leader>tn"] = function()
                    notify("Running nearest test")
                    neotest.run.run()
                end,
                -- Toggle test summary
                ["<leader>ts"] = function()
                    neotest.summary.toggle()
                end,
                -- Show test output
                ["<leader>to"] = function()
                    neotest.output.open({ enter = true })
                end,
                -- Toggle output panel
                ["<leader>tp"] = function()
                    neotest.output_panel.toggle()
                end,
            }

            for key, fn in pairs(keymaps) do
                vim.keymap.set("n", key, fn, { desc = "Neotest: " .. key })
            end
        end,
    },
}
