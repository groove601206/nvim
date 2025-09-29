local M = {}

-- Function to check if a file or directory exists
local function file_exists(filepath)
    local file = io.open(filepath, "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end

-- Function to get the Python path based on the environment
M.get_python_path = function()
    local python_path

    -- Check for pyenv environment (macOS/Linux)
    if vim.fn.executable("pyenv") == 1 then
        local pyenv_version = vim.fn.trim(vim.fn.system("pyenv version-name"))
        if pyenv_version ~= "" then
            python_path = vim.fn.trim(vim.fn.system("pyenv which python"))
        end
    end

    -- Check if we're inside a virtualenv (macOS/Linux/Windows)
    if not python_path and os.getenv("VIRTUAL_ENV") then
        python_path = os.getenv("VIRTUAL_ENV") .. "/bin/python"
    end

    -- Fallback to `python3` (cross-platform)
    if not python_path then
        python_path = vim.fn.trim(vim.fn.system("which python3"))
    end

    -- Fallback to system Python (macOS/Linux)
    if not python_path or python_path == "" then
        if vim.fn.executable("python3") == 1 then
            python_path = vim.fn.trim(vim.fn.system("which python3"))
        end
    end

    -- For Windows, use the `python` executable
    if not python_path or python_path == "" then
        if vim.fn.executable("python") == 1 then
            python_path = vim.fn.trim(vim.fn.system("where python"))
        end
    end

    -- If we didn't find any valid Python interpreter
    if not python_path or python_path == "" then
        vim.notify("⚠️ Could not detect Python interpreter", vim.log.levels.ERROR)
    end

    return python_path
end

return M
