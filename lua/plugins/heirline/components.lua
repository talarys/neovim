local MiniIcons = require("mini.icons")

local theme = require("plugins.heirline.theme")
local utils = require("plugins.heirline.utils")

local M = {}

local function max_chip_width(win_width)
  return math.min(win_width, math.max(12, math.floor(win_width * 0.6)))
end

local function file_info(bufnr, chip_width, active)
  local path = utils.relative_path(bufnr)
  if path == "" then
    path = "[No Name]"
  end

  local icon, icon_hl = MiniIcons.get("file", path)
  local path_max = chip_width - utils.width(icon) - 3
  path = utils.truncate_path(path, math.max(1, path_max))

  local dir, base, ext = utils.split_path(path)
  return {
    icon = icon,
    icon_fg = utils.icon_fg(icon_hl) or theme.get().text,
    dir = dir,
    base = base,
    ext = ext,
    active = active,
    width = utils.width(icon) + 1 + utils.width(path) + 2,
  }
end

function M.file_chip_width(bufnr, win_width)
  return file_info(bufnr, max_chip_width(win_width), true).width
end

function M.file_chip_children(bufnr, win_width, active)
  local info = file_info(bufnr, max_chip_width(win_width), active)
  local palette = theme.get()
  local chip = { bg = palette.surface0 }
  local base_hl = active and "HeirlineWinbarChip" or "HeirlineWinbarChipInactive"
  local dim_hl = active and "HeirlineWinbarChipDim" or "HeirlineWinbarChipInactiveDim"

  return {
    { provider = " ",                            hl = chip },
    { provider = utils.escape(info.icon) .. " ", hl = { fg = info.icon_fg, bg = palette.surface0 } },
    { provider = utils.escape(info.dir),         hl = dim_hl },
    { provider = utils.escape(info.base),        hl = base_hl },
    { provider = utils.escape(info.ext),         hl = dim_hl },
    { provider = " ",                            hl = chip },
  }
end

function M.breadcrumb_children(bufnr, max_width)
  local navic = require("nvim-navic")
  if not navic.is_available(bufnr) then
    return {}
  end

  local data = navic.get_data(bufnr)
  if not data or #data == 0 then
    return {}
  end

  local items = {}
  for i, item in ipairs(data) do
    local icon, icon_hl = MiniIcons.get("lsp", item.type)
    items[#items + 1] = {
      name = (item.name:gsub("\n", " ")),
      icon = icon,
      icon_fg = utils.icon_fg(icon_hl) or theme.get().mauve,
      current = i == #data,
    }
  end

  local fitted, truncated = utils.fit_breadcrumbs(items, max_width)
  local children = {}

  if truncated then
    children[#children + 1] = { provider = "…", hl = "HeirlineWinbarSep" }
    children[#children + 1] = { provider = " › ", hl = "HeirlineWinbarSep" }
  end

  for i, item in ipairs(fitted) do
    children[#children + 1] = {
      { provider = item.icon .. " ", hl = { fg = item.icon_fg } },
      {
        provider = utils.escape(item.name),
        hl = item.current and "HeirlineWinbarCrumbCurrent" or "HeirlineWinbarCrumb",
      },
    }
    if i < #fitted then
      children[#children + 1] = { provider = " › ", hl = "HeirlineWinbarSep" }
    end
  end

  return children
end

return M
