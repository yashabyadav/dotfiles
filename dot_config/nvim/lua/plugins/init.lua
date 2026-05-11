return {
  -- Colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function() require("config.colors") end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function() require("config.nvimtree") end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- add config file later if you want custom mappings
  },

  -- Git signs
  { "lewis6991/gitsigns.nvim", config = true },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function() require("config.lualine") end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() require("config.treesitter") end,
  },

  -- LSP stack
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = { ensure_installed = { "pyright", "lua_ls" }, automatic_installation = true },
  },
  {
	  "neovim/nvim-lspconfig",
	  dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
	  config = function() require("config.lsp") end,
  },

  -- Completion stack
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function() require("config.cmp") end,
  },
}
