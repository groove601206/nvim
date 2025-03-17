return {
    -- https://github.com/LunarVim/bigfile.nvim
    'LunarVim/bigfile.nvim',
    event = 'BufReadPre', -- The plugin is loaded just before a large file is read into the buffer

    opts = {
        filesize = 2, -- Files larger than 2 MiB will trigger the plugin's optimizations
    },

    config = function(_, opts)
        require('bigfile').setup(opts) -- Setting up the plugin with the given options
    end,
}
