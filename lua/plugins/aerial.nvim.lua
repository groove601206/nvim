return {
	"stevearc/aerial.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	config = function()
		require("aerial").setup({
			backends = { "lsp", "treesitter", "markdown" },
			layout = {
				max_width = { 40, 0.25 },
				min_width = 20,
				default_direction = "prefer_right",
			},
			show_guides = true,
			filter_kind = false, -- Show all symbol kinds
			icons = {}, -- Use defaults or integrate with your icon theme
			highlight_on_hover = true,
			autojump = false,
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle! float<CR>", { desc = "Toggle Symbols Outline" })
		vim.keymap.set("n", "]a", "<cmd>AerialNext<CR>", { desc = "Next symbol" })
		vim.keymap.set("n", "[a", "<cmd>AerialPrev<CR>", { desc = "Previous symbol" })
	end,
}
