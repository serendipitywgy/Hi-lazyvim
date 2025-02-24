return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- 设置 Tab 键向下切换候选词
        ["<Tab>"] = { "select_next", "fallback" },

        -- 设置 Shift-Tab 键往上切换候选词
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
    },
  },
}
