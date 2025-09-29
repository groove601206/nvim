return {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
        "hrsh7th/nvim-cmp",
    },
    config = function()
        local ok_autopairs, autopairs = pcall(require, "nvim-autopairs")
        if not ok_autopairs then
            return
        end

        autopairs.setup({
            check_ts = true,
            fast_wrap = {}, -- enable fast wrap
            ts_config = {
                lua = { "string" }, -- disable in string nodes for Lua
                python = { "string" }, -- disable in string nodes for Python
                java = false, -- disable Tree-sitter check in Java
            },
        })

        -- Add custom rules for Lua and Python
        local Rule = require("nvim-autopairs.rule")
        autopairs.add_rules({
            Rule("$$", "$$", { "lua", "python" }):with_pair(function(opts)
                -- only pair if not already closed
                local next_char = opts.line:sub(opts.col + 1, opts.col + 2)
                return next_char ~= "$$"
            end),
        })

        -- Setup nvim-cmp integration
        local ok_cmp, cmp = pcall(require, "cmp")
        if ok_cmp then
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    end,
}
