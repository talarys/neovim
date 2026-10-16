return {
  opts = { enabled = true },

  keys = function()
    local map = vim.keymap.set

    map("n", "<leader>..", "<cmd>lua Snacks.scratch()<CR>", { desc = "Toggle scratch buffer" })
    map("n", "<leader>.s", "<cmd>lua Snacks.scratch.select()<CR>", { desc = "Select scratch buffer" })
  end,
}
