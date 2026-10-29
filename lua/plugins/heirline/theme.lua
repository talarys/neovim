local M = {}

function M.setup()
  local palette = require("catppuccin.palettes").get_palette("mocha")
  M.palette = palette

  local set = vim.api.nvim_set_hl
  set(0, "WinBar", { fg = palette.text, bg = "NONE" })
  set(0, "WinBarNC", { fg = palette.overlay1, bg = "NONE" })

  set(0, "HeirlineWinbarCrumb", { fg = palette.subtext1, bg = "NONE" })
  set(0, "HeirlineWinbarCrumbCurrent", { fg = palette.text, bg = "NONE", bold = true })
  set(0, "HeirlineWinbarSep", { fg = palette.overlay0, bg = "NONE" })

  set(0, "HeirlineWinbarChip", { fg = palette.text, bg = palette.surface0 })
  set(0, "HeirlineWinbarChipDim", { fg = palette.overlay1, bg = palette.surface0 })
  set(0, "HeirlineWinbarChipInactive", { fg = palette.overlay1, bg = palette.surface0 })
  set(0, "HeirlineWinbarChipInactiveDim", { fg = palette.overlay0, bg = palette.surface0 })
end

function M.get()
  if not M.palette then
    M.setup()
  end
  return M.palette
end

return M
