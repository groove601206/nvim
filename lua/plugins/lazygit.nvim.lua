return {
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			-- Open LazyGit in the Neovim config repo
			{
				"<leader>gg",
				function()
					-- Use lcd so floating terminal sees the correct repo
					vim.cmd("lcd ~/.config/nvim")
					vim.cmd("LazyGit")
				end,
				desc = "Open LazyGit in Neovim config repo",
			},
			-- One-shot commit & push all changes
			{
				"<leader>go",
				function()
					local repo_path = vim.fn.expand("~/.config/nvim")

					-- Change to the repo directory
					vim.cmd("lcd " .. repo_path)

					-- Check for unstaged/uncommitted changes
					local status = vim.fn.systemlist("git status --porcelain")
					if vim.tbl_isempty(status) then
						print("No changes to commit ✅")
						return
					end

					-- Stage all changes
					print("Staging all changes...")
					vim.fn.system("git add .")
					print("Staged ✅")

					-- Prompt for commit message
					local msg = vim.fn.input("Commit message: ")
					if msg == "" then
						print("Commit aborted ⚠️")
						return
					end

					-- Escape quotes in commit message
					local escaped_msg = msg:gsub('"', '\\"')

					-- Commit changes
					local commit_output = vim.fn.system('git commit -m "' .. escaped_msg .. '"')
					print(commit_output)

					-- Push to main branch via SSH
					local push_output = vim.fn.systemlist("git push origin main 2>&1")
					print(table.concat(push_output, "\n"))

					print("Changes committed & pushed via SSH ✅")
				end,
				desc = "Git commit & push all changes (~/.config/nvim)",
			},
		},
	},
}
