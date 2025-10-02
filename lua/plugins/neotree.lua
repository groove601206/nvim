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

	-- Snacks.nvim (normal sidebar)
	{
		"folke/snacks.nvim",
		opts = {
			explorer = {
				replace_netrw = false,
				follow_current_file = true,
				width = 40,
				side = "left",
				hidden = true,
				git_status = true,
				float = false, -- normal split
				border = "none", -- remove border for seamless blend
				icons = { folder_closed = "", folder_open = "", file = "" },
			},
			picker = {
				sources = {
					explorer = {
						show_hidden = true,
						follow = true,
						layout = { width = 0.6, height = 0.6 },
					},
				},
			},
		},
		keys = {
			{
				"<leader>ee",
				function()
					local Snacks = require("snacks")
					if Snacks.explorer.is_open then
						Snacks.explorer.close()
					else
						Snacks.explorer.open()
					end
				end,
				desc = "Toggle Snacks Explorer",
			},
			{
				"<leader>r",
				function()
					require("snacks").explorer.reveal()
				end,
				desc = "Reveal file in Snacks",
			},
		},
		config = function()
			-- Blend Snacks with buffer
			vim.api.nvim_set_hl(0, "SnacksNormal", { bg = "NONE" })
		end,
	},
}
