return {
    -- https://github.com/utilyre/barbecue.nvim
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',

    dependencies = {
        -- https://github.com/SmiteshP/nvim-navic
        'SmiteshP/nvim-navic',         -- Provides navigation context
        -- https://github.com/nvim-tree/nvim-web-devicons
        'nvim-tree/nvim-web-devicons', -- Optional: adds file icons
    },

    opts = {
        -- Enable or disable the breadcrumb display
        attach_navic = true, -- Attach to nvim-navic for breadcrumbs

        -- Customize appearance (optional)
        icons = {
            breadcrumb = '', -- Icon for the breadcrumb
            separator = '/', -- Separator changed to right slash
        },

        -- Optional: Configure which context levels to show (e.g., class, method, etc.)
        context_levels = 2, -- Show breadcrumbs for 2 context levels (like class and method)

        -- Optional: Set a custom update interval (defaults to 1000ms)
        update_interval = 1000, -- Interval (in milliseconds) to update breadcrumbs
    },

    config = function(_, opts)
        require('barbecue').setup(opts)
    end,
}
