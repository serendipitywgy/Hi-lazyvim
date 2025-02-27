return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  lazy = true,
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = LazyVim.config.icons

    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          LazyVim.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path() },
        },
        lualine_x = {
          Snacks.profiler.status(),
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = function()
              return { fg = Snacks.util.color("Statement") }
            end,
          },
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function()
              return { fg = Snacks.util.color("Constant") }
            end,
          },
          {
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            color = function()
              return { fg = Snacks.util.color("Debug") }
            end,
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function()
              return { fg = Snacks.util.color("Special") }
            end,
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    -- do not add trouble symbols if aerial is enabled
    -- And allow it to be overriden for some buffer types (see autocmds)
    if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      table.insert(opts.sections.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
    end

    -- Adding cmake-tools components
    local cmake = require("cmake-tools")
    local icons = require("plugins.plugin_config.icons")

    local cmake_preset_component = {
      function()
        local type = cmake.get_build_type()
        return "CMake: [" .. (type and type or "") .. "]"
      end,
      icon = icons.ui.Search,
      cond = function()
        return cmake.is_cmake_project() and not cmake.has_cmake_preset()
      end,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd("CMakeSelectBuildType")
          end
        end
      end,
    }

    local CMakeSelectKit_component = {
      function()
        local kit = cmake.get_kit()
        return "[" .. (kit and kit or "No active kit") .. "]"
      end,
      icon = icons.ui.Pencil,
      cond = function()
        return cmake.is_cmake_project() and not cmake.has_cmake_preset()
      end,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd("CMakeSelectKit")
          end
        end
      end,
    }

    local CMakebuild_component = {
      function()
        return "Build"
      end,
      icon = icons.ui.Gear,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd("CMakeBuild")
          end
        end
      end,
    }

    local CMakeSelectBuildTarget_component = {
      function()
        local b_target = cmake.get_build_target()
        return "[" .. (b_target and b_target or "unspecified") .. "]"
      end,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd("CMakeSelectBuildTarget")
          end
        end
      end,
    }

    local CMakeDebug_component = {
      function()
        return icons.ui.Debug
      end,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd("CMakeDebug")
          end
        end
      end,
    }

    local CMakeRun_component = {
      function()
        return icons.ui.Run
      end,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd("CMakeRun")
          end
        end
      end,
    }

    local CMakeSelectLaunchTarget_component = {
      function()
        local l_target = cmake.get_launch_target()
        return "[" .. (l_target and l_target or "unspecified") .. "]"
      end,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if n == 1 then
          if mouse == "l" then
            vim.cmd("CMakeSelectLaunchTarget")
          end
        end
      end,
    }

    table.insert(opts.sections.lualine_c, cmake_preset_component)
    table.insert(opts.sections.lualine_c, CMakeSelectKit_component)
    table.insert(opts.sections.lualine_c, CMakebuild_component)
    table.insert(opts.sections.lualine_c, CMakeSelectBuildTarget_component)
    table.insert(opts.sections.lualine_c, CMakeDebug_component)
    table.insert(opts.sections.lualine_c, CMakeRun_component)
    table.insert(opts.sections.lualine_c, CMakeSelectLaunchTarget_component)

    return opts
  end,
}
