local M = {}

local function active_flavor()
  local name = vim.g.colors_name or ""
  return name:match("^catppuccin%-(%a+)$") or "mocha"
end

local function palette()
  local ok, palettes = pcall(require, "catppuccin.palettes")
  if ok then
    local got, flavor_palette = pcall(palettes.get_palette, active_flavor())
    if got and type(flavor_palette) == "table" then
      return flavor_palette
    end

    local fallback_ok, mocha = pcall(palettes.get_palette, "mocha")
    if fallback_ok and type(mocha) == "table" then
      return mocha
    end
  end

  -- Minimal fallback so the statusline never errors when catppuccin is absent.
  return {
    text = "#cdd6f4",
    subtext1 = "#bac2de",
    overlay1 = "#7f849c",
    overlay0 = "#6c7086",
    surface0 = "#313244",
    red = "#f38ba8",
    peach = "#fab387",
    yellow = "#f9e2af",
    green = "#a6e3a1",
    teal = "#94e2d5",
    sky = "#89dceb",
    blue = "#89b4fa",
    mauve = "#cba6f7",
  }
end

function M.setup()
  local pal = palette()
  M.palette = pal

  local set = vim.api.nvim_set_hl
  set(0, "WinBar", { fg = pal.text, bg = "NONE" })
  set(0, "WinBarNC", { fg = pal.overlay1, bg = "NONE" })

  set(0, "TabLineFill", { bg = "NONE" })
  set(0, "TabLine", { fg = pal.overlay1, bg = "NONE" })
  set(0, "TabLineSel", { fg = pal.text, bg = "NONE", bold = true })

  set(0, "HeirlineWinbarCrumb", { fg = pal.subtext1, bg = "NONE" })
  set(0, "HeirlineWinbarCrumbCurrent", { fg = pal.text, bg = "NONE", bold = true })
  set(0, "HeirlineWinbarSep", { fg = pal.overlay0, bg = "NONE" })

  set(0, "HeirlineWinbarChip", { fg = pal.text, bg = pal.surface0 })
  set(0, "HeirlineWinbarChipDim", { fg = pal.overlay1, bg = pal.surface0 })
  set(0, "HeirlineWinbarChipInactive", { fg = pal.overlay1, bg = pal.surface0 })
  set(0, "HeirlineWinbarChipInactiveDim", { fg = pal.overlay0, bg = pal.surface0 })
end

function M.get()
  if not M.palette then
    M.setup()
  end
  return M.palette
end

return M
