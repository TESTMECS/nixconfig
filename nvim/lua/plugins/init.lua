return {
  { "Olical/conjure", cmd = "Conjure", event = "VeryLazy" },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {},
  },
  { "mfussenegger/nvim-lint" },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    },
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },

  {
    "nvzone/typr",
    cmd = { "Typr", "TyprStats" },
    opts = {
      wpm_goal = 80,
      stats_filepath = vim.fn.stdpath "data" .. "/config",
    },
  },
  { "nvzone/showkeys", cmd = "ShowkeysToggle" },
  {
    "nvzone/timerly",
    opts = {
      on_start = function()
        vim.notify "Timerly started"
      end,
      on_finish = function()
        vim.cmd "silent !doas rtcwake -s 300 -m mem"
      end,
    },
    cmd = "TimerlyToggle",
  },
  { "nvzone/timerly", cmd = "TimerlyToggle" },
  {
    "karb94/neoscroll.nvim",
    keys = { "<C-d>", "<C-u>" },
    config = function()
      require("neoscroll").setup {}
    end,
  },
  {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = "FloatermToggle",
  },
  {
    "echaya/neowiki.nvim",
    opts = {
      wiki_dirs = {
        { name = "MainVault", path = "/mnt/c/Users/Superuser/Documents/GitHub/MainVault" },
      },
    },
    keys = {
      { "<leader>ww", "<cmd>lua require('neowiki').open_wiki()<cr>", desc = "Open Wiki" },
      { "<leader>wT", "<cmd>lua require('neowiki').open_wiki_in_new_tab()<cr>", desc = "Open Wiki in Tab" },
      {
        "<leader>wf",
        function()
          local dir = "/mnt/c/Users/Superuser/Documents/GitHub/MainVault"
          require("telescope.builtin").find_files { cwd = dir }
        end,
        desc = "Find Files",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "hrsh7th/nvim-cmp",

    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        config = function(_, opts)
          require("luasnip").config.set_config(opts)

          local luasnip = require "luasnip"

          luasnip.filetype_extend("javascriptreact", { "html" })
          luasnip.filetype_extend("typescriptreact", { "html" })
          luasnip.filetype_extend("svelte", { "html" })

          require "nvchad.configs.luasnip"
        end,
      },

      {
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
        config = function()
          local cmp = require "cmp"

          cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } },
          })

          cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
            matching = { disallow_symbol_nonprefix_matching = false },
          })
        end,
      },
    },

    opts = function(_, opts)
      opts.sources[1].trigger_characters = { "-" }
      table.insert(opts.sources, 1, { name = "supermaven" })
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "markdown-inline" },
  },
}
