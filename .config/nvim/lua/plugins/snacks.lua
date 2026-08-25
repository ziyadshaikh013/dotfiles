return {
  "folke/snacks.nvim",
  opts = {
    notifier = {
      timeout = 8000,
    },
    explorer = {
      enabled = false,
    },
  },
  keys = {
    -- Git pickers (complement diffview). File history (<leader>gdh) is owned by
    -- diffview's DiffviewFileHistory, so it's intentionally not rebound here.
    { "<leader>gdl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gds", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gdd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gdb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    -- Zen mode / Zoom
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
  },
}
