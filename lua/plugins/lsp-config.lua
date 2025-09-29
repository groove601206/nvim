return {
    {
        "williamboman/mason-lspconfig.nvim",
        tag = "v1.32.0",
        dependencies = {
            { "williamboman/mason.nvim", tag = "v2.0.0" },
            { "neovim/nvim-lspconfig",   tag = "v0.1.7" },
        },
        event = "VeryLazy",
        config = function()
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")
            local util = require("lspconfig.util")

            -- Optional Lua LSP enhancements
            pcall(function()
                require("neodev").setup({})
            end)

            local on_attach = function(client, bufnr)
                print("[LSP] Attached client:", client.name, "to buffer:", bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set(
                    "n",
                    "<leader>s",
                    vim.lsp.buf.signature_help,
                    { desc = "Signature Help", buffer = bufnr, silent = true }
                )
                vim.keymap.set(
                    "n",
                    "<leader>ca",
                    vim.lsp.buf.code_action,
                    vim.tbl_extend("force", opts, { desc = "Code Action" })
                )
                vim.keymap.set(
                    "v",
                    "<leader>ca",
                    vim.lsp.buf.code_action,
                    vim.tbl_extend("force", opts, { desc = "Range Code Action" })
                )
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
            end

            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "pyright" },
                automatic_installation = true,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.offsetEncoding = { "utf-16" }

            local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
            if ok_cmp then
                capabilities = cmp.default_capabilities(capabilities)
            end

            local function get_python_path(workspace)
                if vim.env.VIRTUAL_ENV then
                    return vim.env.VIRTUAL_ENV .. "/bin/python"
                end
                local match = vim.fn.glob(workspace .. "/.python-version")
                if match ~= "" then
                    local f = io.open(match, "r")
                    if f then
                        local venv_name = f:read("*l")
                        f:close()
                        return os.getenv("PYENV_ROOT") .. "/versions/" .. venv_name .. "/bin/python"
                    end
                end
                return vim.fn.exepath("python3") or "python"
            end

            local servers = {
                lua_ls = function()
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                runtime = { version = "LuaJIT" },
                                diagnostics = { globals = { "vim" } },
                                workspace = { checkThirdParty = false },
                            },
                        },
                    })
                end,

                pyright = function()
                    lspconfig.pyright.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        root_dir = util.root_pattern(
                            ".git",
                            "pyproject.toml",
                            "setup.py",
                            "requirements.txt",
                            ".python-version"
                        ),
                        before_init = function(_, config)
                            local root = config.root_dir or vim.fn.getcwd()
                            print("[pyright] Root dir:", root)
                            local path = get_python_path(root)
                            print("[pyright] Using python path:", path)
                            config.settings = config.settings or {}
                            config.settings.python = config.settings.python or {}
                            config.settings.python.pythonPath = path
                        end,
                        settings = {
                            python = {
                                analysis = {
                                    autoImportCompletions = true,
                                    diagnosticMode = "workspace",
                                    typeCheckingMode = "basic",
                                    useLibraryCodeForTypes = true,
                                    autoSearchPaths = true,
                                    completeFunctionParens = true,
                                },
                            },
                        },
                    })
                end,
            }

            mason_lspconfig.setup_handlers({
                function(server_name)
                    if servers[server_name] then
                        servers[server_name]()
                    else
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end
                end,
            })

            vim.api.nvim_create_autocmd("CursorHold", {
                pattern = "*",
                callback = function()
                    vim.diagnostic.open_float(nil, {
                        focusable = false,
                        border = "rounded",
                        source = "always",
                        header = "",
                        prefix = " ",
                    })
                end,
            })

            -- Manually force attach pyright if not attached after BufRead
            vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
                pattern = "*.py",
                callback = function()
                    local clients = vim.lsp.get_active_clients()
                    local attached_clients = vim.lsp.buf_get_clients(0)
                    if #attached_clients == 0 then
                        for _, client in ipairs(clients) do
                            if client.name == "pyright" then
                                print("[LSP] Manually attaching pyright to buffer", vim.api.nvim_get_current_buf())
                                vim.lsp.buf_attach_client(0, client.id)
                                break
                            end
                        end
                    end
                end,
            })
        end,
    },
}
