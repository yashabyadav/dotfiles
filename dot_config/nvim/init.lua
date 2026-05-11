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
-- Completion menu behavior for nvim-cmp
vim.o.completeopt = "menu,menuone,noselect"

-- Bootstrap lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)


-- bootstrap lazy...
require("lazy").setup({ import = "plugins" })  -- auto-load all lua/plugins/*.lua

-- Let terminal transparency show through
vim.cmd [[
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
]]

