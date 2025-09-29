return {
	{
		"folke/which-key.nvim",
		optional = true,
		opts = {
			spec = {
				{ "<leader>fh", group = "harpoon" },
				{ "<leader>fl", group = "harpoon" }, -- Register the <leader>fl keybinding
			},
		},
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		keys = {
			{
				"<leader>fhm",
				function()
					-- Ensure the current buffer is modifiable before toggling the Harpoon menu
					vim.bo.modifiable = true
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon menu",
			},
			{
				"<leader>fha",
				function()
					-- Ensure the current buffer is modifiable before adding a file to Harpoon
					vim.bo.modifiable = true
					local harpoon = require("harpoon")
					harpoon:list():add()
				end,
				desc = "Harpoon Add File",
			},
			{
				"<leader>fhj",
				function()
					-- Ensure the current buffer is modifiable before switching to the next Harpoon file
					vim.bo.modifiable = true
					local harpoon = require("harpoon")
					harpoon:list():next()
				end,
				desc = "Harpoon Next",
			},
			{
				"<leader>fhk",
				function()
					-- Ensure the current buffer is modifiable before switching to the previous Harpoon file
					vim.bo.modifiable = true
					local harpoon = require("harpoon")
					harpoon:list():prev()
				end,
				desc = "Harpoon Prev",
			},
			{
				"<leader>fl", -- Adding the keybinding for <leader>fl
				function()
					-- Ensure the current buffer is modifiable before opening Harpoon files with Telescope
					vim.bo.modifiable = true
					local harpoon = require("harpoon")
					local themes = require("telescope.themes")
					local conf = require("telescope.config").values

					-- Fetch Harpoon files
					local harpoon_files = harpoon:list()

					-- Check if there are files in the list
					if not harpoon_files or #harpoon_files.items == 0 then
						print("No files in Harpoon list!")
						return
					end

					-- Extract file paths
					local file_paths = {}
					for _, item in ipairs(harpoon_files.items) do
						table.insert(file_paths, item.value)
					end

					-- Setup Telescope picker
					local opts = themes.get_ivy({
						prompt_title = "Harpoon List",
					})

					-- Use Telescope picker to show Harpoon files
					require("telescope.pickers")
						.new(opts, {
							finder = require("telescope.finders").new_table({
								results = file_paths,
							}),
							previewer = conf.file_previewer(opts),
							sorter = conf.generic_sorter(opts),
						})
						:find()
				end,
				desc = "Open Harpoon list with Telescope",
			},
		},
		opts = {
			settings = {
				save_on_toggle = false,
				sync_on_ui_close = false,
			},
		},
		config = function(_, options)
			local status_ok, harpoon = pcall(require, "harpoon")
			if not status_ok then
				return
			end

			---@diagnostic disable-next-line: missing-parameter
			harpoon.setup(options)
			for i = 1, 4 do
				vim.keymap.set("n", "<leader>" .. i, function()
					-- Ensure the current buffer is modifiable before selecting Harpoon files
					vim.bo.modifiable = true
					require("harpoon"):list():select(i)
				end, { noremap = true, silent = true, desc = "Harpoon select " .. i })
			end
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "ThePrimeagen/harpoon" },
	},
}
