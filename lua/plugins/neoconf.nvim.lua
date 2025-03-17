return {
    -- Load neoconf.nvim first
    {
        "folke/neoconf.nvim",
        priority = 1000, -- Ensures it loads first
        lazy = false,    -- Explicitly load on startup
        config = function()
            require("neoconf").setup({
                local_settings = ".neoconf.json",
                global_settings = "neoconf.json",
                import = {
                    vscode = true,
                    coc = true,
                    nlsp = true,
                },
                live_reload = true,
                filetype_jsonc = true,
                plugins = {
                    lspconfig = { enabled = true },
                    jsonls = { enabled = true, configured_servers_only = true },
                },
            })

            -- Keymaps for Neoconf
            local map = vim.keymap.set
            map("n", "<leader>cc", "<cmd>Neoconf<CR>", { desc = "Open Neoconf UI" })
            map("n", "<leader>ccl", "<cmd>Neoconf local<CR>", { desc = "Edit Local Neoconf" })
            map("n", "<leader>ccg", "<cmd>Neoconf global<CR>", { desc = "Edit Global Neoconf" })
            map("n", "<leader>ccs", "<cmd>Neoconf show<CR>", { desc = "Show Merged Neoconf" })
            map("n", "<leader>cclsp", "<cmd>Neoconf lsp<CR>", { desc = "Show Merged LSP Config" })
        end,
    },

    -- Ensure LSP servers are installed
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "lua_ls" }, -- Install required LSPs
                automatic_installation = true,              -- Ensure automatic installation of LSPs
            })
        end,
    },

    -- LSP config (ensure this runs AFTER neoconf.nvim)
    {
        "neovim/nvim-lspconfig",
        dependencies = { "folke/neoconf.nvim", "williamboman/mason-lspconfig.nvim" },
        config = function()
            local lspconfig = require("lspconfig")

            -- Lua LSP setup
            lspconfig.lua_ls.setup({})

            -- Python LSP setup with Pyright
            lspconfig.pyright.setup({
                cmd = {
                    "/Users/admin/.nvm/versions/node/v23.9.0/bin/node",
                    "/Users/admin/.nvm/versions/node/v23.9.0/lib/node_modules/pyright/langserver.index.js",
                    "--stdio"
                },
                root_dir = function(fname)
                    local root_files = { ".git", "setup.py", "pyproject.toml", "Pipfile" }
                    local found = vim.fs.find(root_files, { upward = true, path = fname, type = "file" })
                    if #found == 0 then
                        return nil
                    end
                    return vim.fs.dirname(found[1])
                end,
                single_file_support = true,                                 -- Enable support for single file (no need for a root dir)
                capabilities = vim.lsp.protocol.make_client_capabilities(), -- Add specific capabilities if needed
                handlers = {
                    -- You can define custom handlers for specific LSP messages here
                },
            })
        end,
    },
}
