return {
  {
    -- loaded once the UI is up: it has to be listening before a leader key is pressed
    "which-key.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("which-key").setup({})

      -- which-key's recommended keybind: show the keymaps of the current buffer
      vim.keymap.set("n", "<leader>k", function()
        require("which-key").show({ global = false })
      end, { desc = "Show keymaps" })
    end,
  },
}
