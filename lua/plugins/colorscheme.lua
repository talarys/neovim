return {
  {
    -- set up at startup: it is the colorscheme
    "oxocarbon.nvim",
    after = function()
      vim.cmd.colorscheme("oxocarbon")

      local palette = require("oxocarbon").oxocarbon
      local function clear_bg(name)
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        hl.bg = nil
        vim.api.nvim_set_hl(0, name, hl)
      end

      for _, group in ipairs({ "Normal", "NormalFloat", "NormalNC", "LineNr", "SignColumn" }) do
        clear_bg(group)
      end

      vim.api.nvim_set_hl(0, "WinSeparator", { fg = palette.base02, bg = "NONE" })
      vim.api.nvim_set_hl(0, "VertSplit", { fg = palette.base02, bg = "NONE" })
    end,
  },
}
