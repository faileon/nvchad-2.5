-- Custom formatter function to use a specified LSP for formatting
local function lsp_formatting(bufnr, name)
  vim.lsp.buf.format {
    bufnr = bufnr,
    timeout_ms = 500,
    name = name,
  }
  return {}
end

local options = {
  lsp_fallback = true,

  formatters_by_ft = {
    lua = { "stylua" },

    javascript = { "prettier" },
    typescript = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    astro = { "prettier" },
    angular = { "prettier" },
    svelte = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },

    sh = { "shfmt" },
    go = lsp_formatting,
    templ = function(bufnr)
      return lsp_formatting(bufnr, "templ")
    end,
  },

  -- adding same formatter for multiple filetypes can look too much work for some
  -- instead of the above code you could just use a loop! the config is just a table after all!

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
  format_on_save = function(bufnr)
    -- on save we also want to force format with templ lsp and not any other (html)
    if vim.bo[bufnr].filetype == "templ" then
      return lsp_formatting(bufnr, "templ")
    end
    return {
      timeout_ms = 500,
      lsp_fallback = true,
    }
  end,
}

require("conform").setup(options)
