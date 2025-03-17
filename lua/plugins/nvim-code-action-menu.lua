return {
    {
        "weilbith/nvim-code-action-menu",
        config = function()
            -- Set keybinding for CodeActionMenu
            vim.api.nvim_set_keymap('n', '<leader>ca', ':CodeActionMenu<CR>', { noremap = true, silent = true })
        end
    },

}
