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

			-- 🔧 Инициализация Mason
			mason.setup()

			mason_null_ls.setup({
				ensure_installed = {
					"black",
					"isort",
					"mypy",
					"pylint",
					"debugpy",
					"stylua",
				},
				automatic_installation = true,
			})

			-- 📍 Путь к бинарникам из виртуального окружения
			local function venv_bin(executable)
				local venv = os.getenv("VIRTUAL_ENV")
				if venv then
					local path = venv .. "/bin/" .. executable
					if vim.fn.executable(path) == 1 then
						return path
					end
				end
				return executable
			end

			-- 📂 Определение корня проекта
			local root_dir = require("null-ls.utils").root_pattern(".git", "pyproject.toml", "setup.cfg", "setup.py")

			-- 🚀 Настройка null-ls
			null_ls.setup({
				autostart = true,
				root_dir = root_dir,
				sources = {
					null_ls.builtins.formatting.black.with({
						command = venv_bin("black"),
						extra_args = { "--fast" },
					}),
					null_ls.builtins.formatting.isort.with({
						command = venv_bin("isort"),
					}),
					null_ls.builtins.diagnostics.mypy,
					null_ls.builtins.diagnostics.pylint.with({
						extra_args = {
							"--rcfile",
							"/Users/michael/Project/.pylintrc",
						},
					}),
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.code_actions.refactoring,
				},
				on_attach = function(client, bufnr)
					-- ✅ Включение диагностик по-новому для Neovim 0.11+
					vim.diagnostic.enable(bufnr)
				end,
			})

			-- 💾 Форматировать при сохранении (только через null-ls)
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

			-- 🔁 Клавиши
			vim.keymap.set("n", "<leader>oi", function()
				vim.cmd("!isort %")
			end, { desc = "Organize Imports (isort)" })

			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
				desc = "Code Action",
			})
		end,
	},
}
