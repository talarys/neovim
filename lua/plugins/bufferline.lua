return {
  {
    "bufferline.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("bufferline").setup({})

      local map = vim.keymap.set
      map("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Buffer line pick" })
      map("n", "<leader>bP", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" })
      map("n", "<leader>bc", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
      map("n", "<leader>bd", "<cmd>BufferLineSortByDirectory<CR>", { desc = "Sort by directory" })
      map("n", "<leader>be", "<cmd>BufferLineSortByExtension<CR>", { desc = "Sort by extension" })
      map("n", "<leader>bH", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close left buffers" })
      map("n", "<leader>bL", "<cmd>BufferLineCloseRight<CR>", { desc = "Close right buffers" })
      map("n", "<leader>bl", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer left" })
      map("n", "<leader>bh", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer right" })
    end,
  },
}
