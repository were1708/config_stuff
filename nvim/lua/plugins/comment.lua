return {
  -- "gc" to comment visual regions/lines
  "numToStr/Comment.nvim",
  opts = function()
    require("Comment.ft").set("zsh", "#%s")
  end,
}
