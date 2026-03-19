-- =====================================
-- NeoMutt Mail Header Enhancer (Auto + Styles)
-- Author: Michael Zeitlin (Custom)
-- =====================================

-- Доступные стили
local styles = {
	classic = { fg = "#a9b1d6", bold = true },
	minimal = { fg = "#9ca3af", bold = false },
	bold = { fg = "#c0caf5", bold = true },
}

-- Текущий стиль по умолчанию
local current_style = styles.classic

-- Применяем стиль
local function apply_style(style)
	current_style = style or current_style
	vim.api.nvim_set_hl(0, "MailHeader", current_style)
end

-- Центрируем строку
local function center_line(buf, line_num)
	local width = vim.o.columns
	local line = vim.api.nvim_buf_get_lines(buf, line_num, line_num + 1, false)[1] or ""
	local pad = math.floor((width - #line) / 2)
	if pad > 0 then
		vim.api.nvim_buf_set_lines(buf, line_num, line_num + 1, false, { string.rep(" ", pad) .. line })
	end
end

-- Форматируем первую строку
local function format_header()
	local buf = 0
	center_line(buf, 0)
	vim.api.nvim_buf_add_highlight(buf, -1, "MailHeader", 0, 0, -1)
end

-- Команда для смены стиля заголовка
vim.api.nvim_create_user_command("MailHeaderStyle", function(opts)
	local style_name = opts.args
	local style = styles[style_name]
	if style then
		apply_style(style)
		format_header()
		vim.notify("Mail header style set to: " .. style_name)
	else
		vim.notify("Unknown style: " .. style_name, vim.log.levels.WARN)
	end
end, {
	nargs = 1,
	complete = function()
		return vim.tbl_keys(styles)
	end,
})

-- Keymap для прикрепления файлов через Telescope
local function setup_attachment_keymap()
	vim.keymap.set("n", "\\a", function()
		local has_telescope, telescope = pcall(require, "telescope.builtin")
		if has_telescope then
			telescope.find_files({
				prompt_title = "Attach file",
				attach_mappings = function(prompt_bufnr, map)
					local actions = require("telescope.actions")
					local action_state = require("telescope.actions.state")

					local function attach_file()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						if selection then
							local cmd = "mutt-attach " .. vim.fn.shellescape(selection.path)
							vim.cmd("!" .. cmd)
							vim.notify("Attached: " .. selection.path)
						end
					end

					map("i", "<CR>", attach_file)
					map("n", "<CR>", attach_file)
					return true
				end,
			})
		else
			vim.notify("Telescope not found! Cannot select file.", "error")
		end
	end, { desc = "Attach file to NeoMutt email" })
end

-- Автокоманда для письма
vim.api.nvim_create_autocmd("FileType", {
	pattern = "mail",
	callback = function()
		apply_style(current_style)
		format_header()
		setup_attachment_keymap()
	end,
})
