return {
  opts = { enabled = true },

  keys = function()
    local map = vim.keymap.set

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
  end,
}
