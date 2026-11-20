local MiniIcons = require("mini.icons")

local theme = require("plugins.heirline.theme")
local utils = require("plugins.heirline.utils")

local M = {}

local info_cache = {}
local breadcrumb_cache = {}

local CACHE_LIMIT = 256

local function cache_set(cache, key, value)
  if next(cache) ~= nil and vim.tbl_count(cache) >= CACHE_LIMIT then
    for k in pairs(cache) do
      cache[k] = nil
    end
  end
  cache[key] = value
end

---Drop all memoized render data. Call on ColorScheme, renames, and FileType.
function M.clear_cache()
  info_cache = {}
  breadcrumb_cache = {}
end

local function max_chip_width(win_width)
  if not win_width or win_width <= 0 then
    return 0
  end
  return math.max(0, math.min(win_width, math.max(12, math.floor(win_width * 0.6))))
end

---@param bufnr integer
---@param chip_width integer
---@return table
local function file_info(bufnr, chip_width)
  local path = utils.relative_path(bufnr)
  if path == "" then
    path = "[No Name]"
  end

  local icon, icon_hl = MiniIcons.get("file", path)
  local icon_width = utils.width(icon)
  local path_max = chip_width - icon_width - 3
  path = utils.truncate_path(path, math.max(1, path_max))

  local dir, base, ext = utils.split_path(path)
  return {
    icon = icon,
    icon_fg = utils.icon_fg(icon_hl) or theme.get().text,
    dir = dir,
    base = base,
    ext = ext,
    width = icon_width + 1 + utils.width(path) + 2,
  }
end

---@param bufnr integer
---@param win_width integer
---@return table
local function cached_file_info(bufnr, win_width)
  local chip_width = max_chip_width(win_width)
  local key = bufnr .. ":" .. chip_width

  local info = info_cache[key]
  if not info then
    info = file_info(bufnr, chip_width)
    cache_set(info_cache, key, info)
  end
  return info
end

---Width of the file chip for a given buffer and window, without rebuilding it.
---@param bufnr integer
---@param win_width integer
---@return integer
function M.file_chip_width(bufnr, win_width)
  return cached_file_info(bufnr, win_width).width
end

---@param bufnr integer
---@param win_width integer
---@param active boolean
---@return table[]
function M.file_chip_children(bufnr, win_width, active)
  local info = cached_file_info(bufnr, win_width)
  local palette = theme.get()
  local chip = { bg = palette.surface0 }
  local base_hl = active and "HeirlineWinbarChip" or "HeirlineWinbarChipInactive"
  local dim_hl = active and "HeirlineWinbarChipDim" or "HeirlineWinbarChipInactiveDim"

  return {
    { provider = " ",                             hl = chip },
    { provider = utils.escape(info.icon) .. " ",  hl = { fg = info.icon_fg, bg = palette.surface0 } },
    { provider = utils.escape(info.dir),          hl = dim_hl },
    { provider = utils.escape(info.base),         hl = base_hl },
    { provider = utils.escape(info.ext),          hl = dim_hl },
    { provider = " ",                             hl = chip },
  }
end

local navic_module

local function navic()
  if navic_module == nil then
    local ok, mod = pcall(require, "nvim-navic")
    navic_module = ok and mod or false
  end
  return navic_module or nil
end

local function data_signature(data)
  local parts = {}
  for i, item in ipairs(data) do
    parts[i] = (item.type or "") .. "\0" .. (item.name or "")
  end
  return table.concat(parts, "\1")
end

---@param bufnr integer
---@param max_width integer
---@return table[]
function M.breadcrumb_children(bufnr, max_width)
  if max_width <= 0 then
    return {}
  end

  local nv = navic()
  if not nv or not vim.api.nvim_buf_is_valid(bufnr) or not nv.is_available(bufnr) then
    return {}
  end

  local ok, data = pcall(nv.get_data, bufnr)
  if not ok or type(data) ~= "table" or #data == 0 then
    return {}
  end

  local key = table.concat({ bufnr, max_width, data_signature(data) }, ":")
  local cached = breadcrumb_cache[key]
  if cached then
    return cached
  end

  local items = {}
  for i, item in ipairs(data) do
    local icon, icon_hl = MiniIcons.get("lsp", item.type or "Unknown")
    items[#items + 1] = {
      name = (tostring(item.name or "?"):gsub("\n", " ")),
      icon = icon,
      icon_fg = utils.icon_fg(icon_hl) or theme.get().mauve,
      current = i == #data,
    }
  end

  local fitted, truncated = utils.fit_breadcrumbs(items, max_width)
  if #fitted == 0 then
    cache_set(breadcrumb_cache, key, {})
    return {}
  end

  local children = {}
  if truncated then
    children[#children + 1] = { provider = "…", hl = "HeirlineWinbarSep" }
    children[#children + 1] = { provider = " › ", hl = "HeirlineWinbarSep" }
  end

  for i, item in ipairs(fitted) do
    children[#children + 1] = {
      { provider = utils.escape(item.icon) .. " ", hl = { fg = item.icon_fg } },
      {
        provider = utils.escape(item.name),
        hl = item.current and "HeirlineWinbarCrumbCurrent" or "HeirlineWinbarCrumb",
      },
    }
    if i < #fitted then
      children[#children + 1] = { provider = " › ", hl = "HeirlineWinbarSep" }
    end
  end

  cache_set(breadcrumb_cache, key, children)
  return children
end

return M
