-- Ensure you have the nvim-lspconfig plugin installed
local lspconfig = require("lspconfig")

-- Configure QML language server
lspconfig.qmlls.setup({
  cmd = { "/usr/lib/qt6/bin/qmlls" },
  filetypes = { "qml" },
  root_dir = function(fname)
    return vim.loop.cwd()
  end,
  settings = {},
})
