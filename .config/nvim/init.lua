--- @key
--- @globals
--- @options
--- @commands
--- @keymaps
--- @Packages : Vim Pack URLS
--- @colorscheme
--- @plugins : Configurations
--- @lspconfig
--- @endkey
-----------------
--- @globals
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
--- @options
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
--- @commands
local autocmd = vim.api.nvim_create_autocmd
autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	desc = "Hightlight selection on yank",
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
	end,
})
autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
--- @keymaps
local map = vim.keymap.set

--- @keymaps: windows
map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<leader>tt", "<cmd>tabn<CR>", { desc = "switch tab" })

--- @keymaps: vim
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })
map("n", "<C-s>", "<cmd>write<CR>", { desc = "save" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "clear highlights" })
map("n", "<leader>rr", "<cmd>restart<CR>", { desc = "restart" })
map("n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to definition" })

--- @keymaps: fzf-lua
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find Files" })
map("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", { desc = "Find Keymaps" })
map("n", "<leader>fw", "<cmd>FzfLua live_grep<CR>", { desc = "Find Word" })
map("n", "<leader>fc", "<cmd>FzfLua commands<CR>", { desc = "Find Commands" })

--- @keymaps: neowiki
map("n", "<leader>ww", function()
	local wiki = require("neowiki")
	wiki.open_wiki_new_tab("vault")
end, { desc = "Open Wiki" })

--- @keymaps: neowiki search
map("n", "<leader>wf", function()
	require("fzf-lua").files({
		cwd = vim.fn.getenv("VAULT_PATH"),
	})
end, { desc = "Find Files" })
--- @keymaps: nvim-tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "File Tree" })
--- @keymaps: tiny-inline-diagnostic
map("n", "<leader>td", function()
	local diag = require("tiny-inline-diagnostic")
	diag.toggle()
end, { desc = "toggle diagnostic" })

--- @Packages
vim.pack.add({
	---@plugin: Theme
	"https://github.com/vague2k/vague.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	---@plugin: Essentials
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-lua/plenary.nvim", version = "v0.1.4" },
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/OXY2DEV/markview.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/ej-shafran/compile-mode.nvim",
	"https://github.com/echaya/neowiki.nvim",
	---@plugin: completion
	"https://github.com/echasnovski/mini.completion",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/echasnovski/mini.snippets",
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = "v2.4.0" },
	---@plugin: AI
	"https://github.com/supermaven-inc/supermaven-nvim",
})
--- @plugins: compile-mode
vim.g.compile_mode = {}
--- @colorscheme
vim.cmd([[colorscheme vague]])
--- @plugins: treesitter
require("nvim-treesitter").setup({
	ensure_installed = {
		"lua",
		"typescript",
		"javascript",
		"markdown",
		"json",
		"nix",
		"bash",
		"html",
		"go",
		"vim",
		"vimdoc",
	},
	cmds = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
	highlight = { enable = true, use_languagetree = true },
	indent = { enable = true },
})
--- @plugins: neowiki
require("neowiki").setup({
	wiki_dirs = {
		name = "vault",
		path = vim.fn.getenv("VAULT_PATH"),
	},
	index_file = "Index.md",
})
--- @plugins: nvim-autopairs
require("nvim-autopairs").setup({})
--- @plugins: fzf-lua
require("fzf-lua").setup({ "fzf-native" })
--- @plugins: tiny-inline-diagnostic
require("tiny-inline-diagnostic").setup({})
--- @plugins: mason
require("mason").setup({})
--- @plugins: nvim-tree
require("nvim-tree").setup({
	view = {
		float = {
			enable = true,
			open_win_config = function()
				local HEIGHT_RATIO = 0.8
				local WIDTH_RATIO = 0.5
				local screen_w = vim.opt.columns:get()
				local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
				local window_w = screen_w * WIDTH_RATIO
				local window_h = screen_h * HEIGHT_RATIO
				local window_w_int = math.floor(window_w)
				local window_h_int = math.floor(window_h)
				local center_x = (screen_w - window_w) / 2
				local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
				return {
					border = "rounded",
					relative = "editor",
					row = center_y,
					col = center_x,
					width = window_w_int,
					height = window_h_int,
				}
			end,
		},
		width = function()
			local WIDTH_RATIO = 0.5
			return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
		end,
	},
})
--- @plugins: markview
require("markview").setup({})
--- @plugins: supermaven-nvim
require("supermaven-nvim").setup({})
--- @plugins: mini.completion
require("mini.completion").setup({})
--- @plugins: mini.snippets
local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
	snippets = {
		gen_loader.from_file("~/.config/nvim/snippets/global.json"),
		gen_loader.from_lang(),
	},
	mappings = {
		expand = "<C-y>",
		stop = "<C-y><C-c>",
	},
})
require("mini.snippets").start_lsp_server()
--- @plugins: lualine
require("lualine").setup({
	sections = {
		lualine_y = { "lsp_status" },
	},
})
--- @plugins: conform
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		go = { "go fmt" },
		nix = { "nixfmt" },
		python = { "ruff" },
		javascript = { "prettier" },
		c = { "clang-format" },
	},
})
--- @plugins: lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_cap = require("mini.completion").get_lsp_capabilities()
vim.tbl_deep_extend("force", capabilities, cmp_cap)
--- @lspconfig Clangd
vim.lsp.config("clangd", {
	settings = {
		clangd = {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
			},
			root_markers = {
				".git",
				".clangd",
			},
		},
	},
})
--- @lspconfig Lua_ls
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
--- @lspconfig ocamllsp
vim.lsp.enable("ocamllsp", {
	settings = {
		ocamllsp = {
			cmd = { "ocaml-language-server", "--stdio" },
			filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },
			root_markers = { "*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace" },
		},
	},
})
vim.lsp.enable({ "lua_ls", "rnix_lsp", "gopls", "ruff", "eslint_d", "zls", "deno", "clangd" })
