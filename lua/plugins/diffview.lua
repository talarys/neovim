return {
  {
    "diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>",          desc = "Diffview: open" },
      { "<leader>gV", "<cmd>DiffviewClose<CR>",         desc = "Diffview: close" },
      { "<leader>gc", "<cmd>DiffviewOpen --cached<CR>", desc = "Diffview: staged changes" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview: file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>",   desc = "Diffview: repository history" },
    },
    after = function()
      require("diffview").setup({
        keymaps = {
          view = {
            { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
          },
          file_panel = {
            { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
          },
          file_history_panel = {
            { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
          },
        },
      })
    end,
  },
}
