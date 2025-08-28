return {
    {
        "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
    },
    {
        "L3MON4D3/LuaSnip",        -- Snippet engine
        dependencies = {
            "saadparwaiz1/cmp_luasnip", -- LuaSnip completion source for nvim-cmp
            "rafamadriz/friendly-snippets", -- Friendly snippets collection
        },
    },
    {
        "onsails/lspkind-nvim", -- Optional: Adds icons for LSP completion items
    },
    {
        "hrsh7th/nvim-cmp", -- Autocompletion plugin
        dependencies = {
            "hrsh7th/cmp-buffer", -- Buffer source
            "hrsh7th/cmp-path", -- Path source
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind") -- Adding lspkind for icons

            -- Load VSCode-style snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Setup completion sources for the buffer and command-line mode
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- Use LuaSnip to expand snippets
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(), -- Use bordered window for completion
                    documentation = cmp.config.window.bordered(), -- Use bordered window for documentation
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll documentation up
                    ["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll documentation down
                    ["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
                    ["<C-e>"] = cmp.mapping.abort(),    -- Abort completion
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selected item
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- Use LSP source for completion
                    { name = "luasnip" }, -- Use LuaSnip source for snippets
                    { name = "path" }, -- Useful for completing file paths
                    { name = "buffer" }, -- For word suggestions from the buffer
                    { name = "nvim_lua" }, -- Useful if you're working with Neovim Lua APIs
                }),
                formatting = {
                    format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }), -- Add icons to LSP items
                },
            })

            -- Enable cmdline completion (for command-line mode)
            cmp.setup.cmdline("/", {
                window = {
                    completion = {
                        border = "none",                 -- Remove border for transparency
                        winhighlight = "Normal:Normal,FloatBorder:Normal", -- Make background transparent
                    },
                },
                sources = {
                    { name = "buffer" }, -- Autocomplete words from the current buffer
                },
            })

            cmp.setup.cmdline(":", {
                window = {
                    completion = {
                        border = "none",                 -- Remove border for transparency
                        winhighlight = "Normal:Normal,FloatBorder:Normal", -- Make background transparent
                    },
                },
                sources = {
                    { name = "path" }, -- Autocomplete file paths
                    { name = "cmdline" }, -- Autocomplete command-line commands
                },
            })
        end,
    },
}
