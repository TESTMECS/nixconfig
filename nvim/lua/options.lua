require "nvchad.options"
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 99
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorlineopt = "both"
-- Diagnostics
usercmd("ToggleDiagnostics", function()
  local current_value = vim.diagnostic.config().virtual_text
  if current_value then
    vim.diagnostic.config { virtual_text = false }
  else
    vim.diagnostic.config { virtual_text = true }
  end
end, {})
usercmd("CursorDiagnostics", function()
  vim.diagnostic.open_float()
end, {})
usercmd("ToggleSupercomplete", function()
  require("supermaven").toggle()
end, {})
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})
usercmd("ConjureSpork", function()
  vim.fn.jobstart 'janet -e "(import spork/netrepl) (netrepl/server)"'
  vim.notify "Conjure Spork started"
end, {})
