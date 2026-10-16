return {
  opts = { enabled = true },

  keys = function()
    vim.keymap.set("n", "<leader>.r", "<cmd>lua Snacks.rename.rename_file()<CR>", { desc = "Rename file (LSP-aware)" })
  end,
}
