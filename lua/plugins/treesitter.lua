return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			-- Try to update parsers safely
			local ok, _ = pcall(vim.cmd, "TSUpdate")
			if not ok then
				vim.notify("nvim-treesitter: TSUpdate failed during build step", vim.log.levels.WARN)
			end
		end,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				indent = { enable = true },
				ensure_installed = { "lua", "python", "markdown", "markdown_inline", "norg" },
			})

			-- Force .py files to be recognized as Python
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = "*.py",
				callback = function()
					vim.bo.filetype = "python"
				end,
			})
		end,
	},
	{
		"nvim-neorg/neorg",
		lazy = false,
		version = "*",
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/Notes",
							},
							default_workspace = "notes", -- must match workspace
						},
					},
				},
			})

			-- Set folding and conceal for Neorg files
			vim.wo.foldlevel = 99
			vim.wo.conceallevel = 2
		end,
	},
}
