return {
  cmake_command = "cmake",
  ctest_command = "ctest",
  cmake_use_preset = false,
  cmake_regenerate_on_save = false,
  cmake_generate_options = {
    "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
  },
  cmake_build_options = { "-j4" },
  cmake_build_directory = "build/${variant:buildType}",
  cmake_soft_link_compile_commands = true,

  cmake_executor = {
    name = "toggleterm",
    opts = {
      direction = "float", -- 浮动窗口
      close_on_exit = true, -- 不自动关闭
      auto_scroll = true, -- 自动滚动到底部
      singleton = true, -- 单实例模式
      float_opts = {
        border = "rounded", -- 圆角边框
        width = 100, -- 窗口宽度
        height = 30, -- 窗口高度
        winblend = 3, -- 轻微透明
      },
    },
  },

  cmake_runner = {
    name = "toggleterm",
    opts = {
      direction = "float", -- 浮动窗口
      close_on_exit = false, -- 不自动关闭
      auto_scroll = true, -- 自动滚动到底部
      singleton = false, -- 运行结果使用新实例
      float_opts = {
        border = "rounded", -- 圆角边框
        width = 100, -- 窗口宽度
        height = 30, -- 窗口高度
        winblend = 3, -- 轻微透明
      },
    },
  },

  cmake_dap_configuration = {
    name = "cpp",
    type = "codelldb",
    request = "launch",
    stopOnEntry = false,
    runInTerminal = true,
    console = "integratedTerminal",
  },

  cmake_notifications = {
    runner = { enabled = true },
    executor = { enabled = true },
    spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    refresh_rate_ms = 100,
  },

  cmake_virtual_text_support = true,
}
