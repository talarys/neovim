return {
  {
    "bufferline.nvim",
    event = "DeferredUIEnter",
    after = function()
      local p = require("oxocarbon").oxocarbon
      require("bufferline").setup({
        highlights = {
          fill = { bg = p.base00 },
          background = { fg = p.base03, bg = p.base00 },
          buffer = { fg = p.base04, bg = p.base01 },
          buffer_selected = { fg = p.base05, bg = p.base02, bold = true },
          buffer_visible = { fg = p.base04, bg = p.base01 },
          indicator_selected = { fg = p.base09, bg = p.base02 },
          modified = { fg = p.base13, bg = p.base01 },
          modified_selected = { fg = p.base13, bg = p.base02 },
          modified_visible = { fg = p.base13, bg = p.base01 },
          separator = { fg = p.base00, bg = p.base00 },
          separator_selected = { fg = p.base00, bg = p.base00 },
          separator_visible = { fg = p.base00, bg = p.base00 },
          close_button = { fg = p.base03, bg = p.base01 },
          close_button_selected = { fg = p.base10, bg = p.base02 },
          close_button_visible = { fg = p.base03, bg = p.base01 },
        },
      })

      local map = vim.keymap.set
      map("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Buffer line pick" })
      map("n", "<leader>bP", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" })
      map("n", "<leader>bc", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
      map("n", "<leader>bH", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close left buffers" })
      map("n", "<leader>bL", "<cmd>BufferLineCloseRight<CR>", { desc = "Close right buffers" })
      map("n", "<leader>bl", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })
      map("n", "<leader>bh", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
    end,
  },
}
