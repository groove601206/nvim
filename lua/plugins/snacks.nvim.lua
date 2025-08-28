return {
	-- Snacks plugin setup
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- Disable the dashboard feature
			dashboard = { enabled = false },
			bigfile = { enabled = true },
			explorer = { enabled = true },
			indent = { enabled = true }, -- Enable indentation guides
			input = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
	},

	-- Indent-Blankline plugin setup
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead", -- Trigger on buffer read
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
			else
				-- Fallback in case Snacks is not loaded
				print("Snacks plugin not found. Skipping toggle configuration.")
			end

			return {
				indent = {
					char = "│", -- Character for indentation lines
					tab_char = "│", -- Tab character for indentation
				},
				scope = {
					show_start = false,
					show_end = false, -- Hide scope markers
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

	-- Snacks Notifier setup with custom keybindings
	{
		"folke/snacks.nvim",
		opts = {
			notifier = {
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
		},
		keys = {
			-- Keybinding to open the last notification
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
					local longestLine = math.max(
						vim.iter(lines):fold(0, function(acc, line)
							return math.max(acc, #line)
						end),
						#title
					)
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

			-- Keybinding to show notification history
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
}
