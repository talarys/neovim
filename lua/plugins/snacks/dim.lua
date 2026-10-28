return {
  opts = {
    enabled = true,
  },

  keys = function()
    vim.keymap.set("n", "<leader>uD", function()
      if Snacks.dim.enabled then
        Snacks.dim.disable()
      else
        Snacks.dim.enable()
      end
    end, { desc = "Toggle dim" })
  end,
}
