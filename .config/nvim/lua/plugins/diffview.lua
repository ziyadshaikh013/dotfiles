return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  opts = {
    enhanced_diff_hl = true, -- Preserves Treesitter syntax highlighting & gives clean word-diffs
    view = {
      default = {
        layout = "diff2_vertical",
      },
    },
    file_panel = {
      listing_style = "tree",
      win_config = {
        position = "left",
        width = 30,
      },
    },
  },
  keys = {
    { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Open DiffView" },
    { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close DiffView" },
    { "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
  },
}
