return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd><C-h>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-j>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-k>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-l>TmuxNavigatePrevious<cr>" },
  },
}
