return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
    },
    opts = {
        defaults = {
            layout_config = {
                vertical = {
                    width = 0.75,         -- Keep the vertical search window wide
                    preview_cutoff = 120, -- Ensure previews are always visible
                },
                horizontal = {
                    width = 0.9,         -- Expand horizontal search window for more room
                    preview_width = 0.6, -- Adjust preview width for better layout
                },
            },
            path_display = {
                filename_first = {
                    reverse_directories = true, -- Reverse directories for easier navigation
                },
                truncate = 3,                   -- Truncate deep paths to avoid clutter
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "ignore_case", -- Enable case-insensitive search by default
                },
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        },
    },
    config = function()
        local builtin = require("telescope.builtin")

        -- Keybindings for various Telescope actions
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp Tags" })
        vim.keymap.set("n", "<leader>fgf", builtin.git_files, { desc = "[S]earch [G]it Files" })
        vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
        vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind [W]ord" })
        vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
        vim.keymap.set("n", "<leader>cn", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })

        -- Keymap for searching Neovim configuration files
        vim.keymap.set("n", "<leader>kn", function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end, { desc = "[S]earch [N]eovim config files" })

        -- Check if LSP client is attached to the buffer before setting keymaps
        if #vim.lsp.get_clients() > 0 then
            vim.keymap.set(
                "n",
                "<leader>fl",
                builtin.lsp_document_symbols,
                { desc = "[S]earch [L]SP Document Symbols" }
            )
        else
            print("No LSP client attached!")
        end

        -- Apply transparency to Telescope windows (Prompt, Preview, and Results)
        vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE" })        -- Main Telescope window
        vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE" })        -- Border around Telescope window
        vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })  -- Prompt window
        vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "NONE" })  -- Border around Prompt window
        vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE" }) -- Preview window (Result window)
        vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "NONE" }) -- Border around Preview window (Result window)
        vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE" }) -- Result window (in the search area)
        vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "NONE" }) -- Border around Result window
    end,
}
