return {
  -- Disable render-markdown to prevent dual rendering conflict
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
  },

  -- Add markview.nvim
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      preview = {
        modes = { "n", "no", "c" },
        hybrid_modes = { "n" },
        callbacks = {
          on_enable = function(_, win)
            vim.wo[win].conceallevel = 2
            vim.wo[win].concealcursor = "nc"
          end,
        },
      },
      markdown = {
        headings = {
          enable = true,
        },
        code_blocks = {
          enable = true,
          style = "language",
        },
        block_quotes = {
          enable = true,
        },
        horizontal_rules = {
          enable = true,
        },
        tables = {
          enable = true,
        },
        list_items = {
          enable = true,
        },
        checkboxes = {
          enable = true,
        },
      },
    },
    keys = {
      {
        "<leader>um",
        "<cmd>Markview toggle<cr>",
        desc = "Toggle Markview (Markdown Preview)",
      },
    },
  },

  -- Configure markdownlint-cli2 to silence MD013 (line-length warnings)
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            vim.fn.stdpath("config") .. "/.markdownlint.json",
            "--",
          },
        },
      },
    },
  },
}
