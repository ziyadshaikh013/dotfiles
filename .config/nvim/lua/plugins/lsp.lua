return {
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  {
    "neovim/nvim-lspconfig",
    -- inlay_hints.enabled=false: hints off by default. Toggle back on per-session
    -- with <leader>uh (LazyVim's "Toggle Inlay Hints" keymap).
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        cssls = {}, -- css-lsp
        cssmodules_ls = {}, -- cssmodules-language-server
        marksman = {
          root_dir = function(arg)
            local ok, res = pcall(function()
              local fname = type(arg) == "number" and vim.api.nvim_buf_get_name(arg) or arg
              if type(fname) ~= "string" or not fname:match("^/") then
                return nil
              end
              local util = require("lspconfig.util")
              return util.root_pattern(".marksman.toml", ".git")(fname) or vim.fs.dirname(fname)
            end)
            return ok and res or nil
          end,
          single_file_support = false,
        },
      },
    },
  },
}
