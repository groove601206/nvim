-- Disable netrw (optional if you're using something like neo-tree or nvim-tree)
-- vim.g.loaded_netrw = 0
-- vim.g.loaded_netrwPlugin = 0
-- vim.cmd("let g:netrw_liststyle = 3")
vim.cmd("let g:netrw_banner = 0 ")

-- Cursor Style (Set to a wider vertical bar with blinking)
vim.opt.guicursor = "n-v-c-sm:ver30-blinkwait700-blinkoff400-blinkon250,"
	.. "i-ci-ve:ver30-blinkwait700-blinkoff400-blinkon250,"
	.. "r-cr-o:hor20"

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Tabs and indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Wrapping
vim.opt.wrap = false

-- Swap/backup/undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Searching
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Colors and UI
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
--vim.opt.colorcolumn = "80"

-- Folding (works well with nvim-ufo or manual folding)
vim.opt.foldenable = true
vim.opt.foldmethod = "manual"
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "0"

-- Backspace behavior
vim.opt.backspace = { "start", "eol", "indent" }

-- Split window behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- File name characters
vim.opt.isfname:append("@-@")

-- Performance
vim.opt.updatetime = 50

-- Clipboard
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard by default

-- Mouse support
vim.opt.mouse = "a"

-- EditorConfig support
vim.g.editorconfig = true

vim.o.shada = "!,'100,<50,s10,h"

-- ======================================================
-- Remove vertical split lines globally (main fix)
vim.opt.fillchars:append("vert: ")
