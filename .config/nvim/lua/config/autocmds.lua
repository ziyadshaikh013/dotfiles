-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
-- Prose wrap: we set `wrap=false` globally in options.lua (code stays unwrapped
-- so indentation alignment is preserved). LazyVim's built-in `lazyvim_wrap_spell`
-- autocmd already re-enables wrap+spell for markdown/text/gitcommit/typst, so no
-- custom wrap autocmd is needed here.

-- Markdown prose cleanliness: disable colorcolumn and set conceallevel for markdown files
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("custom_markdown_settings", { clear = true }),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.colorcolumn = ""
    vim.opt_local.conceallevel = 2
  end,
})
