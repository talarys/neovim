return {
  {
    -- set up at startup: it is the colorscheme
    "catppuccin-nvim",
    after = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        float = {
          transparent = true,
          solid = true,
        },
        integrations = {
          snacks = { enabled = true },
          noice = true,
          harpoon = true,
          lsp_saga = true,
          which_key = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
