-- =====================================
-- Neovim Email Client Enhancer (NeoMutt)
-- Features:
-- 1. Pick attachments via Telescope
-- 2. Automatically attach files in NeoMutt
-- =====================================

local M = {}

-- Function: Attach file in NeoMutt
function M.attach_file(path)
	-- Проверяем, что файл существует
	if vim.fn.filereadable(path) == 0 then
		vim.notify("File not found: " .. path, vim.log.levels.WARN)
		return
	end
	-- Вызываем mutt-attach для текущего письма
	vim.cmd("!mutt-attach " .. vim.fn.shellescape(path))
	vim.notify("Attached: " .. path)
end

-- Telescope picker for attachments
function M.pick_attachment()
	local has_telescope, telescope = pcall(require, "telescope.builtin")
	if not has_telescope then
		vim.notify("Telescope not found", vim.log.levels.ERROR)
		return
	end

	telescope.find_files({
		prompt_title = "Attach file",
		attach_mappings = function(prompt_bufnr, map)
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			local function attach_selection()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				if selection then
					M.attach_file(selection.path)
				end
			end

			map("i", "<CR>", attach_selection)
			map("n", "<CR>", attach_selection)
			return true
		end,
	})
end

-- Keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "mail",
	callback = function()
		-- Attach file via Telescope
		vim.keymap.set("n", "\\a", M.pick_attachment, { desc = "Attach file to email" })
	end,
})

return M
