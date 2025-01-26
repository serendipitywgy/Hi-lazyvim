-- 定义模块表
local M = {}

-- 配置 toggleterm 插件
function M.setup() --function M.setup() 定义了一个名为 setup 的函数，并将其作为 M 表的一个字段。这意味着 setup 函数是 M 模块的一部分，可以通过 M.setup 来调用
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return 10
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.2
      end
    end,
    open_mapping = [[<C-t>]],
    hide_numbers = true, -- 隐藏 toggleterm 缓冲区中的行号列
    autochdir = true, -- 自动切换目录
    shade_terminals = false, -- 禁用终端窗口的阴影效果
    start_in_insert = true, -- 启动时进入插入模式
    insert_mappings = true, -- 是否在插入模式下应用打开映射
    terminal_mappings = true, -- 是否在打开的终端中应用打开映射
    persist_size = true, -- 持久化终端大小
    persist_mode = true, -- 持久化终端模式
    direction = "tab", -- 终端方向
    close_on_exit = false, -- 进程退出时关闭终端窗口
    auto_scroll = false, -- 自动滚动到终端输出的底部
    float_opts = {
      border = "curved", -- 浮动终端的边框样式
      width = 70, -- 浮动终端的宽度
      height = 18, -- 浮动终端的高度
      -- winblend = 0, -- 浮动终端的透明度 --这一行不需要，不用的话，旧跟自带终端保持一致
    },
    highlights = {
      Normal = {
        guibg = "none", -- 正常终端背景颜色
      },
      NormalFloat = {
        link = "Normal", -- 浮动终端背景颜色链接到正常终端
      },
      FloatBorder = {
        guibg = "none", -- 浮动终端边框背景颜色
      },
    },
    winbar = {
      enabled = false, -- 禁用窗口栏
      name_formatter = function(term) -- 终端名称格式化函数
        return term.name
      end,
    },
  })

  --************************ 上面是配置 toggleterm 插件 *******************************

  -- 定义与 toggleterm 相关的功能
  local Terminal = require("toggleterm.terminal").Terminal
  local fs = vim.fs

  -- 创建构建终端
  local function create_build_terminal(cmd, direction, float_opts)
    return Terminal:new({
      cmd = cmd,
      hidden = true,
      direction = direction,
      float_opts = float_opts,
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      end,
      on_close = function(_)
        vim.cmd("startinsert!")
      end,
    })
  end

  -- Conan 构建终端
  local conan_build = create_build_terminal("conan build . -pr:h=debug -pr:b=debug", "float", {
    border = "double",
    width = 110,
  })
  -- QML 运行终端
  local qml_run = nil

  -- 创建 QML 运行终端的函数
  local function create_qml_run_terminal()
    local current_file = vim.fn.expand("%:p")
    if current_file:match("%.qml$") then
      qml_run = Terminal:new({
        cmd = "qml6 " .. current_file,
        hidden = true,
        direction = "vertical",
        float_opts = {
          border = "double",
          width = 110,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        on_close = function(_)
          vim.cmd("startinsert!")
        end,
        on_exit = function(term, job_id, exit_code, event)
          if exit_code == 0 then
            term:close()
          end
        end,
      })
      qml_run:toggle() -- 确保终端被正确打开
    else
      print("当前文件不是 QML 文件")
    end
  end

  --智能构建函数
  function _G.smart_build()
    vim.cmd("wa")
    local cwd = vim.fn.getcwd()
    local has_conanfile = fs.find("conanfile.py", { path = cwd, upward = true, type = "file" })[1] ~= nil
    local has_cmakelist = fs.find("CMakeLists.txt", { path = cwd, upward = true, type = "file" })[1] ~= nil

    if has_conanfile then
      conan_build:toggle()
    elseif has_cmakelist then
      vim.cmd("CMakeRun")
    else
      create_qml_run_terminal()
    end
  end

  -- 设置多模式键映射
  local function set_keymap_multi_mode(modes, lhs, rhs, opts)
    for _, mode in ipairs(modes) do
      vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
  end

  -- 设置键映射
  set_keymap_multi_mode({ "n", "i", "t" }, "<F5>", "<cmd>lua smart_build()<CR>", { noremap = true, silent = true })
end

-- 返回模块表
return M
