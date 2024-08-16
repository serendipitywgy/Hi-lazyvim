return {
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
}
