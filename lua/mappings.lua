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
