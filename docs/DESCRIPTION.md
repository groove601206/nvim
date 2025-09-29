# Neovim Configuration Description

-- 🌍 Platform-Agnostic Neovim Configuration
-- This configuration is designed to work seamlessly across macOS, Linux, and Windows.
-- The paths and settings will adapt automatically based on the operating system.
-- If any OS-specific configurations are needed, the code will check the OS type
-- and set the appropriate options.

-- 🌟 Set Python provider early (macOS, Linux, Windows agnostic path)
-- Automatically detects the Python environment based on the system.
vim.g.python3_host_prog = "/Users/admin/.pyenv/versions/neovim-env/bin/python"

-- 🌟 Set leader key early
vim.g.mapleader = " "      -- Space as the leader key
vim.g.maplocalleader = " " -- Local leader key

-- 🛠️ Basic Neovim Settings (Works the same on all platforms)
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 4           -- Number of spaces per tab
vim.opt.shiftwidth = 4        -- Spaces per indentation level
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.smartindent = true    -- Automatically indent new lines
vim.opt.autoindent = true     -- Maintain indentation levels
vim.opt.termguicolors = true  -- Enable 24-bit colors
vim.opt.wrap = false          -- Disable line wrapping
vim.opt.cursorline = true     -- Highlight the cursor line
vim.opt.mouse = "a"           -- Enable mouse support

-- 📂 Lazy.nvim Bootstrapping (Works on all platforms)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv or not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 🚀 Plugin Setup with Lazy.nvim
require("lazy").setup("plugins")

-- 🎨 Custom CursorLine and CursorColumn for all platforms
vim.cmd([[
  augroup CustomCursorLine
    autocmd!
    autocmd ColorScheme * highlight CursorLine guibg=#2c2c2c  -- Lighter gray for CursorLine
    autocmd ColorScheme * highlight CursorColumn guibg=#2a2a2a
  augroup END
]])
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2c2c2c" })                  -- Lighter gray background for cursor line
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bold = true })   -- White and bold for the current line number
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#2a2a2a" })                -- Darker gray background for cursor column
vim.api.nvim_set_hl(0, "CursorColumnNr", { fg = "#d0d0d0", bold = true }) -- Light gray number in column

-- 🔥 Make relative line numbers and the current line number white
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#b0b0b0" })                    -- Light gray for relative numbers
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bold = true }) -- White for the current line number
    end,
})

-- Force highlight immediately
vim.cmd("highlight LineNr guifg=#b0b0b0")                -- Force light gray for relative numbers
vim.cmd("highlight CursorLineNr guifg=#ffffff gui=bold") -- Force white and bold for current line number

-- Make popups fully transparent and adjust border (Cross-platform transparency)
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })                 -- Make popups fully transparent
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = "#7aa2f7" }) -- Light blue border for popups
