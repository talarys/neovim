return {
  opts = { enabled = true },

  keys = function()
    vim.keymap.set("n", "<leader>sn", "<cmd>lua Snacks.notifier.show_history()<CR>", { desc = "Notification history" })
    vim.keymap.set("n", "<leader>un", "<cmd>lua Snacks.notifier.hide()<CR>", { desc = "Dismiss notifications" })
  end,
}
