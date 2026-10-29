return {
  {
    "lspsaga.nvim",
    -- declared via lze `keys` (registered at startup) rather than inside setup:
    -- Neovim's built-in LSP attach only claims `K` while it is still unmapped
    cmd = { "Lspsaga" },
    keys = {
      { "gd",         "<cmd>Lspsaga goto_definition<CR>",            desc = "Goto definition" },
      { "gpd",        "<cmd>Lspsaga peek_definition<CR>",            desc = "Peek definition" },
      { "gpt",        "<cmd>Lspsaga peek_type_definition<CR>",       desc = "Peek type definition" },
      { "K",          "<cmd>Lspsaga hover_doc<CR>",                  desc = "Hover doc" },
      { "<leader>lF", "<cmd>Lspsaga finder<CR>",                     desc = "Finder (definitions/references)" },
      { "<leader>lt", "<cmd>Lspsaga goto_type_definition<CR>",       desc = "Goto type definition" },
      { "<leader>la", "<cmd>Lspsaga code_action<CR>",                desc = "Code action" },
      { "<leader>lr", "<cmd>Lspsaga rename ++project<CR>",           desc = "Rename (project)" },
      { "<leader>lo", "<cmd>Lspsaga outline<CR>",                    desc = "Outline" },
      { "<leader>lw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
      { "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<CR>",      desc = "Line diagnostics" },
      { "[e",         "<cmd>Lspsaga diagnostic_jump_prev<CR>",       desc = "Prev diagnostic" },
      { "]e",         "<cmd>Lspsaga diagnostic_jump_next<CR>",       desc = "Next diagnostic" },
    },
    after = function()
      require("lspsaga").setup({
        symbol_in_winbar = { enable = false },
      })
    end,
  },
}
