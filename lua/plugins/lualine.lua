return {
	-- Catppuccin theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			dim_inactive = { enabled = true, percentage = 0.25 },
			highlight_overrides = {
				mocha = function(c)
					return {
						Normal = { bg = c.mantle },
						Comment = { fg = "#7687a0" },
						["@tag.attribute"] = { style = {} },
					}
				end,
			},
		},
	},

	-- Lualine with Catppuccin colors
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons", "catppuccin/nvim" },
		config = function()
			local catppuccin = require("catppuccin.palettes").get_palette("mocha")

			local colors = {
				blue = catppuccin.blue, -- Normal
				green = catppuccin.green, -- Insert
				orange = catppuccin.peach, -- Command/Main
				cyan = catppuccin.teal, -- Visual/Top
				pink = catppuccin.pink, -- Replace/Block
				fg = catppuccin.text,
				bg = catppuccin.mantle,
				surface0 = catppuccin.surface0,
				surface1 = catppuccin.surface1,
				overlay0 = catppuccin.overlay0,
			}

			local catppuccin_theme = {
				normal = {
					a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
					b = { fg = colors.fg, bg = colors.surface1 },
					c = { fg = colors.fg, bg = colors.surface0 },
				},
				insert = {
					a = { fg = colors.bg, bg = colors.green, gui = "bold" },
					b = { fg = colors.fg, bg = colors.surface1 },
					c = { fg = colors.fg, bg = colors.surface0 },
				},
				visual = {
					a = { fg = colors.bg, bg = colors.cyan, gui = "bold" },
					b = { fg = colors.fg, bg = colors.surface1 },
					c = { fg = colors.fg, bg = colors.surface0 },
				},
				replace = {
					a = { fg = colors.bg, bg = colors.pink, gui = "bold" },
					b = { fg = colors.fg, bg = colors.surface1 },
					c = { fg = colors.fg, bg = colors.surface0 },
				},
				command = {
					a = { fg = colors.bg, bg = colors.orange, gui = "bold" },
					b = { fg = colors.fg, bg = colors.surface1 },
					c = { fg = colors.fg, bg = colors.surface0 },
				},
				terminal = {
					a = { fg = colors.bg, bg = colors.green, gui = "bold" },
					b = { fg = colors.fg, bg = colors.surface1 },
					c = { fg = colors.fg, bg = colors.surface0 },
				},
				inactive = {
					a = { fg = colors.overlay0, bg = colors.bg, gui = "bold" },
					b = { fg = colors.overlay0, bg = colors.bg },
					c = { fg = colors.overlay0, bg = colors.surface0 },
				},
			}

			local hide_in_width = function()
				return vim.fn.winwidth(0) > 100
			end

			local mode = {
				"mode",
				fmt = function(str)
					return " " .. str
				end,
			}

			local filename = {
				function()
					local project = vim.fn.getcwd():match("[^/]+$")
					local file = vim.fn.expand("%:t")
					local modified = vim.bo.modified and " ●" or ""
					return " " .. project .. " / " .. file .. modified
				end,
				file_status = true,
				path = 0,
			}

			local diagnostics = {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
				colored = false,
				update_in_insert = false,
				always_visible = false,
				cond = hide_in_width,
			}

			local diff = {
				"diff",
				colored = true,
				symbols = { added = " ", modified = " ", removed = " " },
				color = {
					added = { fg = colors.green },
					modified = { fg = colors.blue },
					removed = { fg = colors.pink },
				},
				cond = hide_in_width,
			}

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = catppuccin_theme,
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					disabled_filetypes = { "alpha", "neo-tree", "dashboard" },
					always_divide_middle = true,
					globalstatus = true,
					winblend = 20,
				},
				sections = {
					lualine_a = { mode },
					lualine_b = { "branch" },
					lualine_c = { filename },
					lualine_x = {
						diagnostics,
						diff,
						{ "encoding", cond = hide_in_width },
						{ "filetype", cond = hide_in_width },
					},
					lualine_y = { { "progress", color = { fg = colors.orange, gui = "bold" } } },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { filename },
					lualine_x = { { "location", padding = 0 } },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = { "fugitive" },
			})
		end,
	},
}
