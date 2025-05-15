require "nvchad.mappings"
local map = vim.keymap.set

-- FORMATING ON DEMAND
map("n", "<leader>fm", function()
  require("conform").format()
end, { desc = "Format with conform" })

-- CLOSE ALL BUFFERS
map("n", "<leader>ax", ":wa | %bd | e#<CR>", { desc = "Save & close all buffers except the current one." })

-- Typescript tools
map("n", "<leader>lo", ":TSToolsOrganizeImports<CR>", { desc = "TSTools Organize imports" })
map("n", "<leader>li", ":TSToolsAddMissingImports<CR>", { desc = "TSTools Add missing imports" })

-- Indent VISUAL blocks
map("v", ">", ">gv", { desc = "Indent selected VISUAL block" })
map("v", "<", "<gv", { desc = "Indent selected VISUAL block" })

-- LSP stuff before i install new neovim
map("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })

-- Other.nvim
map("n", "<leader>no", ":Other<CR>", { desc = "Other *" })
map("n", "<leader>nt", ":Other html<CR>", { desc = "Other template" })
map("n", "<leader>nc", ":Other component<CR>", { desc = "Other component" })

-- Telescope
map("n", "<leader>fc", function()
  require("telescope.builtin").lsp_workspace_symbols {
    default_text = ":class: ",
  }
end, { desc = "telescope find all classes with LSP" })
