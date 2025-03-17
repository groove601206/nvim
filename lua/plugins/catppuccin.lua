return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      local status, catppuccin = pcall(require, "catppuccin")
      if status then
        catppuccin.setup()
        vim.cmd("colorscheme catppuccin")
      else
        return print("Error loading catppuccin theme")
      end
    end
  }
}
