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
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local fs = vim.fs

      local function create_build_terminal(cmd)
        return Terminal:new({
          cmd = cmd,
          hidden = true,
          direction = "float",
          float_opts = {
            border = "double",
          },
          on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          end,
          on_close = function(_)
            vim.cmd("startinsert!")
          end,
        })
      end

      local conan_build = create_build_terminal("conan build . -pr:h=debug -pr:b=debug")

      -- 编译和运行 C++ 文件的函数
      local function compile_and_run_cpp()
        local cwd = vim.fn.getcwd()
        local output_dir = "build"
        local output = vim.fn.fnamemodify(vim.fn.expand("%:t:r"), ":t:r") -- 获取文件名（不含路径和扩展名）
        local output_path = output_dir .. "/" .. output

        -- 确保 build 目录存在
        vim.fn.mkdir(output_dir, "p")

        -- 查找当前目录下的所有 .cpp 文件
        local cpp_files = vim.fn.globpath(cwd, "*.cpp", false, true)
        local files_to_compile = table.concat(cpp_files, " ")

        local cmd = string.format(
          "cd %s && rm -f %s && g++ %s -o %s && ./%s",
          cwd,
          output_path,
          files_to_compile,
          output_path,
          output_path
        )

        -- 添加日志信息
        -- print("Files to compile: " .. files_to_compile)
        -- print("Output executable: " .. output_path)
        -- print("Command to run: " .. cmd)

        local gpp_build = create_build_terminal(cmd)
        gpp_build:toggle()
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
        else
          -- print("No conanfile.py or CMakeLists.txt found in the project directory.")
          -- 编译和运行 C++ 文件
          compile_and_run_cpp()
        end
      end
      -- 简化在多个 Vim 模式下设置相同键位映射的过程
      function set_keymap_multi_mode(modes, lhs, rhs, opts)
        for _, mode in ipairs(modes) do
          vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
        end
      end

      set_keymap_multi_mode({ "n", "i", "t" }, "<F5>", "<cmd>lua smart_build()<CR>", { noremap = true, silent = true })
    end,
  },
}
