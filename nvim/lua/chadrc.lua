---@type ChadrcConfig
local M = {}
M.base46 = {
  theme = "tokyonight",
  hl_add = { floatTermBg = { bg = "darker_black" }, floatTermBorder = { bg = "darker_black", fg = "darker_black" } },
  integrations = {
    "flash",
  },
}
M.ui = {
  telescope = {
    style = "bordered",
  },
  statusline = {
    theme = "minimal",
    separator_style = "round",
  },
}
M.nvdash = {
  load_on_startup = true,
  header = {
    "88888888888  888888888888  ,ad8888ba",
    "88                88      d8       8b",
    "88                88     d8           ",
    "88aaaaa           88     88            ",
    "88                88     88      88888 ",
    "88                88     Y8,        88 ",
    "88                88      Y8a.    .a88 ",
    "88                88        Y88888P  ",
  },
}
M.term = {
  winopts = { winfixbuf = true },
  float = {
    row = 0.3,
    col = 25,
    width = 0.5,
    height = 0.4,
    border = "single",
  },
}
return M
