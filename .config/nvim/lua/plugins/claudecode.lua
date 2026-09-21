return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  -- Loaded eagerly: the CLI runs in a separate tmux pane and looks for the
  -- lockfile in ~/.claude/ide/ at /ide time, so the server must already be up.
  -- Lazy-loading on cmd/keys would delay it until a command is invoked here.
  lazy = false,
  opts = {
    -- Claude Code runs in its own tmux pane, not inside nvim. This plugin is
    -- here only to run the WebSocket server that exposes buffer, cursor and
    -- selection state; it must never spawn or manage a terminal.
    terminal = { provider = "none" },
    -- Server starts with nvim so the lockfile in ~/.claude/ide/ exists before
    -- the CLI in the other pane runs /ide.
    auto_start = true,
    track_selection = true,
  },
  cmd = {
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeStatus",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "neo-tree", "oil", "netrw", "snacks_picker_list" },
    },
    { "<leader>aS", "<cmd>ClaudeCodeStatus<cr>", desc = "Connection status" },
    -- Diff accept/deny: only reachable if Claude proposes an edit, which the
    -- over-the-shoulder workflow does not do. Kept for the occasions it is asked to.
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
