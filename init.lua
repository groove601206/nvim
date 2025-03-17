-- 🌟 Set Python provider early
vim.g.python3_host_prog = "/Users/admin/.pyenv/versions/neovim-env/bin/python"

-- 🌟 Set leader key early
vim.g.mapleader = " "      -- Space as the leader key
vim.g.maplocalleader = " " -- Local leader key

-- 🛠️ Basic Neovim Settings
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

-- 📂 Lazy.nvim Bootstrapping
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

-- 🎨 Make CursorLine and CursorColumn a Little Lighter, Similar to VS Code's Style
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
vim.cmd("highlight CursorLineNr guifg=#ffffff gui=bold") -- Force white for the current line number
