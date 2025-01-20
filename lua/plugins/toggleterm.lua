return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("plugins.setting.toggleterm_config").setup()
  end,
}
