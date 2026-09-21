return {
  {
    "nvim-mini/mini.diff",
    event = "VeryLazy",
    opts = {
      view = {
        style = "sign",
        signs = {
          add = "▎",
          change = "▎",
          delete = "",
        },
      },
    },
    config = function(_, opts)
      local diff = require("mini.diff")
      diff.setup(opts)

      local review_mode = false

      local function set_buf_overlay(buf, enable)
        if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].buflisted then
          return
        end
        local data = diff.get_buf_data(buf)
        if not data then
          return
        end
        if (enable and not data.overlay) or (not enable and data.overlay) then
          diff.toggle_overlay(buf)
        end
      end

      local function toggle_global_review_mode()
        review_mode = not review_mode
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          set_buf_overlay(buf, review_mode)
        end
        local msg = review_mode and "Diff Review Mode: ON" or "Diff Review Mode: OFF"
        vim.notify(msg, vim.log.levels.INFO, { title = "mini.diff" })
      end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("MiniDiffReviewMode", { clear = true }),
        callback = function(args)
          if review_mode then
            vim.schedule(function()
              set_buf_overlay(args.buf, true)
            end)
          end
        end,
      })

      vim.keymap.set("n", "<leader>go", toggle_global_review_mode, {
        desc = "Toggle Global Diff Review Mode",
      })
    end,
  },
}
