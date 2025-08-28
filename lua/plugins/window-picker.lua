return {

    {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        event = "VeryLazy",
        version = "2.*",
        config = function()
            require("window-picker").setup({
                -- You can customize the highlights, selection chars, and more here
                hint = "floating-big-letter",
            })
        end,
    },
}
