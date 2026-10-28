return {
  {
    "auto-session",
    keys = {
      { "<leader>q.", function() require("auto-session").restore_session() end, desc = "Restore last session", },
      { "<leader>ql", function() require("auto-session").search() end,          desc = "List sessions", },
      { "<leader>qd", function() require("auto-session").delete_session() end,  desc = "Delete session", },
      { "<leader>qs", function() require("auto-session").save_session() end,    desc = "Save session", },
      { "<leader>qD", "<cmd>AutoSession purgeOrphaned<CR>",                     desc = "Purge orphaned sessions" },
    },
    after = function()
      require("auto-session").setup({})
    end,
  },
}
