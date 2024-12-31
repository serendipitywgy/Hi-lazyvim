-- 一个预览函数引用的插件
-- Trouble.nvim 配置
local trouble_setting = {
  modes = {
    fzf_preview = {
      mode = "fzf",
      preview = {
        type = "split",
        relative = "win",
        position = "right",
        size = 0.5,
      },
    },
  },
}

-- fzf-lua 配置
local fzf_lua_setting = {
  winopts = {
    height = 0.8,
    width = 0.8,
    row = 0.1,
    col = 0.1,
    border = "rounded",
    preview = {
      vertical = "right:50%",
      horizontal = "down:50%",
      layout = "vertical",
    },
  },
  actions = {
    files = {
      ["default"] = function()
        require("trouble").open("lsp_references")
      end,
    },
  },
}

-- 插件配置
return {
  {
    "folke/trouble.nvim",
    opts = trouble_setting,
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>FzfLua diagnostics<cr>",
        desc = "Diagnostics (FzfLua)",
      },
      {
        "<leader>xX",
        "<cmd>FzfLua diagnostics filter.buf=0<cr>",
        desc = "Buffer Diagnostics (FzfLua)",
      },
      {
        "<leader>cs",
        "<cmd>FzfLua lsp_document_symbols<cr>",
        desc = "Symbols (FzfLua)",
      },
      {
        "<leader>cl",
        "<cmd>FzfLua lsp_definitions<cr>",
        desc = "LSP Definitions (FzfLua)",
      },
      {
        "<leader>cS",
        "<cmd>FzfLua lsp_references<cr>",
        desc = "LSP References (FzfLua)",
      },
      {
        "<leader>xL",
        "<cmd>FzfLua loclist<cr>",
        desc = "Location List (FzfLua)",
      },
      {
        "<leader>xQ",
        "<cmd>FzfLua quickfix<cr>",
        desc = "Quickfix List (FzfLua)",
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    opts = fzf_lua_setting,
    cmd = "FzfLua",
    keys = {
      {
        "<leader>fr",
        "<cmd>FzfLua lsp_references<cr>",
        desc = "LSP References (FzfLua)",
      },
    },
  },
}
