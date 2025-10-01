return {
	-- Snacks plugin setup (merged)
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = { enabled = false },
			bigfile = { enabled = true },
			explorer = { enabled = true },
			indent = { enabled = true }, -- Indentation guides
			input = { enabled = true },
			picker = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 7500,
				sort = { "added" },
				width = { min = 12, max = 0.5 },
				height = { min = 1, max = 0.5 },
				icons = {
					error = "󰅚 ERROR",
					warn = " WARN",
					info = "󰋽 INFO",
					debug = "󰃤 DEBUG",
					trace = "󰓗 TRACE",
				},
				top_down = true,
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
		keys = {
			-- Open last notification
			{
				"<D-9>",
				function()
					local history = require("snacks").notifier.get_history({
						filter = function(notif)
							return notif.level ~= "trace"
						end,
						reverse = true,
					})
					local notif = history[1]
					if not notif then
						vim.notify(
							"No notifications yet.",
							vim.log.levels.TRACE,
							{ title = "Last notification", icon = "󰎟" }
						)
						return
					end
					require("snacks").notifier.hide(notif.id)

					local bufnr = vim.api.nvim_create_buf(false, true)
					local lines = vim.split(notif.msg, "\n")
					vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
					local title = vim.trim((notif.icon or "") .. " " .. (notif.title or ""))
					local height = math.min(#lines + 2, math.ceil(vim.o.lines * 0.85))

					-- Pure Lua calculation for longest line
					local longestLine = #title
					for _, line in ipairs(lines) do
						if #line > longestLine then
							longestLine = #line
						end
					end
					local width = math.min(longestLine + 3, math.ceil(vim.o.columns * 0.85))

					local overflow = #lines + 2 - height
					local footer = (overflow > 0 and ("↓ %d lines"):format(overflow) or "")
					local indexStr = ("(%d/%d)"):format(1, #history)
					local footer_text = vim.trim(indexStr .. " " .. footer)

					local levelCapitalized = notif.level:sub(1, 1):upper() .. notif.level:sub(2)
					local highlights = {
						"Normal:SnacksNormal",
						"NormalNC:SnacksNormalNC",
						"FloatBorder:SnacksNotifierBorder" .. levelCapitalized,
						"FloatTitle:SnacksNotifierTitle" .. levelCapitalized,
						"FloatFooter:SnacksNotifierFooter" .. levelCapitalized,
					}

					require("snacks").win({
						relative = "editor",
						position = "float",
						ft = notif.ft or "markdown",
						buf = bufnr,
						height = height,
						width = width,
						title = (vim.trim(title) ~= "" and " " .. title .. " " or nil),
						footer = (footer_text ~= "" and " " .. footer_text .. " " or nil),
						footer_pos = footer_text ~= "" and "right" or nil,
						wo = {
							winhighlight = table.concat(highlights, ","),
							wrap = true,
							statuscolumn = " ",
							cursorline = true,
						},
						bo = { modifiable = false },
						keys = {
							["<D-9>"] = "close",
						},
					})
				end,
				mode = { "n", "v", "i" },
				desc = "󰎟 Last notification",
			},
			-- Show notification history
			{
				"<leader>h",
				function()
					require("snacks").notifier.show_history({
						filter = function(notif)
							return notif.level ~= "trace"
						end,
						sort = { "added" },
						reverse = true,
					})
				end,
				mode = { "n", "v", "i" },
				desc = "󰎟 Notification History",
			},
		},
	},

	-- Indent-Blankline setup
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		opts = function()
			-- Toggle Indentation Guides with Snacks
			if pcall(require, "snacks") then
				local Snacks = require("snacks")
				Snacks.toggle({
					name = "Indentation Guides",
					get = function()
						return require("ibl.config").get_config(0).enabled
					end,
					set = function(state)
						require("ibl").setup_buffer(0, { enabled = state })
					end,
				}):map("<leader>ug")
			end

			return {
				indent = {
					char = "│",
					tab_char = "│",
				},
				scope = {
					show_start = false,
					show_end = false,
				},
				exclude = {
					filetypes = {
						"Trouble",
						"alpha",
						"dashboard",
						"help",
						"lazy",
						"mason",
						"neo-tree",
						"notify",
						"snacks_dashboard",
						"snacks_notif",
						"snacks_terminal",
						"snacks_win",
						"toggleterm",
						"trouble",
					},
				},
			}
		end,
		main = "ibl",
	},
}
