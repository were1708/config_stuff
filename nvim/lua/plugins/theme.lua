return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("gruvbox")
    end,
    -- "catppuccin/nvim", name="catppuccin", priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme("catppuccin")
    -- end,
  },
}
