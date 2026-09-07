return {
  "goolord/alpha-nvim",
  -- dependencies = { 'echasnovski/mini.icons' }
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local dashboard = require("alpha.themes.dashboard")
    local fortune = require("alpha.fortune")
    -- available: devicons, mini, default is mini
    -- if provider not loaded and enabled is true, it will try to use another provider
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    dashboard.section.header.opts.hl = "Type"
    dashboard.section.footer.opts.hl = "Number"
    dashboard.section.footer.val = fortune()

    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
      dashboard.button("q", "✕ > Quit NVIM", ":qa<CR>"),
    }

    require("alpha").setup(dashboard.config)
  end,
}
