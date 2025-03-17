return {
    -- LazyDev for Lua & Python
    {
        "folke/lazydev.nvim",
        ft = { "lua", "python" }, -- Load for Lua and Python files
        opts = {},
    },

    -- Neovim Lua development (Disabled)
    -- {
    --     "folke/neodev.nvim",
    --     opts = {
    --         library = { plugins = { "nvim-dap-ui" }, types = true },
    --     },
    -- },

    -- Python LSP Setup
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Pyright LSP
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic", -- "off" | "basic" | "strict"
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            })

            -- Pylsp LSP (alternative)
            lspconfig.pylsp.setup({
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            pylint = { enabled = true },
                            pyflakes = { enabled = true },
                            pycodestyle = { enabled = false },
                        },
                    },
                },
            })
        end,
    },
}
