return {
  {
    -- 这是使用overseer
    "stevearc/overseer.nvim",
    config = function()
      local overseer = require("overseer")
      overseer.setup({
        templates = {
          "builtin",
        },
      })
      overseer.register_template({
        name = "conan build",
        builder = function()
          return {
            cmd = "conan",
            args = { "build", ".", "-pr:h=debug", "-pr:b=debug" },
            components = { { "on_output_quickfix", open = true }, "default" },
          }
        end,
      })
    end,
  },
  {
    -- 这是使用toggleterm
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    version = "*",
    config = function()
      require("toggleterm").setup({
        close_on_exit = false, -- 防止命令执行完毕后自动关闭
        shade_terminals = false, -- 禁用终端窗口的阴影效果
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local fs = vim.fs

      local function create_build_terminal(cmd, direction, float_opts)
        return Terminal:new({
          cmd = cmd,
          hidden = true,
          direction = direction,
          float_opts = float_opts,
          on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            -- vim.wo[term.window].winblend = 20 -- 设置终端窗口的透明度
          end,
          on_close = function(_)
            vim.cmd("startinsert!")
          end,
        })
      end
      local conan_build = create_build_terminal("conan build . -pr:h=debug -pr:b=debug", "float", {
        border = "double",
        width = 110,
      })

      local function generate_cmake_file(output)
        local cmake_content = [[
        cmake_minimum_required(VERSION 3.10)
        project(MyProject)

        set(CMAKE_CXX_STANDARD 17)

        # 设置编译选项
        set(CMAKE_CXX_FLAGS_DEBUG "-g -O1 -Wall -Wextra -Werror")
        set(CMAKE_BUILD_TYPE Debug)
        set(CMAKE_EXPORT_COMPILE_COMMANDS ON)   #生成并链接 compile_commands.json 文件，这对于代码分析工具和 IDE 非常有用

        # 在配置阶段创建软链接
        file(CREATE_LINK
            "${CMAKE_BINARY_DIR}/compile_commands.json"
            "${CMAKE_SOURCE_DIR}/compile_commands.json"
            SYMBOLIC
        )
        file(GLOB SOURCES "*.cpp")
        add_executable(]] .. output .. [[ ${SOURCES})
        ]]

        local cwd = vim.fn.getcwd()
        local cmake_file_path = cwd .. "/CMakeLists.txt"
        local cmake_file, err = io.open(cmake_file_path, "w")
        if not cmake_file then
          print("Error opening file: " .. err)
          return
        end

        cmake_file:write(cmake_content)
        cmake_file:close()
      end

      -- 编译和运行 C++ 文件的函数
      local function compile_and_run_cpp()
        local cwd = vim.fn.getcwd()
        local output_dir = "build"
        -- local output = sanitize_filename(vim.fn.fnamemodify(vim.fn.expand("%:t:r"), ":t:r")) -- 获取文件名（不含路径和扩展名）
        local output = vim.fn.fnamemodify(cwd, ":t") -- 获取当前文件夹名字作为项目名
        -- print("projectName:", output)

        -- 确保 build 目录存在
        vim.fn.mkdir(output_dir, "p")
        -- 生成 CMakeLists.txt 文件
        -- print("CMakeLists.txt_path: ", output)
        -- 检查 CMakeLists.txt 文件是否存在，如果不存在则生成默认的
        local cmake_file_path = cwd .. "/CMakeLists.txt"
        if vim.fn.filereadable(cmake_file_path) == 0 then
          -- print("CMakeLists.txt not found, generating default CMakeLists.txt")
          generate_cmake_file(output)
        else
          -- print("CMakeLists.txt is already exist!")
        end
        local compile_cmd = string.format("cd %s && cmake -B %s -S . && cmake --build %s", cwd, output_dir, output_dir)
        local run_cmd = string.format("cd %s && ./%s/%s", cwd, output_dir, output)

        local compile_terminal = create_build_terminal(compile_cmd, "horizontal", {
          border = "double",
          width = vim.o.columns,
          height = 10,
        })

        -- 检查是否已经存在运行终端，如果存在则关闭它
        if _G.run_terminal and _G.run_terminal:is_open() then
          _G.run_terminal:close()
        end

        _G.run_terminal = create_build_terminal(run_cmd, "float", {
          border = "double",
          width = math.floor(vim.o.columns * 0.2), -- 设置为当前编辑器窗口宽度的30%
          height = vim.o.lines - 2, -- 设置为当前编辑器窗口高度，减去边框的高度
          row = 1, -- 从顶部开始
          col = vim.o.columns - math.floor(vim.o.columns * 0.2) - 1, -- 从右侧开始
        })

        compile_terminal:toggle()
        -- 使用 vim.fn.jobstart 来启动编译命令，并在编译完成后关闭编译终端并打开运行终端
        vim.fn.jobstart(compile_cmd, {
          on_exit = function(_, exit_code)
            if exit_code == 0 then
              compile_terminal:close()
              _G.run_terminal:toggle()
            else
              print("Compilation failed with exit code:", exit_code)
            end
          end,
        })
      end

      function _G.smart_build()
        vim.cmd("wa")
        local cwd = vim.fn.getcwd()
        local has_conanfile = fs.find("conanfile.py", { path = cwd, upward = true, type = "file" })[1] ~= nil
        local has_cmakelist = fs.find("CMakeLists.txt", { path = cwd, upward = true, type = "file" })[1] ~= nil

        if has_conanfile then
          conan_build:toggle()
        elseif has_cmakelist then
          -- 使用 CMake Tools 插件的命令
          vim.cmd("CMakeRun")
          -- compile_and_run_cpp()
        else
          -- print("No conanfile.py or CMakeLists.txt found in the project directory.")
          -- 编译和运行 C++ 文件
          compile_and_run_cpp()
        end
      end
      -- 简化在多个 Vim 模式下设置相同键位映射的过程
      local function set_keymap_multi_mode(modes, lhs, rhs, opts)
        for _, mode in ipairs(modes) do
          vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
        end
      end

      set_keymap_multi_mode({ "n", "i", "t" }, "<F5>", "<cmd>lua smart_build()<CR>", { noremap = true, silent = true })
    end,
  },
}
