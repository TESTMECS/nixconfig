-- Globals
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
-- Options
vim.o.relativenumber = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smoothscroll = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.scrolloff = 10
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus"
-- Commands
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
-- Key maps.
local map = vim.keymap.set
-- Plugins.
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find Files" })
map("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", { desc = "Find Keymaps" })
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "File Tree" })
-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })
-- VIM maps
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("n", "<C-s>", "<cmd>write<CR>", { desc = "save" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "clear highlights" })
map("n", "<leader>rr", "<cmd>restart<CR>", { desc = "restart" })
-- Declare Packages.
vim.pack.add({
	-- Color
	"https://github.com/vague2k/vague.nvim.git",
	"https://github.com/nvim-lualine/lualine.nvim",
	-- Essentials
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-lua/plenary.nvim", version = "v0.1.4" },
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	-- The true essential
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
	"https://github.com/pohlrabi404/compile.nvim",
	-- Extras
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/OXY2DEV/markview.nvim",
	"https://github.com/stevearc/conform.nvim",
	--completion
	"https://github.com/echasnovski/mini.completion",
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = "v2.4.0" },
	-- AI
	"https://github.com/supermaven-inc/supermaven-nvim",
})
-- Setup Plugins
-- Colorscheme
vim.cmd("colorscheme vague")

-- Treesitter.
require("nvim-treesitter").setup({
	ensure_installed = {
		"lua",
		"zig",
		"rust",
		"typescript",
		"markdown",
		"json",
		"nix",
		"bash",
		"nu",
		"html",
		"go",
		"vim",
		"vimdoc",
		"janet_simple",
	},
	highlight = { enable = true, use_languagetree = true },
	indent = { enable = true },
})
require("fzf-lua").setup({ "fzf-native" })
require("mason").setup({})
require("nvim-tree").setup({})
require("markview").setup({})
require("supermaven-nvim").setup({})
require("mini.completion").setup({
	window = {
		info = { height = 25, width = 80, border = "rounded" },
		signature = { height = 25, width = 80, border = "rounded" },
	},
})
require("compile").setup({
	cmds = {
		default = "cargo build",
	},
})
require("lualine").setup({
	theme = "codedark",
	sections = {
		lualine_y = { "lsp_status" },
	},
})
local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>h", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		go = { "gopls" },
		nix = { "nixfmt" },
	},
})
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_cap = require("mini.completion").get_lsp_capabilities()
vim.tbl_deep_extend("force", capabilities, cmp_cap)
-- Lsp config
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
vim.lsp.enable({ "lua_ls", "rust_analyzer", "rnix_lsp" })
