return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        -- ... 其他选项 ...
        separator_style = "thick", -- 使用粗分隔符
        indicator = {
          style = "underline", -- 当前缓冲区下划线指示
          icon = "➤", -- 或使用箭头图标
        },
        animation = {
          duration = 300, -- 动画持续时间（毫秒）
          easing = "in_out_sine", -- 缓动效果：in_out_sine / linear / etc.
        },
      },
      highlights = {
        buffer_selected = {
          fg = "#FFD700", -- 金色文字
          -- bg = "#1E3A8A", -- 深蓝色背景
          bold = true,
          italic = true,
          underline = true, -- 添加下划线
        },
        fill = {
          bg = "#2D2D2D", -- 整体背景色加深
        },
      },
    },
  },
}
