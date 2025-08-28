return {
    {
        "folke/neoconf.nvim",
        priority = 1000,  -- Ensures it loads first
        lazy = false,     -- Explicitly load on startup
        config = function()
            -- Setup code for neoconf
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
                    lspconfig = { enabled = false },
                    jsonls = { enabled = true, configured_servers_only = true },
                },
            })
        end,
    },
}
