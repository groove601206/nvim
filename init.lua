-- 🌟 Set leader key early
-- 🌟 Set leader key early
vim.g.mapleader = " "      -- Space as the leader key
vim.g.maplocalleader = " " -- Local leader key

-- 📂 Add core directory to runtime path
local core_path = vim.fn.stdpath("config") .. "/core"
if vim.fn.isdirectory(core_path) == 1 then
    vim.opt.rtp:prepend(core_path)
end

-- 🛠️ Load core configurations
require("core.options") -- Assuming you have core/options.lua

require("core.autocmd")

require("colorscheme")

-- 🐍 Dynamically detect Python 3 host program
local function get_python_host()
    -- 1. Use VIRTUAL_ENV if available (common in project .venv setups)
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        return venv .. "/bin/python"
    end

    -- 2. Use pyenv shims if available
    local pyenv_shim = vim.fn.expand("~/.pyenv/shims/python")
    if vim.fn.executable(pyenv_shim) == 1 then
        return pyenv_shim
    end

    -- 3. Windows-specific check (if using pyenv-win or virtualenv)
    if vim.fn.has("win32") == 1 then
        local userprofile = os.getenv("USERPROFILE") or "C:\\Users\\Default"
        local win_py = userprofile .. "\\.pyenv\\pyenv-win\\shims\\python.exe"
        if vim.fn.executable(win_py) == 1 then
            return win_py
        end
    end

    -- 4. Fallback to system python3
    if vim.fn.executable("python3") == 1 then
        return vim.fn.exepath("python3")
    end

    return nil
end

local python_host = get_python_host()
if python_host then
    vim.g.python3_host_prog = python_host
end

-- 🚀 Plugin Setup with Lazy.nvim
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

require("lazy").setup("plugins") -- loads plugins from lua/plugins/

-- ✨ CursorLine and CursorColumn styling (Tokyonight-compatible)
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1f2335" })                  -- Matches Tokyonight moon background
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#7aa2f7", bold = true })   -- Tokyonight blue
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#1e2030" })                -- Slight contrast
vim.api.nvim_set_hl(0, "CursorColumnNr", { fg = "#7dcfff", bold = true }) -- Light blue variant

-- 🔢 Line numbers: white current, light gray relative
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#b0b0b0" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#7aa2f7", bold = true })
    end,
})
vim.cmd("highlight LineNr guifg=#b0b0b0")
vim.cmd("highlight CursorLineNr guifg=#7aa2f7 gui=bold")

-- 🌫️ Floating windows: transparent with styled border
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = "#7aa2f7" }) -- Tokyonight blue

-- 🚫 Remove vertical cursor guide
vim.o.cursorcolumn = false

