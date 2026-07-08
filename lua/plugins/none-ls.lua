return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local mason = require("mason")
			local mason_null_ls = require("mason-null-ls")
			local fn = vim.fn

			-- Initialize Mason
			mason.setup()

			mason_null_ls.setup({
				ensure_installed = { "black", "isort", "mypy", "stylua", "debugpy" },
				automatic_installation = true,
			})

			-- Helper to find Python executable
			local function find_python(executable)
				local venv = os.getenv("VIRTUAL_ENV")
				if venv and fn.executable(venv .. "/bin/" .. executable) == 1 then
					return venv .. "/bin/" .. executable
				end

				local cwd_venv = fn.getcwd() .. "/.venv/bin/" .. executable
				if fn.executable(cwd_venv) == 1 then
					return cwd_venv
				end

				local pyenv_local = fn.trim(fn.system("pyenv version-name 2>/dev/null"))
				if pyenv_local ~= "" and pyenv_local ~= "system" then
					local pyenv_path = fn.expand("~/.pyenv/versions/" .. pyenv_local .. "/bin/" .. executable)
					if fn.executable(pyenv_path) == 1 then
						return pyenv_path
					end
				end

				return executable
			end

			-- Determine project root
			local root_dir = require("null-ls.utils").root_pattern(".git", "pyproject.toml", "setup.cfg", "setup.py")

			-- Setup none-ls
			null_ls.setup({
				autostart = true,
				root_dir = root_dir,

				sources = {
					-- Formatters
					null_ls.builtins.formatting.black.with({
						command = find_python("black"),
						extra_args = { "--fast" },
					}),

					null_ls.builtins.formatting.isort.with({
						command = find_python("isort"),
					}),

					null_ls.builtins.formatting.stylua,

					-- Diagnostics
					null_ls.builtins.diagnostics.mypy.with({
						command = find_python("mypy"),
						extra_args = { "--show-error-codes", "--no-color-output" },
					}),

					null_ls.builtins.diagnostics.pylint.with({
						command = find_python("pylint"),
						extra_args = { "--output-format=json" },
						condition = function(utils)
							local ok = pcall(fn.system, find_python("pylint") .. " --version")
							return ok
						end,
					}),

					-- Code actions
					null_ls.builtins.code_actions.refactoring,
				},

				on_attach = function(client, bufnr)
					-- nothing needed here for diagnostics in Neovim 0.12
				end,
			})

			-- Format automatically on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.py", "*.lua" },
				callback = function()
					vim.lsp.buf.format({
						async = true,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})

			-- Keymaps
			vim.keymap.set("n", "<leader>oi", function()
				vim.cmd("!isort %")
			end, { desc = "Organize Imports (isort)" })

			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
		end,
	},
}
