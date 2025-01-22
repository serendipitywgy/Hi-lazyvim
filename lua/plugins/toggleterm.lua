return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("plugins.plugin_config.toggleterm_config").setup()
  end,
}
