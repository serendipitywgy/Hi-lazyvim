-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set("i", "kj", "<Esc>", { silent = true })
-- vim.keymap.set("t", "kj", "<C-\\><C-n>", { silent = true })
-- 定义一个函数来设置多个键映射
local function set_keymaps(mode, keymaps, target, opts)
  for _, keymap in ipairs(keymaps) do
    vim.keymap.set(mode, keymap, target, opts)
  end
end

-- 插入模式下，按下 kj 或 KJ 不执行任何操作
set_keymaps("i", { "kj", "KJ" }, "<Esc>", { silent = true })

-- 终端模式下，按下 kj 发送 Ctrl+\
vim.keymap.set("t", "kj", "<C-\\>", { silent = true })
-- 在 ~/.config/nvim/lua/config/keymaps.lua 中
-- local overseer = require("overseer")
-- local function run_conan_build()
--   overseer.run_template({ name = "conan build" })
-- end
-- vim.keymap.set({ "n", "i", "v" }, "<F5>", run_conan_build, { desc = "Run Conan Build" })

vim.keymap.set("n", "<leader>rn", ":IncRename ")
