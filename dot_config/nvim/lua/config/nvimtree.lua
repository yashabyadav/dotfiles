require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = true,
  },
  actions = {
    open_file = { quit_on_open = false },
  },
})
