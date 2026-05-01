--- @section GLOBALS
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
--- @end GLOBALS
--- @section OPTIONS
vim.opt.modeline = false
vim.o.colorcolumn = "100"
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
--- @end OPTIONS
--- @section COMMANDS
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
usercmd("CONFIG", function()
	print("⭒₊ ⊹🌕₊ ⊹⭒")
	vim.cmd("e ~/.config/nvim/init.lua")
end, { desc = "Edit config file" })

usercmd("Bashrc", function()
	print("⋆˚☆˖°⋆｡° ✮˖ ࣪ ⊹⋆.˚")
	vim.cmd("e ~/.bashrc")
end, { desc = "Edit bashrc file" })

usercmd("NixConfig", function()
	print("⋆˚☆˖°⋆｡° ✮˖ ࣪ ⊹⋆.˚")
	vim.cmd("e ~/nixconfig")
end, { desc = "Edit nix config file" })

usercmd("Just", function(opts)
	print("⋆˚☆˖°⋆｡° ✮˖ ࣪ ⊹⋆.˚")
	local args = opts.args
	vim.cmd("Compile just " .. args)
end, {
	nargs = "*",
	desc = "Wrapper to run a `just` via `Compile` ",
	complete = function(ArgLead, CmdLine, CursorPos)
		local handle = io.popen("just --summary 2> /dev/null")
		if handle then
			local result = handle:read("*a")
			handle:close()
			local recipes = {}
			for recipe in string.gmatch(result, "%S+") do
				table.insert(recipes, recipe)
			end
			return recipes
		end
		return {}
	end,
})
--- @end COMMANDS
--- @section KEYMAPS
local map = vim.keymap.set

-- windows
map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })
map("n", "<leader>tt", "<cmd>tabn<CR>", { desc = "switch tab" })
-- vim
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })
map("n", "<C-s>", "<cmd>write<CR>", { desc = "save" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "clear highlights" })
map("n", "<leader>rr", "<cmd>restart<CR>", { desc = "restart" })
map("n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to definition" })
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })
-- fzf-lua
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find Files" })
map("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", { desc = "Find Keymaps" })
map("n", "<leader>fw", "<cmd>FzfLua live_grep<CR>", { desc = "Find Word" })
map("n", "<leader>fc", "<cmd>FzfLua commands<CR>", { desc = "Find Commands" })
-- nvim-tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "File Tree" })

--- @section VIM_PACK

---@class PluginTable Type schema for the plugin table.
---@field src string
---@field setup? fun()
---@field version? string
---@field name? string
---@field gist? string

---@type PluginTable[]
local PLUGINS = {
	{
		src = "gh:nvim-lualine/lualine.nvim",
		setup = function()
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
		end,
	},
	--- @TODO work on removing this.
	{
		src = "gh:nvim-treesitter/nvim-treesitter",
		setup = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"lua",
					"javascript",
					"markdown",
					"json",
					"janet-simple",
					"nix",
					"bash",
					"html",
					"vim",
					"elixir",
					"vimdoc",
					"go",
					"gowork",
					"gomod",
					"gosum",
				},
				highlight = { enable = true, use_languagetree = true },
				indent = { enable = true },
			})
		end,
		version = "master", -- This deprecated now :( so we use frozen version + look for others if these don't work.
	},
	{
		src = "gh:nvim-lua/plenary.nvim",
		setup = function() end,
		version = "v0.1.4",
	},
	{
		src = "gh:ibhagwan/fzf-lua",
		setup = function()
			require("fzf-lua").setup({ "fzf-native" })
		end,
	},
	{
		gist = "Provides configs for various LSPs",
		src = "gh:neovim/nvim-lspconfig",
	},
	{
		gist = "Easy file naviagtion.",
		src = "gh:nvim-tree/nvim-tree.lua",
		setup = function()
			-- Creates a floating window centered in the screen.
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
		end,
	},
	{
		gist = "Auto formatting on save",
		src = "gh:stevearc/conform.nvim",
		setup = function()
			require("conform").setup({
				formatters_by_ft = {
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					lua = { "stylua" },
					rust = { "rustfmt", "rust-analyzer" },
					c = { "clang-format" },
					cpp = { "clang-format" }, -- for header files.
					go = { "gofmt" },
				},
			})
		end,
	},
	{
		gist = "nice diagnostic messages",
		src = "gh:rachartier/tiny-inline-diagnostic.nvim",
		setup = function()
			require("tiny-inline-diagnostic").setup({})
		end,
	},
	{
		gist = "For quick debug tests and one shot commands.",
		src = "gh:ej-shafran/compile-mode.nvim",
		setup = function()
			-- Must set.
			vim.g.compile_mode = {}
		end,
	},
	{
		gist = "Better marks jumping a visuals",
		src = "gh:chentoast/marks.nvim",
		setup = function()
			require("marks").setup({})
		end,
	},
	{
		gist = "Completion",
		src = "gh:echasnovski/mini.completion",
		setup = function()
			require("mini.completion").setup({})
		end,
	},
	{
		gist = "Snippets",
		src = "gh:echasnovski/mini.snippets",
		setup = function()
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
		end,
	},
	{
		gist = "Easy autopairs like {}",
		src = "gh:windwp/nvim-autopairs",
		setup = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		gist = "Icons",
		src = "gh:echasnovski/mini.icons",
		setup = function()
			-- Just need assets no setup.
		end,
	},
	{
		gist = "Main editor theme",
		src = "gh:miikanissi/modus-themes.nvim",
		setup = function()
			require("modus-themes").setup({
				variant = "tritanopia",
				styles = {
					Conditional = { bold = true },
					Repeat = { bold = true }, -- `for`, `do`, `while`, etc.
					Label = { bold = true }, -- `case`, `default`, etc.
					Boolean = { bold = true },
				},
				on_highlights = function(hl, colors)
					hl.String = { fg = colors.green }
				end,
			})
		end,
	},
}
-- Load the plugins.
-- [NOTE] only works for github plugins bc that's all i have.
vim.pack.add(vim.tbl_map(function(p)
	return {
		src = (p.src:gsub("^gh:", "https://github.com/")),
		version = p.version,
		name = p.name,
	}
end, PLUGINS))
-- Call Setup on PLUGINS.
for _, p in ipairs(PLUGINS) do
	_ = p.setup and p.setup()
end
--- @end VIM_PACK

--- @colorscheme
vim.cmd([[colorscheme modus_vivendi]])

--- @section LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_cap = require("mini.completion").get_lsp_capabilities()
vim.tbl_deep_extend("force", capabilities, cmp_cap)

--- @LSP_custom: lua_ls
vim.lsp.config("lua_ls", {
	cmd = { "/nix/store/yv5gfrvadvfj68idcqkzixqnyl40phiy-lua-language-server-3.15.0/bin/lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		{
			".luarc.json",
			".luarc.jsonc",
		},
		".git",
	},
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			runtime = {
				version = "Lua5.4",
			},
		},
	},
})

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

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			semanticTokens = true,
		},
	},
})

vim.lsp.enable({
	"lua_ls",
	"clangd",
	"zls",
	"gopls",
	"ts_ls",
})
--- @end LSP
