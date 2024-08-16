-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "kj", "<Esc>", { silent = true })
vim.keymap.set("t", "kj", "<C-\\><C-n>", { silent = true })

-- 在 ~/.config/nvim/lua/config/keymaps.lua 中
local overseer = require("overseer")
local function run_conan_build()
  overseer.run_template({ name = "conan build" })
end
vim.keymap.set({ "n", "i", "v" }, "<F5>", run_conan_build, { desc = "Run Conan Build" })
