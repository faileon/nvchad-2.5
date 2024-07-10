local configs = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

-- ANGULAR SHENANIGANS
local install_path = vim.fn.stdpath "data" .. "/mason/packages/angular-language-server/node_modules"
local ang = install_path .. "/@angular/language-server/node_modules"

local cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  install_path,
  "--ngProbeLocations",
  ang,
}

-- DEFINE ALL LSP SERVERS
local servers = {
  cssls = {
    filetypes = {
      "css",
      "scss",
      "less",
    },
  },
  html = {
    filetypes = {
      "angular",
      "svelte",
      "html",
    },
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
    filetypes = {
      "angular",
      "svelte",
      "html",
      "css",
      "scss",
      "sass",
      "less",
    },
    init_options = {
      userLanguages = {
        angular = "html",
      },
    },
  },
  angularls = {
    cmd = cmd,
    on_new_config = function(new_config, new_root_dir)
      new_config.cmd = cmd
    end,
    filetypes = {
      "angular",
      "typescript",
    },
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
          -- TODO: add other schemas, perhaps for project.json from nx?
        },
      },
    },
  },
  pylsp = {},
  dockerls = {},
  docker_compose_language_service = {},
}

-- INITIALIZE THEM WITH, ATTACHING NVCHAD MAGIC
for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  if opts.on_attach == nil then
    opts.on_attach = configs.on_attach
  end
  opts.capabilities = configs.capabilities
  opts.root_dir = lspconfig.util.root_pattern ".git"
  require("lspconfig")[name].setup(opts)
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
  root_dir = lspconfig.util.root_pattern ".git",
  settings = {
    tsserver_plugins = {
      "@monodon/typescript-nx-imports-plugin",
      "typescript-svelte-plugin",
    },
    -- tsserver_logs = "verbose",
  },

  filetypes = {
    "svelte",
    "typescript",
  },
}

-- higlight of todos in comments
require("todo-comments").setup {
  on_attach = configs.on_attach,
  capabilities = configs.capabilities,
}
