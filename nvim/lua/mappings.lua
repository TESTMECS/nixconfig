require "nvchad.mappings"
local map = vim.keymap.set
local harpoon = require "harpoon"
vim.keymap.del("n", "<leader>e")
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>z", "za", { desc = "Toggle fold" })
--Plugins
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy" })
map("n", "<leader>um", "<cmd>Mason<CR>", { desc = "Mason" })
map("n", "<leader>z", "<cmd>Zen<CR>", { desc = "Zen mode" })
map("n", "<leader>ds", "<cmd>ToggleDiagnostics<CR>", { desc = "Toggle Diagnostics" })
map("n", "<leader>cb", function()
  require("nvchad.tabufline").closeBufs_at_direction "left"
end, { desc = "Close All Buffers" })
map("n", "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Action" })
map("n", "<leader>md", "<cmd>Markview<CR>", { desc = "Markview Toggle" })
map("n", "<leader>h", "<cmd>FloatermToggle<CR>", { desc = "Floaterm Toggle" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Telescope Keymaps" })
map("n", "<C-K>", function()
  vim.diagnostic.open_float()
end, { desc = "open diagnostic undercursor" })
-- Harpoon
map("n", "<leader>p", function()
  harpoon:list():add()
end, { desc = "Harpoon Toggle" })

map("n", "<leader>p1", function()
  harpoon:list():select(1)
end, { desc = "Harpoon Toggle Quick Menu" })

map("n", "<leader>p2", function()
  harpoon:list():select(2)
end, { desc = "Harpoon Toggle Quick Menu" })

map("n", "<leader>p3", function()
  harpoon:list():select(3)
end, { desc = "Harpoon Toggle Quick Menu" })

map("n", "<C-p>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Quick Menu" })
