vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set leader key
vim.g.mapleader = " "


-- my keybinds
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })



-- Basic sane defaults
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true

-- Bootstrap lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
	-- Colorscheme
	-- { "folke/tokyonight.nvim", lazy = false, priority = 1000,
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true,
	config = function() vim.cmd.colorscheme("gruvbox") end },

	-- File explorer
	{ "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons",
	config = function() require("nvim-tree").setup({view = {
        width = 30,
        side = "left",
        preserve_window_proportions = true,
      },
      actions = {
        open_file = {
          quit_on_open = false,
        },
      },
     }) end }, 

	-- Fuzzy finder
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

	-- Git signs
	{ "lewis6991/gitsigns.nvim", config = true },

	-- Lualine statusline
	{ "nvim-lualine/lualine.nvim", dependencies = "nvim-tree/nvim-web-devicons",
	config = function() require("lualine").setup() end },

	-- Syntax highlighting & parsing
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	-- LSP core + installer
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim", config = true },
	{ "williamboman/mason-lspconfig.nvim" },


	-- Autocomplete stack
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	},})

	vim.lsp.config('luals', {
		cmd = {'lua-language-server'},
		filetypes = {'lua'},
		root_markers = {'.luarc.json', '.luarc.jsonc'},
	})


	vim.lsp.enable('luals')
	-- Let terminal transparency show through
	vim.cmd [[
	highlight Normal guibg=NONE ctermbg=NONE
	highlight NonText guibg=NONE ctermbg=NONE
	]]

