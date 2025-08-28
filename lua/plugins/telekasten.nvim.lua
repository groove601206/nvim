return {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "Telekasten" },
    keys = {
        { "<Leader>pn", "<cmd>Telekasten new_note<CR>", desc = "New Note" },
        { "<Leader>pp", "<cmd>Telekasten panel<CR>", desc = "Panel" },
        { "<Leader>pd", "<cmd>Telekasten goto_today<CR>", desc = "Today’s Note" },
        { "<Leader>pf", "<cmd>Telekasten find_notes<CR>", desc = "Find Notes" },
        { "<Leader>pg", "<cmd>Telekasten search_notes<CR>", desc = "Search Notes" },
    },
    opts = {
        home = vim.fn.expand("~/Notes/Telekasten"),
        take_over_my_home = true,
        auto_set_filetype = false,
        dailies = vim.fn.expand("~/Notes/Telekasten/daily"),
        weeklies = vim.fn.expand("~/Notes/Telekasten/weekly"),
        extension = ".md",
    },
}
