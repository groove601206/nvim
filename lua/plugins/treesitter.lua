return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            local ok, _ = pcall(vim.cmd, "TSUpdate")
            if not ok then
                vim.notify("nvim-treesitter: TSUpdate failed during build step", vim.log.levels.WARN)
            end
        end,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true },
                ensure_installed = { "lua", "python", "markdown", "norg" },
            })
        end,
    },
    {
        "nvim-neorg/neorg",
        lazy = false,
        version = "*",
        config = function()
            require("neorg").setup({
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.dirman"] = {
                        config = {
                            workspaces = {
                                notes = "~/Notes",
                            },
                            default_workspace = "notes", -- must match 'notes'
                        },
                    },
                },
            })

            vim.wo.foldlevel = 99
            vim.wo.conceallevel = 2
        end,
    },
}
