return {
  {
    "gitsigns.nvim",
    after = function()
      require("gitsigns").setup({})

      local map = vim.keymap.set
      map("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
      map("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })
      map("n", "]H", "<cmd>Gitsigns last_hunk<CR>", { desc = "Last hunk" })
      map("n", "[H", "<cmd>Gitsigns first_hunk<CR>", { desc = "First hunk" })
      map({ "n", "v" }, "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage buffer/hunk" })
      map({ "n", "v" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset buffer/hunk" })
      map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
      map({ "n", "v" }, "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Preview hunk inline" })
      map("n", "<leader>gP", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk (popup)" })
      map("n", "<leader>gk", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame line (full)" })
      map("n", "<leader>gK", "<cmd>Gitsigns blame<CR>", { desc = "Blame file" })
      map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle line blame" })
      map("n", "<leader>gw", "<cmd>Gitsigns toggle_word_diff<CR>", { desc = "Toggle word diff" })
      map("n", "<leader>gB", "<cmd>lua require('gitsigns').browse()<CR>", { desc = "Git browse" })
      map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<CR>", { desc = "Select hunk (text object)" })
    end,
  },
}
