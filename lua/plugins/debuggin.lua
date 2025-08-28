--[[
Debugging Configuration for Neovim
Includes:
- nvim-dap with Python support
- nvim-dap-ui (UI panels)
- nvim-dap-virtual-text (inline debugging info)
- Telescope integration for dap commands
- Expression evaluation
--]]

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"mfussenegger/nvim-dap-python",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			local function safe_require(module)
				local ok, mod = pcall(require, module)
				if not ok then
					vim.notify("Error loading " .. module .. ": " .. mod, vim.log.levels.ERROR)
				end
				return mod
			end

			local dap = safe_require("dap")
			local dapui = safe_require("dapui")
			local dap_python = safe_require("dap-python")
			local vt = safe_require("nvim-dap-virtual-text")
			if not dap or not dapui or not dap_python or not vt then
				return
			end

			-- Ensure pyenv shims are in Neovim PATH
			vim.env.PATH = os.getenv("HOME") .. "/.pyenv/shims:" .. vim.env.PATH

			-- Mason DAP setup
			require("mason-nvim-dap").setup({
				automatic_installation = true,
				ensure_installed = { "python" },
			})

			-- Robust function to get Python executable
			local function get_python_path()
				local cwd = vim.fn.getcwd()

				-- 1. Project virtualenv
				local venv_python = cwd .. "/.venv/bin/python"
				if vim.fn.executable(venv_python) == 1 then
					return venv_python
				end

				-- 2. VIRTUAL_ENV environment
				local venv_env = os.getenv("VIRTUAL_ENV")
				if venv_env and vim.fn.executable(venv_env .. "/bin/python") == 1 then
					return venv_env .. "/bin/python"
				end

				-- 3. pyenv active Python
				local pyenv_python = vim.fn.trim(vim.fn.system("pyenv which python 2>/dev/null"))
				if pyenv_python ~= "" and vim.fn.executable(pyenv_python) == 1 then
					return pyenv_python
				end

				-- 4. System Python fallback
				return vim.fn.exepath("python3") or "/usr/bin/python3"
			end

			-- Setup nvim-dap-python with the correct Python
			dap_python.setup(get_python_path(), { justMyCode = false })

			-- DAP UI setup
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "" },
				layouts = {
					{
						elements = { "scopes", "breakpoints", "stacks", "watches" },
						size = 40,
						position = "left",
					},
					{
						elements = { "repl", "console" },
						size = 10,
						position = "bottom",
					},
				},
			})

			-- Virtual text setup
			vt.setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = true,
				show_stop_reason = true,
				commented = false,
				virt_text_pos = "eol",
			})

			-- Auto-open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

			-- Sign definitions
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
			vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "Visual" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })
			vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff5555", bold = true })

			-- Keymaps
			local map = vim.keymap.set
			map("n", "<leader>da", dap.continue, { desc = "Run with Args" })
			map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			map("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, { desc = "Breakpoint Condition" })
			map("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
			map("n", "<leader>dc", dap.continue, { desc = "Run/Continue" })
			map("n", "<leader>de", dapui.eval, { desc = "Evaluate Expression" })
			map("n", "<leader>dg", dap.goto_, { desc = "Go to Line (No Execute)" })
			map("n", "<leader>di", dap.step_into, { desc = "Step Into" })
			map("n", "<leader>do", dap.step_over, { desc = "Step Over" })
			map("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
			map("n", "<leader>dp", dap.pause, { desc = "Pause" })
			map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
			map("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
			map("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
			map("n", "<leader>ds", function()
				local session = dap.session()
				print(session and "Session running: " .. session.config.type or "No active DAP session")
			end, { desc = "Show DAP Session" })
			map("n", "<leader>dw", function()
				local expr = vim.fn.input("Watch expression: ")
				require("dapui").elements.watches.add(expr)
			end, { desc = "Add Watch Expression" })

			-- Telescope integration
			map("n", "<leader>fdc", "<cmd>Telescope dap commands<cr>", { desc = "DAP Commands" })
			map("n", "<leader>fdb", "<cmd>Telescope dap list_breakpoints<cr>", { desc = "Breakpoints" })
			map("n", "<leader>fdF", "<cmd>Telescope dap frames<cr>", { desc = "DAP Frames" })

			-- DAP widgets
			local widgets = require("dap.ui.widgets")
			map("n", "<leader>dh", widgets.hover, { desc = "DAP Hover" })
			map("n", "<leader>dS", function() widgets.centered_float(widgets.scopes) end, { desc = "DAP Scopes Float" })
			map("n", "<leader>dF", function() widgets.centered_float(widgets.frames) end, { desc = "DAP Frames Float" })
		end,
	},
}
