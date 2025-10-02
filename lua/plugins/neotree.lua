-- plugins/explorer.lua
return {
	-- Neo-tree (hidden by default)
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			-- Remove vertical window separator (portable way)
			vim.opt.fillchars:append({ vert = " " })

			require("neo-tree").setup({
				popup_border_style = "rounded",
				window = {
					position = "left",
					width = 37,
					win_options = {
						number = false,
						relativenumber = false,
						cursorline = false,
						signcolumn = "no",
						foldcolumn = "0",
					},
				},
				filesystem = {
					filtered_items = {
						hide_dotfiles = true,
						hide_by_name = { ".nvim", ".config/nvim" },
					},
				},
			})

			-- Hide Neo-tree windows on startup
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local name = vim.api.nvim_buf_get_name(buf)
						if name:match("neo%-tree") then
							vim.api.nvim_win_close(win, true)
						end
					end
				end,
			})

			-- Toggle Neo-tree manually
			vim.keymap.set("n", "<leader>n", ":Neotree toggle<CR>", { noremap = true, silent = true })

			-- Make Neo-tree blend with buffer
			vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
		end,
	},
}
