return {
  {
    "smart-splits.nvim",
    keys = {
      -- resize
      { "<C-A-h>", "<cmd>lua require('smart-splits').resize_left()<CR>", desc = "Resize left" },
      { "<C-A-j>", "<cmd>lua require('smart-splits').resize_down()<CR>", desc = "Resize down" },
      { "<C-A-k>", "<cmd>lua require('smart-splits').resize_up()<CR>", desc = "Resize up" },
      { "<C-A-l>", "<cmd>lua require('smart-splits').resize_right()<CR>", desc = "Resize right" },
      -- move between splits
      { "<C-h>", "<cmd>lua require('smart-splits').move_cursor_left()<CR>", desc = "Move cursor left" },
      { "<C-j>", "<cmd>lua require('smart-splits').move_cursor_down()<CR>", desc = "Move cursor down" },
      { "<C-k>", "<cmd>lua require('smart-splits').move_cursor_up()<CR>", desc = "Move cursor up" },
      { "<C-l>", "<cmd>lua require('smart-splits').move_cursor_right()<CR>", desc = "Move cursor right" },
      { "<C-\\>", "<cmd>lua require('smart-splits').move_cursor_previous()<CR>", desc = "Move cursor previous" },
    },
    after = function()
      require("smart-splits").setup({})
    end,
  },
}
