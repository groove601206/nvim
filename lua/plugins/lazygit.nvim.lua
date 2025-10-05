return {
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			-- 🔹 Open LazyGit with SSH-ready environment
			{
				"<leader>gg",
				function()
					local repo_path = vim.fn.expand("~/.config/nvim")
					vim.cmd("lcd " .. repo_path)

					-- Ensure remote uses SSH
					local remote_url = vim.fn.system("git remote get-url origin"):gsub("\n", "")
					if remote_url:match("^https://") then
						print("Converting remote to SSH...")
						vim.fn.system("git remote set-url origin git@github.com:groove601206/nvim.git")
					end

					-- Detect available SSH key automatically
					local keys = vim.fn.glob("~/.ssh/id_*", false, true)
					local key_added = false
					for _, key in ipairs(keys) do
						if not key:match("%.pub$") then
							vim.fn.system("ssh-add " .. key)
							key_added = true
						end
					end
					if key_added then
						print("✅ SSH key(s) added to agent")
					else
						print("⚠️ No SSH keys found in ~/.ssh/")
					end

					vim.cmd("LazyGit")
				end,
				desc = "Open LazyGit in Neovim config repo (SSH ready)",
			},

			-- 🔹 Commit & push all changes with SSH
			{
				"<leader>go",
				function()
					local repo_path = vim.fn.expand("~/.config/nvim")
					vim.cmd("lcd " .. repo_path)

					-- Ensure remote uses SSH
					local remote_url = vim.fn.system("git remote get-url origin"):gsub("\n", "")
					if remote_url:match("^https://") then
						print("Converting remote to SSH...")
						vim.fn.system("git remote set-url origin git@github.com:groove601206/nvim.git")
					end

					-- Detect and add SSH key automatically
					local keys = vim.fn.glob("~/.ssh/id_*", false, true)
					local key_added = false
					for _, key in ipairs(keys) do
						if not key:match("%.pub$") then
							vim.fn.system("ssh-add " .. key)
							key_added = true
						end
					end
					if key_added then
						print("✅ SSH key(s) added to agent")
					else
						print("⚠️ No SSH keys found in ~/.ssh/")
					end

					-- Check for unstaged/uncommitted changes
					local status = vim.fn.systemlist("git status --porcelain")
					if vim.tbl_isempty(status) then
						print("No changes to commit ✅")
						return
					end

					print("Staging all changes...")
					local add_output = vim.fn.systemlist("git add .")
					if #add_output > 0 then
						print(table.concat(add_output, "\n"))
					end
					print("Staged ✅")

					local msg = vim.fn.input("Commit message: ")
					if msg == "" then
						print("Commit aborted ⚠️")
						return
					end
					local escaped_msg = msg:gsub('"', '\\"')

					local commit_output = vim.fn.systemlist('git commit -m "' .. escaped_msg .. '" 2>&1')
					print(table.concat(commit_output, "\n"))

					local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
					print("Pushing to branch: " .. branch)

					local push_output = vim.fn.systemlist("git push origin " .. branch .. " 2>&1")
					print(table.concat(push_output, "\n"))

					print("✅ Changes committed & pushed via SSH")
				end,
				desc = "Git commit & push all changes (~/.config/nvim) via SSH",
			},
		},
	},
}
