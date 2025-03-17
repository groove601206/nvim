return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = "│" },
			scope = { enabled = true },
			exclude = { filetypes = { "help", "dashboard", "NvimTree", "neo-tree", "lazy" } },
		},
		config = function()
			require("ibl").setup()
		end,
	},
}
