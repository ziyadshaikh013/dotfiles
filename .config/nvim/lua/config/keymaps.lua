-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- GitSigns UI Toggles
Snacks.toggle({
  name = "Git Line Numbers",
  get = function()
    return require("gitsigns.config").config.numhl
  end,
  set = function(state)
    require("gitsigns").toggle_numhl(state)
  end,
}):map("<leader>ugl")

Snacks.toggle({
  name = "Git Deleted Lines",
  get = function()
    return require("gitsigns.config").config.show_deleted
  end,
  set = function(state)
    require("gitsigns").toggle_deleted(state)
  end,
}):map("<leader>ugd")

Snacks.toggle({
  name = "Git Line Highlight",
  get = function()
    return require("gitsigns.config").config.linehl
  end,
  set = function(state)
    require("gitsigns").toggle_linehl(state)
  end,
}):map("<leader>ugh")

Snacks.toggle({
  name = "Git Current Line Blame",
  get = function()
    return require("gitsigns.config").config.current_line_blame
  end,
  set = function(state)
    require("gitsigns").toggle_current_line_blame(state)
  end,
}):map("<leader>ugb")

Snacks.toggle({
  name = "Git Word Diff",
  get = function()
    return require("gitsigns.config").config.word_diff
  end,
  set = function(state)
    require("gitsigns").toggle_word_diff(state)
  end,
}):map("<leader>ugw")

