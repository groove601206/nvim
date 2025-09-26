return {
	"rmagatti/auto-session",
	lazy = false,
	keys = {
		{ "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
		{ "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
		{ "<leader>wa", "<cmd>AutoSession toggle-auto-save<CR>", desc = "Toggle autosave" },
	},
	opts = {
		auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions",
		auto_restore_enabled = true,
		auto_save_enabled = true,
		suppressed_dirs = { "~/", "~/Downloads", "/" },

		-- session-lens integration
		session_lens = {
			picker = "telescope", -- or nil to autodetect
			mappings = {
				delete_session = { "i", "<C-D>" },
				alternate_session = { "i", "<C-S>" },
				copy_session = { "i", "<C-Y>" },
			},
			picker_opts = {
				border = true,
				layout_config = {
					width = 0.8,
					height = 0.5,
				},
			},
			load_on_setup = true, -- automatically load Telescope extension
		},
	},
}
