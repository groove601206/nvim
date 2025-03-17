return {
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event = "VeryLazy",
        config = function()
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "pyright" }, -- Only install lua_ls and pyright
                automatic_installation = true,              -- Automatically install missing LSP servers
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    local lspconfig = require("lspconfig")

                    -- Set up default LSP client capabilities and integrate with completion plugin (if installed)
                    local capabilities = vim.lsp.protocol.make_client_capabilities()
                    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
                    if ok then
                        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
                    else
                        vim.notify("Warning: cmp_nvim_lsp not found, using default LSP capabilities", vim.log.levels
                            .WARN)
                    end

                    -- Root directory detection function for LSP
                    local function root_dir(fname)
                        local root_files = { ".git", "setup.py", "pyproject.toml", "Pipfile" }
                        local found = vim.fs.find(root_files, { upward = true, path = fname })
                        if not found or #found == 0 then
                            return nil
                        end
                        return vim.fs.dirname(found[1])
                    end

                    -- Server-specific configuration
                    local servers = {
                        lua_ls = {
                            root_dir = root_dir,
                        },
                        pyright = {
                            cmd = {
                                "/Users/admin/.nvm/versions/node/v23.9.0/bin/node",
                                "/Users/admin/.nvm/versions/node/v23.9.0/lib/node_modules/pyright/langserver.index.js",
                                "--stdio"
                            }, -- Set up the correct command to run pyright
                            settings = {
                                python = {
                                    pythonPath = "/Users/admin/.pyenv/versions/neovim-env/bin/python", -- Path to Python in your virtual environment
                                    analysis = {
                                        typeCheckingMode = "basic",                                    -- Basic type checking mode
                                        autoSearchPaths = true,                                        -- Automatically search for library paths
                                        diagnosticMode = "workspace",                                  -- Run analysis on the entire workspace
                                        useLibraryCodeForTypes = true,                                 -- Use library code for type inference
                                        fileWatching = true,                                           -- Watch for file changes
                                    },
                                },
                            },
                            root_dir = root_dir,
                        },
                    }

                    -- Apply the LSP server setup if it's in our list
                    if servers[server_name] then
                        lspconfig[server_name].setup(vim.tbl_deep_extend("force", {
                            capabilities = capabilities,
                        }, servers[server_name]))
                    end
                end,
            })
        end,
    },
}
