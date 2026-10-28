return {
  opts = {
    enabled = true,
    sources = {
      -- the explorer is a picker; its layout defaults to the left-hand
      -- "sidebar" preset, and the position is set through the picker source
      explorer = {
        layout = {
          auto_hide = { "input" },
          layout = { position = "right" },
        },
      },
    },
  },

  keys = function()
    local map = vim.keymap.set

    map("n", "<leader><leader>", "<cmd>lua Snacks.picker.smart()<CR>", { desc = "Smart find" })
    -- files and projects
    map("n", "<leader>sf", "<cmd>lua Snacks.picker.files()<CR>", { desc = "Files" })
    map("n", "<leader>sr", "<cmd>lua Snacks.picker.recent()<CR>", { desc = "Recent files" })
    map("n", "<leader>sp", "<cmd>lua Snacks.picker.projects()<CR>", { desc = "Projects" })
    map("n", "<leader>s,", "<cmd>lua Snacks.picker.buffers()<CR>", { desc = "Buffers" })
    -- text and symbols
    map("n", "<leader>sg", "<cmd>lua Snacks.picker.grep()<CR>", { desc = "Grep" })
    map("n", "<leader>sw", "<cmd>lua Snacks.picker.grep_word()<CR>", { desc = "Grep word/selection" })
    map("n", "<leader>sb", "<cmd>lua Snacks.picker.lines()<CR>", { desc = "Buffer lines" })
    map("n", "<leader>ss", "<cmd>lua Snacks.picker.lsp_symbols()<CR>", { desc = "LSP symbols" })
    map("n", "<leader>sS", "<cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>", { desc = "Workspace symbols" })
    -- lists and history
    map("n", "<leader>sd", "<cmd>lua Snacks.picker.diagnostics()<CR>", { desc = "Diagnostics" })
    map("n", "<leader>sq", "<cmd>lua Snacks.picker.qflist()<CR>", { desc = "Quickfix list" })
    map("n", "<leader>sl", "<cmd>lua Snacks.picker.loclist()<CR>", { desc = "Location list" })
    map("n", "<leader>su", "<cmd>lua Snacks.picker.undo()<CR>", { desc = "Undo history" })
    map("n", "<leader>s:", "<cmd>lua Snacks.picker.command_history()<CR>", { desc = "Command history" })
    -- help
    map("n", "<leader>sh", "<cmd>lua Snacks.picker.help()<CR>", { desc = "Help pages" })
    map("n", "<leader>sk", "<cmd>lua Snacks.picker.keymaps()<CR>", { desc = "Keymaps" })
    -- LSP
    map("n", "<leader>lD", "<cmd>lua Snacks.picker.lsp_definitions()<CR>", { desc = "Definitions list" })
  end,
}
