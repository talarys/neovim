return {
  {
    "auto-session",
    -- loaded as soon as the UI exists so the plugin's VimEnter autocmds are in
    -- place before startup finishes
    event = "UIEnter",
    keys = {
      { "<leader>q.", function() require("auto-session").restore_session() end, desc = "Restore last session", },
      { "<leader>ql", function() require("auto-session").search() end,          desc = "List sessions", },
      { "<leader>qd", function() require("auto-session").delete_session() end,  desc = "Delete session", },
      { "<leader>qs", function() require("auto-session").save_session() end,    desc = "Save session", },
      { "<leader>qD", "<cmd>AutoSession purgeOrphaned<CR>",                     desc = "Purge orphaned sessions" },
    },
    after = function()
      local autosession = require("auto-session")
      autosession.setup({
        -- a project opened before is restored on start; the dashboard is what
        -- you get when there is no session for the current directory
        auto_save = true,
        auto_restore = true,
      })

      -- when this runs after VimEnter (startup without an attached UI) the
      -- VimEnter autocmd setup() just registered will not fire again
      if vim.v.vim_did_enter == 1 then
        autosession.start()
      end
    end,
  },
}
