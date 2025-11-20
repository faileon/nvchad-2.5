local configs = require "nvchad.configs.lspconfig"
-- Do not require "lspconfig" main module, it triggers the warning in 0.11
-- We access the sub-modules directly:
local lsp_configs = require "lspconfig.configs"
local lsp_util = require "lspconfig.util"

-- must be set here, cant be set in myinit.lua cause nvchad
-- disable diagnostics, let tiny-inline-diagnostic.nvim handle it
vim.diagnostic.config { virtual_text = false }

-- ANGULAR SHENANIGANS
-- local install_path = vim.fn.stdpath "data" .. "/mason/packages/angular-language-server/node_modules"
-- local ang = install_path .. "/@angular/language-server/node_modules"
-- local cmd = {
--   "ngserver",
--   "--stdio",
--   "--tsProbeLocations",
--   install_path,
--   "--ngProbeLocations",
--   ang,
-- }

-- DEFINE ALL LSP SERVERS
local servers = {
  cssls = {
    filetypes = { "css", "scss", "less" },
  },
  html = {
    filetypes = { "angular", "html", "templ" },
  },
  eslint = {
    on_attach = function(client, bufnr)
      -- call the shared on attach
      configs.on_attach(client, bufnr)
      -- custom on attach -> run EslintFixAll on buffer save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end,
  },
  tailwindcss = {
    filetypes = { "angular", "svelte", "html", "css", "scss", "sass", "less", "templ", "astro" },
    settings = {
      tailwindCSS = {
        files = {
          exclude = { "**/.git/**", "**/node_modules/**", "**/.hg/**", "**/.svn/**", "**/volumes/**", "**/.nx/**" },
        },
      },
    },
    init_options = {
      userLanguages = { angular = "html", templ = "html" },
    },
  },
  angularls = {
    -- cmd = cmd,
    -- on_new_config = function(new_config, new_root_dir)
    --   new_config.cmd = cmd
    -- end,
    filetypes = { "angular", "typescript" },
  },
  svelte = {},
  jsonls = {
    settings = {
      json = {
        schemas = {
          {
            fileMatch = { "package.json" },
            url = "https://json.schemastore.org/package.json",
          },
        },
      },
    },
  },
  pylsp = {},
  dockerls = {},
  docker_compose_language_service = {},
  gopls = {
    cmd = vim.lsp.rpc.connect(vim.fn.getcwd() .. "/.dev/gopls.socket"),
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
  templ = {
    cmd = vim.lsp.rpc.connect(vim.fn.getcwd() .. "/.dev/templ.socket"),
  },
}

-- ============================================================
-- MIGRATION LOGIC FOR NVIM 0.11
-- ============================================================

for name, opts in pairs(servers) do
  -- 1. Attach NvChad helper functions
  -- opts.on_init = configs.on_init
  -- if opts.on_attach == nil then
  --   opts.on_attach = configs.on_attach
  -- end
  -- opts.capabilities = configs.capabilities

  -- 2. Handle root_dir using direct util require (avoids deprecation warning)
  -- if not opts.skip_root_dir and not opts.root_dir then
  --   opts.root_dir = lsp_util.root_pattern ".git"
  -- end

  -- 3. Merge user config with lspconfig's defaults
  -- We need the default 'cmd', 'filetypes', etc. from the plugin
  local config_def = lsp_configs[name]
  local defaults = config_def and config_def.default_config or {}

  -- Force merge: user opts override defaults
  local final_opts = vim.tbl_deep_extend("force", defaults, opts)

  -- 4. THE NEW WAY: Register directly with vim.lsp.config
  vim.lsp.config[name] = final_opts

  -- 5. Enable the server (this sets up the FileType autocmds)
  vim.lsp.enable(name)
end

-- TSSERVER via typescript-tools:
require("typescript-tools").setup {
  on_init = function(client, bufnr)
    vim.schedule(function()
      vim.cmd.NxInit()
    end)
  end,
  on_attach = configs.on_attach,
  capabilities = configs.capabilities,
  -- Use local lsp_util here too
  root_dir = lsp_util.root_pattern ".git",
  settings = {
    tsserver_plugins = {
      "@monodon/typescript-nx-imports-plugin",
      "typescript-svelte-plugin",
    },
  },
  filetypes = {
    "typescript",
  },
}

-- higlight of todos in comments
require("todo-comments").setup {
  on_attach = configs.on_attach,
  capabilities = configs.capabilities,
}
