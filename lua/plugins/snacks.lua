return {
  {
    -- must be set up at startup: it registers autocmds (dashboard, netrw replacement)
    "snacks.nvim",
    after = function()
      require("snacks").setup({
        picker = { enabled = true },
        explorer = { enabled = true, replace_netrw = true },
        scratch = { enabled = true },
        rename = { enabled = true },
        notifier = { enabled = true },
        dashboard = {
          enabled = true,
          -- default sections minus "startup" (it requires lazy.nvim)
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
          },
          preset = {
            -- the on-screen dashboard keys, declared explicitly
            keys = {
              { icon = "", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
              { icon = "", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
              { icon = "", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
              { icon = "", key = "e", desc = "Explorer", action = ":lua Snacks.explorer()" },
              { icon = "", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = "", key = "q", desc = "Quit", action = ":qa" },
            },
          },
        },
      })

      local map = vim.keymap.set

      -- explorer
      map("n", "<leader>e", "<cmd>lua Snacks.explorer()<CR>", { desc = "Toggle explorer" })

      -- picker
      map("n", "<leader><leader>", "<cmd>lua Snacks.picker.smart()<CR>", { desc = "Smart find" })
      map("n", "<leader>ff", "<cmd>lua Snacks.picker.files()<CR>", { desc = "Find files" })
      map("n", "<leader>fr", "<cmd>lua Snacks.picker.recent()<CR>", { desc = "Recent files" })
      map("n", "<leader>fp", "<cmd>lua Snacks.picker.projects()<CR>", { desc = "Projects" })
      map("n", "<leader>fg", "<cmd>lua Snacks.picker.grep()<CR>", { desc = "Grep" })
      map("n", "<leader>sg", "<cmd>lua Snacks.picker.grep()<CR>", { desc = "Grep (search)" })
      map("n", "<leader>sw", "<cmd>lua Snacks.picker.grep_word()<CR>", { desc = "Grep word/selection" })
      map("n", "<leader>sb", "<cmd>lua Snacks.picker.lines()<CR>", { desc = "Buffer lines" })
      map("n", "<leader>sh", "<cmd>lua Snacks.picker.help()<CR>", { desc = "Help pages" })
      map("n", "<leader>sk", "<cmd>lua Snacks.picker.keymaps()<CR>", { desc = "Keymaps" })
      map("n", "<leader>ss", "<cmd>lua Snacks.picker.lsp_symbols()<CR>", { desc = "LSP symbols" })
      map("n", "<leader>sS", "<cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>", { desc = "Workspace symbols" })
      map("n", "<leader>sd", "<cmd>lua Snacks.picker.diagnostics()<CR>", { desc = "Diagnostics" })
      map("n", "<leader>su", "<cmd>lua Snacks.picker.undo()<CR>", { desc = "Undo history" })
      map("n", "<leader>s,", "<cmd>lua Snacks.picker.buffers()<CR>", { desc = "Buffers" })
      map("n", "<leader>s:", "<cmd>lua Snacks.picker.command_history()<CR>", { desc = "Command history" })
      map("n", "<leader>lD", "<cmd>lua Snacks.picker.lsp_definitions()<CR>", { desc = "Definitions list" })

      -- scratch / rename / notifier
      map("n", "<leader>..", "<cmd>lua Snacks.scratch()<CR>", { desc = "Toggle scratch buffer" })
      map("n", "<leader>.s", "<cmd>lua Snacks.scratch.select()<CR>", { desc = "Select scratch buffer" })
      map("n", "<leader>.r", "<cmd>lua Snacks.rename.rename_file()<CR>", { desc = "Rename file (LSP-aware)" })
      map("n", "<leader>un", "<cmd>lua Snacks.notifier.hide()<CR>", { desc = "Dismiss notifications" })
    end,
  },
}
