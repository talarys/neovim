return {
  {
    "stay-centered.nvim",
    keys = {
      { "<leader>ut", function() require("stay-centered").toggle() end, desc = "Toggle trim" },
      { "<leader>uC", function() require("stay-centered").toggle() end, desc = "Toggle stay-centered" },
    },
    after = function()
      require("stay-centered").setup({})
    end,
  },
}
