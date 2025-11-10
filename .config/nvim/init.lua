--- @key
--- @globals @options
--- @commands
--- @usercmd
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
vim.o.number = true
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
local usercmd = vim.api.nvim_create_user_command
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
--- @usercmd: Shell
usercmd("Config", function()
	print("⭒₊ ⊹🌕₊ ⊹⭒")
	vim.cmd("e ~/.config/nvim/init.lua")
end, { desc = "Edit config file" })

usercmd("KeyCastr", function()
	require("keycastr").enable()
	print("🎹")
end, { desc = "Toggle keycastr" })

usercmd("KeyCastrD", function()
	require("keycastr").disable()
end, { desc = "Toggle keycastr" })

usercmd("Bashrc", function()
	vim.cmd("e ~/.bashrc")
end, { desc = "Edit bashrc file" })

usercmd("NixConfig", function()
	print("⋆˚☆˖°⋆｡° ✮˖ ࣪ ⊹⋆.˚")
	vim.cmd("e ~/nixconfig")
end, { desc = "Edit nix config file" })

--- @keymaps
local map = vim.keymap.set

--- @keymaps: Harpoon?
map("n", "<leader>a", function()
	print("Harpoon?🔱Add")
	vim.cmd("argadd")
	vim.cmd("argdedup")
	vim.cmd("normal! m'") -- Mark the line for o+i
end, { desc = "Harpoon?" })

map("n", "<leader>e", function()
	print("Harpoon?🔱List Empty")
	vim.cmd("args")
end, { desc = "Harpoon?" })

map("n", "<leader>1", function()
	print("Harpoon?1🔱")
	vim.cmd("silent! 1argument")
end, { desc = "Harpoon?" })

map("n", "<leader>2", function()
	print("Harpoon?2🔱")
	vim.cmd("silent! 2argument")
end, { desc = "Harpoon?" })

map("n", "<leader>3", function()
	print("Harpoon?3🔱")
	vim.cmd("silent! 3argument")
end, { desc = "Harpoon?" })

map("n", "<leader>4", function()
	print("Harpoon?4🔱")
	vim.cmd("silent! 4argument")
end, { desc = "Harpoon?" })

map("n", "<leader>hw", function()
	local cmd = vim.fn.input("Harpoon?🔱: ")

	local function is_num(str)
		return str:match("^%d+$")
	end

	local function split(s, delimiter)
		local result = {}
		if delimiter == "" then
			-- Edge case: empty delimiter (split by each character)
			for i = 1, #s do
				table.insert(result, s:sub(i, i))
			end
			return result
		end

		for part in string.gmatch(s, "([^" .. delimiter .. "]+)") do
			table.insert(result, part)
		end
		return result
	end

	-- Parse input
	local items = split(cmd, ",")
	local s1 = items[1]
	local s2 = items[2]
	local cmd_input = ""
	if is_num(s1) then
		-- include comma
		cmd_input = s1 .. s2 .. "argd"
	else
		cmd_input = s1 .. cmd .. "argd"
	end
	if cmd ~= "" then
		vim.cmd(cmd_input)
	end
end, { desc = "Harpoon?" })

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
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

--- @keymaps: fzf-lua
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find Files" })
map("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", { desc = "Find Keymaps" })
map("n", "<leader>fw", "<cmd>FzfLua live_grep<CR>", { desc = "Find Word" })
map("n", "<leader>fc", "<cmd>FzfLua commands<CR>", { desc = "Find Commands" })

--- @keymaps: neowiki open
map("n", "<leader>ww", function()
	local wiki = require("neowiki")
	wiki.open_wiki_new_tab("vault")
end, { desc = "Open Wiki" })
--- @keymaps: neowiki search
map("n", "<leader>wf", function()
	require("fzf-lua").files({
		cwd = "/mnt/c/Users/Superuser/MainVault",
	})
end, { desc = "Find Files" })

--- @keymaps: nvim-tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "File Tree" })

--- @keymaps: tiny-inline-diagnostic
map("n", "<leader>td", function()
	local diag = require("tiny-inline-diagnostic")
	diag.toggle()
end, { desc = "toggle diagnostic" })

--- @keymaps: Compile
map("n", "<leader>cc", function()
	local cmd = vim.fn.input("Compile: ")
	if cmd ~= "" then
		vim.cmd("Compile" .. " " .. cmd)
	end
end, { desc = "Compile with command input" })

map("n", "<leader>cr", "<cmd>Recompile<CR>", { desc = "recompile last" })
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
	"https://github.com/supermaven-inc/supermaven-nvim",
	"https://github.com/echasnovski/mini.completion",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/echasnovski/mini.snippets",
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = "v2.4.0" },
	"https://github.com/miikanissi/modus-themes.nvim",
	---@plugin: AI
	"https://github.com/4513ECHO/nvim-keycastr",
})
--- @plugins: compile-mode
vim.g.compile_mode = {}
--- @colorscheme
require("modus-themes").setup({
	style = "modus_vivendi", -- Use the dark base consistently
	variant = "deuteranopia", -- Balanced, subtle contrast variant
	line_nr_column_background = true, -- Helps anchor focus in the code gutter
	on_colors = function(colors)
		colors.error = colors.red_intense
		colors.bg_main = "#1b1d24" -- Custom background: deeper charcoal tone
		colors.fg_main = "#d6d6d6" -- Slightly desaturated foreground
	end,
	on_highlights = function(highlight, color)
		highlight.Boolean = { fg = color.blue_cooler, bold = true }
		highlight.Keyword = { fg = color.magenta_faint, italic = true }
		highlight.Function = { fg = color.cyan_cooler, bold = true }
		highlight.String = { fg = color.olive }
		highlight.Comment = { fg = color.maroon, italic = true }
		highlight.Number = { fg = color.magenta_cooler }
		highlight.Type = { fg = color.blue_warmer, italic = true }
		highlight.Visual = { bg = "#2a2f40" } -- Custom dimmed indigo background
		highlight.CursorLine = { bg = "#232733" } -- Helps navigation clarity
	end,
})

require("supermaven-nvim").setup({})

vim.cmd([[colorscheme modus_vivendi]])
--- @plugins: treesitter
require("nvim-treesitter").setup({
	ensure_installed = {
		"lua",
		"javascript",
		"markdown",
		"json",
		"odin",
		"nix",
		"bash",
		"html",
		"vim",
		"vimdoc",
	},
	highlight = { enable = true, use_languagetree = true },
	indent = { enable = true },
})
--- @plugins: neowiki
require("neowiki").setup({
	wiki_dirs = {
		name = "vault",
		path = "/mnt/c/Users/Superuser/MainVault",
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
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { "filename", "diagnostics" },
		lualine_x = { "lsp_status", "hostname", "diff" },
		lualine_y = nil,
		lualine_z = nil,
	},
})
--- @plugins: conform
require("conform").setup({
	formatters = {
		odinfmt = {
			command = "/home/nixos/ols/odinfmt",
			args = { "-stdin" },
			stdin = true,
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt", "rust-analyzer" },
		python = { "ruff" },
		c = { "clang-format" },
		odin = { "odinfmt" },
	},
})
--- @plugins: clangd-lsp
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
--- @lspconfig Lua-ls
vim.lsp.config("emmylua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
vim.lsp.enable({ "emmylua_ls", "clangd", "ols" })
