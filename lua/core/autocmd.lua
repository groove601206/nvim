-- ~/.config/nvim/lua/core/autocmd.lua

-- Helper function for creating augroups
local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Auto change working directory to project root
vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup("autochdir_to_project_root"),
    callback = function()
        local ok, util = pcall(require, "lspconfig.util")
        if not ok then
            return
        end
        local root = util.root_pattern(".git", "pyproject.toml", "setup.py", "setup.cfg")(vim.fn.expand("%:p"))
        if root and vim.fn.getcwd() ~= root then
            vim.cmd("lcd " .. root)
            vim.schedule(function()
                vim.notify("Changed cwd to: " .. root, vim.log.levels.DEBUG, { title = "Auto Root" })
            end)
        end
    end,
})

-- Close certain windows with <Esc>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "PlenaryTestPopup",
        "grug-far",
        "help",
        "lspinfo",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
        "dbout",
        "gitsigns-blame",
        "Lazy",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set("n", "<esc>", function()
                vim.cmd("close")
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, {
                buffer = event.buf,
                silent = true,
                desc = "Quit buffer",
            })
        end)
    end,
})

-- Enable spell checking for text-related filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.spell = true
    end,
})

-- Show diagnostics automatically in a floating window
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = augroup("float_diagnostic"),
    callback = function()
        vim.diagnostic.open_float(nil, {
            focus = false,
            border = "rounded",
        })
    end,
})

-- Auto-fold markdown headings (excluding some files)
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.md",
    callback = function()
        local file_path = vim.fn.expand("%:p")
        if file_path:match(os.getenv("HOME") .. "/github/obsidian_main/250%-daily/") then
            return
        end
        if vim.b.zk_executed then
            return
        end
        vim.b.zk_executed = true
        vim.defer_fn(function()
            vim.cmd("normal zk")
            vim.notify("Folded keymaps", vim.log.levels.INFO)
        end, 100)
    end,
})

-- Debug: Notify when BufWritePost autocmd triggers
local function debug_autocmd(name)
    return function(ev)
        vim.schedule(function()
            vim.notify(
                string.format(
                    "[autocmd:%s] Event: %s | File: %s | Buf: %d",
                    name,
                    ev.event or "N/A",
                    vim.fn.expand("%:p"),
                    ev.buf
                ),
                vim.log.levels.INFO,
                { title = "Autocmd Debug" }
            )
        end)
    end
end

-- Toggleable debug flag with global status
local debug_enabled = false
_G.debug_autocmd_enabled = debug_enabled

local function toggle_debug_autocmd()
    debug_enabled = not debug_enabled
    _G.debug_autocmd_enabled = debug_enabled

    -- Clear existing group just in case
    pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_debug_bufwritepost")

    if debug_enabled then
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup("debug_bufwritepost", { clear = true }),
            pattern = "*",
            callback = debug_autocmd("BufWritePost"),
        })
        vim.notify("Debug BufWritePost ON", vim.log.levels.INFO, { title = "Autocmd Debug" })
    else
        vim.notify("Debug BufWritePost OFF", vim.log.levels.INFO, { title = "Autocmd Debug" })
    end

    -- Refresh lualine so icon updates immediately
    vim.schedule(function()
        require("lualine").refresh()
    end)
end

-- Expose a command and keymap
vim.api.nvim_create_user_command("ToggleBufWriteDebug", toggle_debug_autocmd, {})

vim.keymap.set("n", "<leader>ud", toggle_debug_autocmd, {
    desc = "Toggle BufWritePost Debug",
})
