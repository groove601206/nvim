return {
    {
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        config = function()
            -- Retrieve the OpenAI API key from the environment variable
            local openai_api_key = os.getenv("OPENAI_API_KEY")

            if not openai_api_key then
                print("Error: OPENAI_API_KEY is not set!")
                return
            end

            require("chatgpt").setup({
                openai_api_key = openai_api_key -- Pass the actual API key
            })

            -- Keymaps
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true }

            map("n", "<leader>cc", "<cmd>ChatGPT<CR>", opts)                       -- Open ChatGPT
            map("n", "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", opts)    -- Edit selection
            map("v", "<leader>ce", ":ChatGPTEditWithInstruction<CR>", opts)        -- Edit selection in visual mode
            map("n", "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", opts) -- Grammar correction
            map("n", "<leader>ct", "<cmd>ChatGPTRun translate<CR>", opts)          -- Translate text
            map("n", "<leader>cs", "<cmd>ChatGPTRun summarize<CR>", opts)          -- Summarize text
            map("n", "<leader>cd", "<cmd>ChatGPTRun explain_code<CR>", opts)       -- Explain code
            map("n", "<leader>cb", "<cmd>ChatGPTRun optimize_code<CR>", opts)      -- Optimize code
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim", -- optional
            "nvim-telescope/telescope.nvim"
        },
    },
}
