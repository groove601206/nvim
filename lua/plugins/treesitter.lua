return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",                     -- Ensure parsers stay updated
    event = { "BufReadPost", "BufNewFile" }, -- Load only when needed
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "python", "kdl" }, -- Install only needed parsers
            highlight = { enable = true },
            indent = { enable = true },
            sync_install = false, -- Non-blocking installation
            auto_install = true,  -- Automatically install missing parsers
            ignore_install = {},  -- Specify parsers to ignore (leave empty if none)
            modules = {},         -- Required field, can be left empty for now
        })
    end,
}
