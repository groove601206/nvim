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
					-- Make sure the floating terminal opens in the correct repo
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
					vim.cmd("lcd " .. repo_path)

					-- Check for unstaged/uncommitted changes
					local status = vim.fn.systemlist("git status --porcelain")
					if vim.tbl_isempty(status) then
						print("No changes to commit ✅")
						return
					end

					-- Stage all changes
					print("Staging all changes...")
					local add_output = vim.fn.systemlist("git add .")
					if #add_output > 0 then
						print(table.concat(add_output, "\n"))
					end
					print("Staged ✅")

					-- Prompt for commit message
					local msg = vim.fn.input("Commit message: ")
					if msg == "" then
						print("Commit aborted ⚠️")
						return
					end
					local escaped_msg = msg:gsub('"', '\\"')

					-- Commit changes
					local commit_output = vim.fn.systemlist('git commit -m "' .. escaped_msg .. '" 2>&1')
					print(table.concat(commit_output, "\n"))

					-- Detect current branch
					local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
					print("Pushing to branch: " .. branch)

					-- Push changes using SSH agent
					local push_output = vim.fn.systemlist("git push origin " .. branch .. " 2>&1")
					print(table.concat(push_output, "\n"))

					print("Changes committed & pushed ✅")
				end,
				desc = "Git commit & push all changes (~/.config/nvim)",
			},
		},
	},
}
