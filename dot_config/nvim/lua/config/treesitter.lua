require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "python", "vim", "vimdoc", "bash", "json", "markdown" },
  highlight = { enable = true },
  incremental_selection = { enable = true },
  indent = { enable = true },
})
