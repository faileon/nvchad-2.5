local overrides = require "configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "nvchad.configs.lspconfig"
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
    -- commit = "e0887c1",
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
  -- {
  --   "rcarriga/nvim-notify",
  --   event = "VeryLazy",
  --   opts = {
  --     background_colour = "#1F1F28",
  --   },
  -- },
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     -- add any options here
  --   },
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     "rcarriga/nvim-notify",
  --   },
  --   config = function()
  --     require "configs.noice"
  --   end,
  -- },
  -- {
  --   "benlubas/molten-nvim",
  --   event = "VeryLazy",
  --   version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
  --   dependencies = { "3rd/image.nvim" },
  --   build = ":UpdateRemotePlugins",
  --   init = function()
  --     -- these are examples, not defaults. Please see the readme
  --     vim.g.molten_image_provider = "image.nvim"
  --     vim.g.molten_output_win_max_height = 20
  --   end,
  -- },
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    config = function()
      require "configs.image"
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- provider = "openai",
      provider = "gemini",
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
        timeout = 90000, -- Timeout in milliseconds, increase this for reasoning models
        temperature = 0,
        max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
        --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      },
      gemini = {
        model = "gemini-2.5-pro-preview-05-06",
      },
      windows = {
        width = 40,
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      -- {
      --   -- Make sure to set this up properly if you have lazy=true
      --   "MeanderingProgrammer/render-markdown.nvim",
      --   opts = {
      --     file_types = { "markdown", "Avante" },
      --   },
      --   ft = { "markdown", "Avante" },
      -- },
    },
  },
}

return plugins
