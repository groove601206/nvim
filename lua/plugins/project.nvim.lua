return {
	"ahmedkhalf/project.nvim",
	event = "VeryLazy",
	config = function()
		require("project_nvim").setup({
			detection_methods = { "pattern" },
			patterns = {
				".git",
				"pyproject.toml",
				"package.json",
				"Makefile",
				"setup.cfg",
				"requirements.txt",
			},
			show_hidden = true,
			silent_chdir = false, -- set to true if you don’t want messages
		})

		-- Telescope integration
		require("telescope").load_extension("projects")

		-- Keymap to open project list
		vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find Project" })
	end,
}
