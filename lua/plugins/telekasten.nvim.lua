return {
    -- Other plugins...
    {
        "renerocksai/telekasten.nvim",     -- Telekasten plugin
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- Optional, for icons
        },
        config = function()
            -- Set up Telekasten after installation
            require("telekasten").setup({
                home = vim.fn.expand("~") .. "/Documents/notes",                                    -- Your notes directory
                media_dir = vim.fn.expand("~") .. "/Documents/notes/media",                         -- Your media folder for images, etc.
                extension = ".md",                                                                  -- File extension for notes
                template_new_note = vim.fn.expand("~") .. "/Documents/notes/templates/new_note.md", -- Template for new notes
                -- More options can be configured as per your needs
            })
        end
    },
    -- Add other plugins here...
}
