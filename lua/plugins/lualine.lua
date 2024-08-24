local cmake = require("cmake-tools")
local icons = require("utils.icons")
-- Credited to [evil_lualine](https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua)
local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local colors = {
  bg       = "#202328",
  fg       = "#bbc2cf",
  yellow   = "#ECBE7B",
  cyan     = "#008080",
  darkblue = "#081633",
  green    = "#98be65",
  orange   = "#FF8800",
  violet   = "#a9a1e1",
  magenta  = "#c678dd",
  blue     = "#51afef",
  red      = "#ec5f67",
}
local config = {
  options = {
    icons_enabled = true,
    component_separators = "",
    section_separators = "",
    disabled_filetypes = { "alpha", "dashboard", "Outline" },
    always_divide_middle = true,
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- c for left
    lualine_c = {},
    -- x for right
    lualine_x = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
  },
  tabline = {},
  extensions = {},
}
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end


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
        if (n == 1) then
            if (mouse == "l") then
                vim.cmd("CMakeSelectBuildType")
            end
        end
    end
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
        if (n == 1) then
            if (mouse == "l") then
                vim.cmd("CMakeSelectKit")
            end
        end
    end
}


local CMakebuild_component = {
    --"encoding"
    function()
        return "Build"
    end,
    icon = icons.ui.Gear,
    cond = cmake.is_cmake_project,
    on_click = function(n, mouse)
        if (n == 1) then
            if (mouse == "l") then
                vim.cmd("CMakeBuild")
            end
        end
    end
}

local CMakeSelectBuildTarget_component = {
    function()
        local b_target = cmake.get_build_target()
        return "[" .. (b_target and b_target or "unspecified") .. "]"
    end,
    cond = cmake.is_cmake_project,
    on_click = function(n, mouse)
        if (n == 1) then
            if (mouse == "l") then
                vim.cmd("CMakeSelectBuildTarget")
            end
        end
    end
}


local CMakeDebug_component = {
    function()
        return icons.ui.Debug
    end,
    cond = cmake.is_cmake_project,
    on_click = function(n, mouse)
        if (n == 1) then
            if (mouse == "l") then
                vim.cmd("CMakeDebug")
            end
        end
    end
}


local CMakeRun_component = {
    function()
        return icons.ui.Run
    end,
    cond = cmake.is_cmake_project,
    on_click = function(n, mouse)
        if (n == 1) then
            if (mouse == "l") then
                vim.cmd("CMakeRun")
            end
        end
    end
}

local CMakeSelectLaunchTarget_component = {
    function()
        local l_target = cmake.get_launch_target()
        return "[" .. (l_target and l_target or "unspecified") .. "]"
    end,
    cond = cmake.is_cmake_project,
    on_click = function(n, mouse)
        if (n == 1) then
            if (mouse == "l") then
                vim.cmd("CMakeSelectLaunchTarget")
            end
        end
    end
}
return{
     
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
        table.insert(opts.sections.lualine_c, cmake_preset_component)
        --table.insert(opts.sections.lualine_c, CMakeSelectKit_component)
        table.insert(opts.sections.lualine_c, CMakebuild_component)
        table.insert(opts.sections.lualine_c, CMakeSelectBuildTarget_component)
        table.insert(opts.sections.lualine_c, CMakeDebug_component)
        table.insert(opts.sections.lualine_c, CMakeRun_component)
        table.insert(opts.sections.lualine_c, CMakeSelectLaunchTarget_component) 
    end,
}
