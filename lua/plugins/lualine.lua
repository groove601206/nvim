return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "kyazdani42/nvim-web-devicons", "catppuccin/nvim" },
	config = function()
		-- Load Catppuccin
		local catppuccin = require("catppuccin.palettes").get_palette("mocha")

		-- Lualine colors
		local colors = {
			blue = catppuccin.blue,
			green = catppuccin.green,
			purple = catppuccin.mauve,
			cyan = catppuccin.teal,
			red1 = catppuccin.red,
			red2 = catppuccin.maroon,
			yellow = catppuccin.yellow,
			fg = catppuccin.text,
			bg = catppuccin.base,
			gray1 = catppuccin.overlay0,
			gray2 = catppuccin.surface0,
			gray3 = catppuccin.surface1,
		}

		local catppuccin_theme = {
			normal = {
				a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
				b = { fg = colors.fg, bg = colors.gray3 },
				c = { fg = colors.fg, bg = colors.gray2 },
			},
			insert = { a = { fg = colors.bg, bg = colors.green, gui = "bold" } },
			visual = { a = { fg = colors.bg, bg = colors.red1, gui = "bold" } },
			replace = { a = { fg = colors.bg, bg = colors.red2, gui = "bold" } },
			command = { a = { fg = colors.bg, bg = colors.yellow, gui = "bold" } },
			terminal = { a = { fg = colors.bg, bg = colors.cyan, gui = "bold" } },
			inactive = {
				a = { fg = colors.gray1, bg = colors.bg, gui = "bold" },
				b = { fg = colors.gray1, bg = colors.bg },
				c = { fg = colors.gray1, bg = colors.gray2 },
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
				local project = vim.fn.getcwd():match("[^/]+$") -- current folder name
				local file = vim.fn.expand("%:t") -- current file name
				local modified = vim.bo.modified and " ●" or "" -- show ● if unsaved
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
			colored = false,
			symbols = { added = " ", modified = " ", removed = " " },
			cond = hide_in_width,
		}

		local lsp_progress = {
			function()
				local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
				if #clients > 0 then
					return require("lsp-progress").status()
				end
				return ""
			end,
			cond = hide_in_width,
		}

		local mason_status = {
			function()
				local installed = require("mason-tool-installer").installed()
				local missing = require("mason-tool-installer").missing()
				if #installed > 0 then
					return " Tools: " .. #installed .. " installed"
				elseif #missing > 0 then
					return " Tools: " .. #missing .. " missing"
				end
				return " Tools: No tools"
			end,
			cond = hide_in_width,
		}

		local dap_status = {
			function()
				return " " .. require("dap").status()
			end,
			cond = function()
				return require("dap").session() ~= nil
			end,
		}

		-- Debug status with black text when ON
		local debug_status = {
			function()
				if _G.debug_autocmd_enabled then
					return " Dbg: ON"
				else
					return " Dbg: OFF"
				end
			end,
			color = function()
				if _G.debug_autocmd_enabled then
					return { fg = "#000000" } -- black when ON
				else
					return { fg = colors.gray1 } -- gray when OFF
				end
			end,
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = catppuccin_theme,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "neo-tree", "dashboard", "Avante" },
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
					dap_status,
					{ "encoding", cond = hide_in_width },
					{ "filetype", cond = hide_in_width },
					lsp_progress,
					mason_status,
				},
				lualine_y = { "location" },
				lualine_z = { debug_status, "progress" },
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
}
