-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Wrap only hurts code: it breaks the visual indentation that shows nesting.
-- Keep it off globally (LazyVim default) and turn it on just for prose
-- filetypes (markdown, text, gitcommit) — see autocmds.lua.
vim.opt.wrap = false
vim.opt.linebreak = true

vim.lsp.set_log_level("off")

vim.opt.clipboard = "unnamedplus"

-- Fallback line-length guide; projects with an .editorconfig override this
-- via max_line_length -> textwidth (Neovim's built-in editorconfig support).
vim.opt.textwidth = 100
vim.opt.colorcolumn = "+1"

-- Modern diff algorithm & line-by-line alignment
vim.opt.diffopt:append({
  "algorithm:histogram",
  "indent-heuristic",
  "linematch:60",
})

-- Replace heavy '///' diff filler lines with clean blank spaces
vim.opt.fillchars:append({
  diff = " ",
})

