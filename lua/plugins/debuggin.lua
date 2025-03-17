return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope.nvim", -- For debugger menu
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            local dap_virtual_text = require("nvim-dap-virtual-text")
            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values

            -- 🔥 Setup DAP UI
            dapui.setup({
                icons = {
                    expanded = '▾',
                    collapsed = '▸',
                    current_frame = '',
                }
            })

            -- 🔥 Setup DAP Virtual Text
            dap_virtual_text.setup({
                enabled = true,
                virtual_text = true,
                virtual_text_pos = 'eol',
                comments_only = false,
                all_frames = true,
                enhanced_text = true,
            })

            -- 🔥 Configure DAP Adapters (Python Example)
            dap.adapters.python = {
                type = "executable",
                command = "/Users/admin/.pyenv/shims/python",
                args = { "-m", "debugpy.adapter" },
            }

            -- 🔥 Configure DAP for Python Debugging
            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch File",
                    program = "${file}",
                    pythonPath = function()
                        return "/Users/admin/.pyenv/shims/python"
                    end,
                },
            }

            -- 🔥 Automatically Open/Close DAP UI
            dap.listeners.after["event_initialized"]["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.after["event_terminated"]["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.after["event_exited"]["dapui_config"] = function()
                dapui.close()
            end

            dap.listeners.after["event_terminated"]["notify"] = function()
                vim.notify("Debugging session terminated.", vim.log.levels.INFO)
            end
            dap.listeners.after["event_exited"]["notify"] = function()
                vim.notify("File successfully debugged!", vim.log.levels.INFO)
            end

            -- 🔥 Debugger Menu with Telescope
            local function debug_menu()
                local options = {
                    { name = 'Start Debugging',   action = function() dap.continue() end },
                    { name = 'Step Over',         action = function() dap.step_over() end },
                    { name = 'Step Into',         action = function() dap.step_into() end },
                    { name = 'Step Out',          action = function() dap.step_out() end },
                    { name = 'Toggle Breakpoint', action = function() dap.toggle_breakpoint() end },
                    { name = 'Stop Debugging',    action = function() dap.terminate() end },
                }

                pickers.new({}, {
                    prompt_title = 'Debugger Menu',
                    finder = finders.new_table {
                        results = options,
                        entry_maker = function(entry)
                            return {
                                value = entry,
                                display = entry.name,
                                ordinal = entry.name,
                            }
                        end,
                    },
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(prompt_bufnr)
                        local actions = require('telescope.actions')
                        actions.select_default:replace(function()
                            actions.close(prompt_bufnr)
                            local selection = require('telescope.actions.state').get_selected_entry()
                            if selection then
                                selection.value.action()
                            end
                        end)
                        return true
                    end,
                }):find()
            end

            -- 🔥 Key Mappings for Debugging
            vim.keymap.set("n", "<Leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<Leader>dc", function() dap.continue() end, { desc = "Continue Execution" })
            vim.keymap.set("n", "<Leader>ds", function() dap.step_over() end, { desc = "Step Over" })
            vim.keymap.set("n", "<Leader>di", function() dap.step_into() end, { desc = "Step Into" })
            vim.keymap.set("n", "<Leader>do", function() dap.step_out() end, { desc = "Step Out" })
            vim.keymap.set("n", "<Leader>dr", function() dap.repl.open() end, { desc = "Open REPL" })
            vim.keymap.set("n", "<Leader>du", function() dapui.toggle() end, { desc = "Toggle Debugger UI" })

            -- Fix: Direct function call for the key mapping
            vim.keymap.set("n", "<Leader>dm", debug_menu, { desc = "Open Debugger Menu" })
        end,
    },
}
