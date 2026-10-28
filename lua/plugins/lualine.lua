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
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "encoding" },
          lualine_c = { "diagnostics" },
          lualine_x = { "diff", "lsp_status" },
          lualine_y = { "filetype" },
          lualine_z = { "location" }
        },
      })
    end,
  },
}
