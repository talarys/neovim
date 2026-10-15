return {
  {
    -- noice replaces the cmdline / messages UI; it has no keymaps of its own
    "noice.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("noice").setup({})
    end,
  },
}
