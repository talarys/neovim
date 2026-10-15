return {
  {
    "trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "gr", "<cmd>Trouble lsp_references<CR>", desc = "References (trouble)" },
    },
    after = function()
      require("trouble").setup({})
    end,
  },
}
