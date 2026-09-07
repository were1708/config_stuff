return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    local treesitter = require("nvim-treesitter")
    local languages = { "bash", "c", "html", "lua", "markdown", "vim", "vimdoc", "ruby", "zsh" }

    treesitter.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })
    treesitter.install(languages)

    local available_languages = {}
    for _, language in ipairs(treesitter.get_available()) do
      available_languages[language] = true
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("kickstart-treesitter", { clear = true }),
      callback = function(event)
        local filetype = vim.bo[event.buf].filetype
        local language = vim.treesitter.language.get_lang(filetype)

        if not available_languages[language] then
          return
        end

        treesitter.install(language)
        if #vim.api.nvim_get_runtime_file("parser/" .. language .. ".*", false) == 0 then
          return
        end

        vim.treesitter.start(event.buf, language)
        if filetype ~= "ruby" then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end,
}
