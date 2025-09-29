--The `lua/reference/pylsp.lua` file contains a sample configuration for the Python LSP `pylsp`.  
--It's **not loaded automatically** in my Neovim setup — it's here as a reference for those who prefer `pylsp` over `pyright`.




return {
	{
		"williamboman/mason-lspconfig.nvim",
		tag = "v1.32.0",
		dependencies = {
			{ "williamboman/mason.nvim", tag = "v2.0.0" },
			{ "neovim/nvim-lspconfig", tag = "v0.1.7" },
		},
		event = "VeryLazy",
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")

			-- Optional: neodev for better Lua experience
			local ok_neodev, neodev = pcall(require, "neodev")
			if ok_neodev then
				neodev.setup({})
			end

			-- Keymaps on attach
			local on_attach = function(_, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }

				vim.keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, {
					buffer = bufnr,
					desc = "Signature Help",
					silent = true,
				})

				vim.keymap.set(
					"n",
					"<leader>ca",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "Code Action" })
				)

				vim.keymap.set(
					"v",
					"<leader>ca",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "Range Code Action" })
				)

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
			end

			-- Setup Mason and ensure servers
			mason_lspconfig.setup({
				ensure_installed = { "lua_ls", "pylsp" },
				automatic_installation = false,
			})

			-- Determine capabilities (cmp optional)
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
			if ok_cmp then
				capabilities = cmp.default_capabilities(capabilities)
			end

			local function get_python_path(workspace)
				if vim.env.VIRTUAL_ENV then
					return vim.env.VIRTUAL_ENV .. "/bin/python"
				end

				local poetry = vim.fn.glob(workspace .. "/poetry.lock")
				if poetry ~= "" then
					local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
					if vim.v.shell_error == 0 then
						return venv .. "/bin/python"
					end
				end

				local candidates = {
					workspace .. "/.venv/bin/python",
					workspace .. "/venv/bin/python",
				}
				for _, path in ipairs(candidates) do
					if vim.fn.executable(path) == 1 then
						return path
					end
				end

				return vim.fn.exepath("python3") or "python"
			end

			-- Manual server setup
			local servers = {
				lua_ls = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						root_dir = function(fname)
							return require("lspconfig.util").find_git_ancestor(fname) or vim.fn.getcwd()
						end,
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = { globals = { "vim" } },
								workspace = { checkThirdParty = false },
							},
						},
					})
				end,

				pylsp = function()
					local util = require("lspconfig.util")
					local root =
						util.root_pattern(".git", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt")
					local cwd = vim.fn.getcwd()
					local root_dir = root(cwd) or util.path.dirname(cwd)
					local python = get_python_path(root_dir)

					lspconfig.pylsp.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						root_dir = root,
						cmd = { python, "-m", "pylsp" },
						settings = {
							pylsp = {
								plugins = {
									pycodestyle = { enabled = false },
									pyflakes = { enabled = true },
									mccabe = { enabled = true },
									black = { enabled = true },
									rope_autoimport = { enabled = true },
									pylsp_rope = { enabled = true },
									pylsp_mypy = { enabled = false },
									jedi_completion = { enabled = true, fuzzy = true },
									jedi_signature_help = { enabled = true },
									jedi_hover = { enabled = true },
								},
							},
						},
					})
				end,
			}

			mason_lspconfig.setup_handlers({
				function(server_name)
					if servers[server_name] then
						servers[server_name]()
					else
						lspconfig[server_name].setup({
							capabilities = capabilities,
							on_attach = on_attach,
						})
					end
				end,
			})

			-- Inline diagnostics popup
			vim.api.nvim_create_autocmd("CursorHold", {
				pattern = "*",
				callback = function()
					vim.diagnostic.open_float(nil, {
						focusable = false,
						border = "rounded",
						source = "always",
						header = "",
						prefix = " ",
					})
				end,
			})
		end,
	},
}
