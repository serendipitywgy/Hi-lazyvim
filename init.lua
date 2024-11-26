-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- 背景透明
function Transparent(color)
  color = color or "gruvbox"
  -- color = color or "tokyonight"
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
Transparent()
