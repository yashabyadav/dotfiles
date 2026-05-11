local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local util = require("lspconfig.util")


require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "lua_ls" },
  automatic_installation = true,
})


require("mason-lspconfig").setup_handlers({
  function(server)
    lspconfig[server].setup({ capabilities = capabilities })
  end,
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })
  end,
})

-- Ensure Pyright is explicitly configured (sometimes handlers may not register on some setups)
if lspconfig.pyright and not lspconfig.util then
  -- no-op: just guarding
end
lspconfig.pyright.setup({
  capabilities = capabilities,
  single_file_support = true,
  root_dir = function(fname)
    return util.root_pattern(
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      ".git"
    )(fname)
      or (fname ~= "" and util.path.dirname(fname))
      or vim.loop.cwd()
  end,
})


--[[
-- Python
lspconfig.pyright.setup({
  capabilities = capabilities,
})

-- Lua (Neovim)
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})
--]]
