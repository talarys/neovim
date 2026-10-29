local M = {}

function M.setup()
  local oxo = require("oxocarbon").oxocarbon
  local palette = {
    bg = oxo.base00,
    surface = oxo.base01,
    chip = oxo.base02,
    muted = oxo.base03,
    text = oxo.base04,
    bright = oxo.base05,
    accent = oxo.base09,
    red = oxo.base10,
    green = oxo.base13,
  }
  M.palette = palette

  local set = vim.api.nvim_set_hl
  set(0, "WinBar", { fg = palette.text, bg = "NONE" })
  set(0, "WinBarNC", { fg = palette.muted, bg = "NONE" })

  set(0, "HeirlineWinbarCrumb", { fg = palette.text, bg = "NONE" })
  set(0, "HeirlineWinbarCrumbCurrent", { fg = palette.bright, bg = "NONE", bold = true })
  set(0, "HeirlineWinbarSep", { fg = palette.muted, bg = "NONE" })

  set(0, "HeirlineWinbarChip", { fg = palette.bright, bg = palette.chip })
  set(0, "HeirlineWinbarChipDim", { fg = palette.muted, bg = palette.chip })
  set(0, "HeirlineWinbarChipInactive", { fg = palette.text, bg = palette.chip })
  set(0, "HeirlineWinbarChipInactiveDim", { fg = palette.muted, bg = palette.chip })
end

function M.get()
  if not M.palette then
    M.setup()
  end
  return M.palette
end

return M
