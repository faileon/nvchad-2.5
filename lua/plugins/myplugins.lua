local overrides = require "configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require "configs.ts-context"
    end,
  },

  {
    "stevearc/conform.nvim",
    --  for users those who want auto-save conform + lazyloading!
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },

  -- better version of typescript-lsp
  {
    "pmizio/typescript-tools.nvim",
    -- dev = true,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },

  -- some angular stuff
  {
    "joeveiga/ng.nvim",
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- nvim-cmp source for packages and their versions in package.json files
  {
    "David-Kunz/cmp-npm",
    ft = "json",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("cmp-npm").setup {
        ignore = {},
        only_semantic_versions = true,
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp_config = require "nvchad.configs.cmp"
      table.insert(cmp_config.sources, 1, { name = "npm", keyword_length = 3 })
      return cmp_config
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
      -- You may not need this if you don't lazy load
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  -- {
  --   "MeanderingProgrammer/markdown.nvim",
  --   ft = "markdown",
  --   name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     require "configs.markdown"
  --   end,
  -- },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    config = function()
      require "configs.tiny-inline-diagnostic"
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      background_colour = "#1F1F28",
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require "configs.noice"
    end,
  },
}

return plugins
