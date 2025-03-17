return {
    {
        'neoclide/coc.nvim',
        branch = 'release',
        build = 'npm install',
        config = function()
            -- Key mappings for coc.nvim
            vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>d', '<Plug>(coc-diagnostic)', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>r', '<Plug>(coc-references)', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>(coc-format)', { noremap = true, silent = true })

            -- Key mapping for triggering code actions (quick fixes)
            vim.api.nvim_set_keymap('n', '<leader>b', '<Plug>(coc-codeaction)', { noremap = true, silent = true })

            -- Key mapping for triggering code actions through Telescope
            vim.api.nvim_set_keymap('n', '<leader>ca', ':Telescope coc code_actions<CR>',
                { noremap = true, silent = true })

            -- Key mapping for closing the code action popup
            vim.api.nvim_set_keymap('n', '<leader>cc', ':CocAction close<CR>', { noremap = true, silent = true })
        end,
    },
    {
        'fannheyward/telescope-coc.nvim',
        config = function()
            -- Load coc extension for Telescope
            require('telescope').load_extension('coc')
        end
    }
}
