return {
    {
        "nvimtools/none-ls.nvim", -- Add the plugin name here
        dependencies = { "mason.nvim" },
        config = function()
            local null_ls = require("null-ls")

            -- Setup null-ls with the specified sources
            null_ls.setup({
                sources = {
                    -- 🐍 Python formatters & linters, but only when pyright is not active
                    null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.diagnostics.flake8,
                    null_ls.builtins.diagnostics.mypy,
                    null_ls.builtins.diagnostics.pylint,

                    -- ✨ Lua formatter (not conflicting with pyright)
                    null_ls.builtins.formatting.stylua,
                },
            })

            -- ✅ Safe Autoformat on Save (prevents errors)
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function()
                    local clients = vim.lsp.get_clients({ bufnr = 0 })
                    if #clients > 0 then
                        vim.lsp.buf.format({ async = false })
                    end
                end,
            })

            -- 🚀 Organize Imports for Python (Fixes the workspace/executeCommand issue)
            vim.keymap.set("n", "<leader>oi", function()
                local params = {
                    command = "_typescript.organizeImports",
                    arguments = { vim.api.nvim_buf_get_name(0) },
                }
                vim.lsp.buf.execute_command(params)
            end, { desc = "Organize Imports" })
        end,
    },

    -- Add null-ls configuration to avoid overlap with pyright
    {
        "nvimtools/none-ls.nvim", -- The plugin name is added here
        config = function()
            local null_ls = require("null-ls")

            -- Setup null-ls to ensure no overlap with pyright for Python files
            null_ls.setup({
                sources = {
                    -- You can add more sources here as needed (e.g., for other languages)
                },

                -- Ensure no overlap with pyright for Python files
                root_dir = function()
                    local pyright_attached = false
                    -- Check if pyright is already attached
                    local clients = vim.lsp.get_clients({ bufnr = 0 })
                    for _, client in ipairs(clients) do
                        if client.name == "pyright" then
                            pyright_attached = true
                            break
                        end
                    end

                    -- Only apply null-ls for Python if pyright is not already attached
                    if pyright_attached then
                        return nil             -- Do not run null-ls if pyright is attached
                    else
                        return vim.fn.getcwd() -- Use vim.fn.getcwd() to get the current working directory
                    end
                end,
            })
        end,
    },
}
