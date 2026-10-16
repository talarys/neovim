return {
  {
    "flash.nvim",
    keys = {
      {
        "<leader>?",
        function()
          require("flash").jump({ search = { mode = "search", multi_window = true, forward = true, wrap = true }, })
        end,
        desc = "Flash search",
      },
    },
    after = function()
      require("flash").setup({})
    end,
  },
}
