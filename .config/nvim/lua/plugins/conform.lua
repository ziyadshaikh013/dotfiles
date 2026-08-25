local function is_available(bufnr, formatter)
  return require("conform").get_formatter_info(formatter, bufnr).available
end

local function first_formatter(bufnr, ...)
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if is_available(bufnr, formatter) then
      return { formatter }
    end
  end
  return { select(1, ...) }
end

-- oxfmt formats, oxlint --fix applies lint autofixes afterwards.
-- oxlint is only chained when oxfmt won, i.e. in an actual oxc project;
-- biome-check and eslint_d already fix lint issues themselves.
local function js_formatters(bufnr)
  local formatters = first_formatter(bufnr, "oxfmt", "biome-check", "eslint_d")
  if formatters[1] == "oxfmt" and is_available(bufnr, "oxlint") then
    table.insert(formatters, "oxlint")
  end
  return formatters
end

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      javascript = js_formatters,
      javascriptreact = js_formatters,
      typescript = js_formatters,
      typescriptreact = js_formatters,
      json = function(bufnr)
        return first_formatter(bufnr, "oxfmt", "biome-check")
      end,
      jsonc = function(bufnr)
        return first_formatter(bufnr, "oxfmt", "biome-check")
      end,
      markdown = { "prettier" },
      ["markdown.mdx"] = { "prettier" },
    },
  },
}
