return {
  {
    "lspsaga.nvim",
    event = "LspAttach",
    after = function()
      require("lspsaga").setup({})

      local map = vim.keymap.set
      map("n", "gh", "<cmd>Lspsaga finder<CR>", { desc = "LSP: Finder" })
      map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "LSP: Goto definition" })
      map("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", { desc = "LSP: Goto type definition" })
      map("n", "gr", "<cmd>Lspsaga rename<CR>", { desc = "LSP: Rename symbol" })
      map("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "LSP: Hover documentation" })
      map({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "LSP: Code action" })
      map("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "LSP: Line diagnostics" })
      map("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "LSP: Previous diagnostic" })
      map("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "LSP: Next diagnostic" })
      map("n", "[E", function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "LSP: Previous error" })
      map("n", "]E", function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "LSP: Next error" })
      map("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "LSP: Symbols outline" })
      map("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", { desc = "LSP: Incoming calls" })
      map("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>", { desc = "LSP: Outgoing calls" })
      map({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>", { desc = "Terminal: Toggle float" })
    end,
  },
}
