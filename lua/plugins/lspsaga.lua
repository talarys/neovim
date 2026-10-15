return {
  {
    "lspsaga.nvim",
    -- declared via lze `keys` (registered at startup) rather than inside setup:
    -- Neovim's built-in LSP attach only claims `K` while it is still unmapped
    cmd = { "Lspsaga" },
    keys = {
      { "gh", "<cmd>Lspsaga finder<CR>", desc = "LSP: Finder" },
      { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "LSP: Goto definition" },
      { "gt", "<cmd>Lspsaga goto_type_definition<CR>", desc = "LSP: Goto type definition" },
      { "gr", "<cmd>Lspsaga rename<CR>", desc = "LSP: Rename symbol" },
      { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "LSP: Hover documentation" },
      { "<leader>ca", "<cmd>Lspsaga code_action<CR>", mode = { "n", "v" }, desc = "LSP: Code action" },
      { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "LSP: Line diagnostics" },
      { "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "LSP: Previous diagnostic" },
      { "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "LSP: Next diagnostic" },
      {
        "[E",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "LSP: Previous error",
      },
      {
        "]E",
        function()
          require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "LSP: Next error",
      },
      { "<leader>o", "<cmd>Lspsaga outline<CR>", desc = "LSP: Symbols outline" },
      { "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", desc = "LSP: Incoming calls" },
      { "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>", desc = "LSP: Outgoing calls" },
      { "<A-d>", "<cmd>Lspsaga term_toggle<CR>", mode = { "n", "t" }, desc = "Terminal: Toggle float" },
    },
    after = function()
      require("lspsaga").setup({})
    end,
  },
}
