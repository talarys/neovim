return {
  {
    -- loaded once the UI is up; lualine has no keymaps of its own to declare
    "lualine.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
        },
      })
    end,
  },
}
