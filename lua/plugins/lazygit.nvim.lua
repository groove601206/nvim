return {
	"kdheepak/lazygit.nvim",
	cmd = "LazyGit",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>gg",
			function()
				-- Change to the Neovim config repo
				vim.cmd("cd ~/.config/nvim")
				-- Open LazyGit
				vim.cmd("LazyGit")
			end,
			desc = "Open LazyGit",
		},
	},
}
