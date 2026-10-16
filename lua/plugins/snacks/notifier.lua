return {
  opts = { enabled = true },

  keys = function()
    vim.keymap.set("n", "<leader>un", "<cmd>lua Snacks.notifier.hide()<CR>", { desc = "Dismiss notifications" })
  end,
}
