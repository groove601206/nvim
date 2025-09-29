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
                openai_api_key = openai_api_key, -- Pass the actual API key
            })

            -- Keymaps
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true }

            map("n", "<leader>cG", "<cmd>ChatGPTRun grammar_correction<CR>", opts) -- Grammar correction
            map("n", "<leader>cT", "<cmd>ChatGPTRun translate<CR>", opts) -- Translate text
            map("n", "<leader>cS", "<cmd>ChatGPTRun summarize<CR>", opts) -- Summarize text
            map("n", "<leader>cD", "<cmd>ChatGPTRun explain_code<CR>", opts) -- Explain code
            map("n", "<leader>cB", "<cmd>ChatGPTRun optimize_code<CR>", opts) -- Optimize code
            map("n", "<leader>cC", "<cmd>ChatGPT<CR>", opts)              -- Open ChatGPT chat window
            map("n", "<leader>cE", "<cmd>ChatGPTEditWithInstruction<CR>", opts) -- Edit with instructions
            map("v", "<leader>cE", ":ChatGPTEditWithInstruction<CR>", opts) -- Edit with instructions in visual mode
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },
}
