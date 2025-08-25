return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
  config = function (_, opts)
    require("gitsigns").setup(opts)
    vim.keymap.set("n", "<leader>b", ":Gitsigns blame_line<CR>", { noremap = true })
  end,
}
