return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.completion = { list = { selection = "auto_insert" } }
    opts.keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    }
  end,
}
