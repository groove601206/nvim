return {
    -- https://github.com/diepm/vim-rest-console
    'diepm/vim-rest-console',
    event = 'VeryLazy',

    config = function()
        -- Turn off the default keybinding
        vim.g.vrc_set_default_mapping = 0

        -- Set the default response content type to JSON
        vim.g.vrc_response_default_content_type = 'application/json'

        -- Set the output buffer name (using .json extension for syntax highlighting)
        vim.g.vrc_output_buffer_name = '_OUTPUT.json'

        -- Automatically format JSON response buffers using jq
        vim.g.vrc_auto_format_response_patterns = {
            json = 'jq',
        }

        -- Custom keybinding for sending a request
        vim.api.nvim_set_keymap('n', '<leader>r', ':VrcSendRequest<CR>', { noremap = true, silent = true })
    end
}
