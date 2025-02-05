return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- 配置 qmlls
      lspconfig.qmlls.setup({
        cmd = { "/usr/lib/qt6/bin/qmlls" }, -- 确保 qmlls 在你的 PATH 中
        filetypes = { "qml", "qmljs" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        single_file_support = true,
      })
    end,
  },
}
