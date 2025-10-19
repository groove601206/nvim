return {
	"iamcco/markdown-preview.nvim",
	ft = { "markdown" },
	build = "cd app && npm install",
	config = function()
		-- Plugin options
		vim.g.mkdp_auto_start = 0 -- manual control
		vim.g.mkdp_auto_close = 1
		vim.g.mkdp_echo_preview_url = 0
		vim.g.mkdp_filetypes = { "markdown" }

		-- Floating preview function
		local function open_markdown_preview_floating()
			if vim.bo.filetype ~= "markdown" then
				return
			end

			-- Open Markdown preview in a floating window
			local buf = vim.api.nvim_create_buf(false, true) -- scratch buffer
			local width = math.floor(vim.o.columns * 0.8)
			local height = math.floor(vim.o.lines * 0.8)
			local row = math.floor((vim.o.lines - height) / 2)
			local col = math.floor((vim.o.columns - width) / 2)

			local win = vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = width,
				height = height,
				row = row,
				col = col,
				style = "minimal",
				border = "rounded",
			})

			-- Run preview command inside buffer
			vim.cmd("MarkdownPreview")
			return win
		end

		-- Keymap to toggle floating Markdown preview
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.keymap.set("n", "<leader>mp", open_markdown_preview_floating, {
					buffer = true,
					desc = "Open Markdown Preview Floating",
				})
			end,
		})
	end,
}
