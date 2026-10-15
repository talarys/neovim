return {
  {
    -- loaded once the UI is up, so the finder stays off the startup path
    "fzf-lua",
    event = "DeferredUIEnter",
    after = function()
      require("fzf-lua").setup({})
      local map = vim.keymap.set
      map("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "Find files" })
      map("n", "<leader>fg", function() require("fzf-lua").live_grep() end, { desc = "Grep" })
      map("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "Buffers" })
    end,
  },
}
