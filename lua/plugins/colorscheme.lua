local catppuccin_config = {
  flavour = "macchiato", -- 选择主题风格，可以是 "latte"（浅色），"frappe"（中等深色），"macchiato"（深色），"mocha"（最深色）。"auto" 会根据背景自动选择风格。
  background = { -- 背景类型配置
    light = "latte", -- 浅色背景时使用 "latte" 风格
    dark = "macchiato", -- 深色背景时使用 "mocha" 风格
  },
  transparent_background = true, -- 设置背景透明
  show_end_of_buffer = false, -- 在缓冲区结束后显示 '~' 字符
  term_colors = false, -- 配置终端颜色（例如 `g:terminal_color_0`）
  dim_inactive = {
    enabled = false, -- 启用非活动窗口背景变暗
    shade = "dark", -- 变暗的颜色类型（"dark" 或 "light"）
    percentage = 0.15, -- 变暗的百分比
  },
  no_italic = false, -- 禁用斜体
  no_bold = false, -- 禁用粗体
  no_underline = false, -- 禁用下划线
  styles = { -- 配置一般高亮组的样式（参见 `:h highlight-args`）
    comments = { "italic" }, -- 配置注释的样式为斜体
    conditionals = { "italic" }, -- 配置条件语句的样式为斜体
    loops = {}, -- 配置循环语句的样式
    functions = {}, -- 配置函数的样式
    keywords = {}, -- 配置关键字的样式
    strings = {}, -- 配置字符串的样式
    variables = {}, -- 配置变量的样式
    numbers = {}, -- 配置数字的样式
    booleans = {}, -- 配置布尔值的样式
    properties = {}, -- 配置属性的样式
    types = {}, -- 配置类型的样式
    operators = {}, -- 配置操作符的样式
    -- miscs = {}, -- 取消注释以关闭硬编码样式
  },
  color_overrides = {}, -- 自定义颜色覆盖
  custom_highlights = function()
    require("catppuccin").setup({
      term_colors = true,
      transparent_background = true,

      custom_highlights = function(colors)
        local u = require("catppuccin.utils.colors")
        return {
          CursorLineNr = { bg = u.blend(colors.overlay0, colors.base, 0.9), style = { "bold" } },
          CursorLine = { bg = u.blend(colors.overlay0, colors.base, 0.6) },
          -- 使用更亮的颜色来突出 LspReferenceText、LspReferenceWrite 和 LspReferenceRead
          LspReferenceText = { bg = u.blend(colors.surface2, colors.base, 0.8) },
          LspReferenceWrite = { bg = u.blend(colors.surface2, colors.base, 0.8) },
          LspReferenceRead = { bg = u.blend(colors.surface2, colors.base, 0.8) },
          -- 自定义 Visual 模式的高亮，使其在透明背景下更为显眼
          Visual = { bg = u.blend(colors.blue, colors.base, 0.5) },
        }
      end,
    })
  end, -- 自定义高亮
  default_integrations = true, -- 启用默认的插件集成
  integrations = {
    cmp = true, -- 启用 nvim-cmp 插件的集成
    gitsigns = true, -- 启用 gitsigns 插件的集成
    nvimtree = true, -- 启用 nvim-tree 插件的集成
    treesitter = true, -- 启用 treesitter 插件的集成
    notify = false, -- 启用 notify 插件的集成
    mini = {
      enabled = true, -- 启用 mini 插件的集成
      indentscope_color = "", -- 配置 indentscope 的颜色
    },
    -- 更多插件集成请参考 catppuccin 的 GitHub 页面：https://github.com/catppuccin/nvim#integrations
  },
}

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
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup(catppuccin_config)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
