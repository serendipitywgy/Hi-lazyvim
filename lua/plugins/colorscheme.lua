return {
  -- {
  --   "tokyonight.nvim",
  --   -- 下面是透明背景，暂时注释
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },

  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   -- 下面是透明背景，暂时注释
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },
  -- {
  --   "glepnir/zephyr-nvim",
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    require("catppuccin").setup({
      transparent_background = true,
    }),
  },
}
