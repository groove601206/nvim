return {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {
        bind = true,
        floating_window = false, -- disable automatic popup
        hint_enable = true, -- disable virtual text hints
        handler_opts = { border = "rounded" },
    },
    config = function(_, opts)
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                require("lsp_signature").setup(opts) -- only setup, no auto on_attach

                -- Manual keybind for signature popup
                vim.keymap.set("i", "<C-k>", function()
                    require("lsp_signature").toggle_float_win()
                end, { silent = true, buffer = bufnr, desc = "Toggle Signature Help" })
            end,
        })
    end,
}
