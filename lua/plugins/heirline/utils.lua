local M = {}

local root_cache = {}
local fg_cache = {}

local special_filetypes = {
  "^snacks",
  "^lazy",
  "^lazygit",
  "^harpoon",
  "^lspsaga",
  "^dashboard$",
  "^alpha$",
  "^neo%-tree$",
}

local root_markers = {
  ".git",
  "flake.nix",
  "package.json",
  "Cargo.toml",
  "pyproject.toml",
  "cabal.project",
  "hie.yaml",
}

function M.width(text)
  return vim.fn.strdisplaywidth(text)
end

function M.escape(text)
  return (text:gsub("%%", "%%%%"):gsub("\n", " "))
end

function M.is_special(bufnr)
  bufnr = bufnr or 0
  if vim.bo[bufnr].buftype ~= "" then
    return true
  end

  local ft = vim.bo[bufnr].filetype
  for _, pattern in ipairs(special_filetypes) do
    if ft:find(pattern) then
      return true
    end
  end
  return false
end

function M.buf_for_win(winnr)
  local winid = winnr and vim.fn.win_getid(winnr) or 0
  if winid == 0 then
    winid = vim.api.nvim_get_current_win()
  end
  return vim.api.nvim_win_get_buf(winid)
end

function M.win_width(winnr)
  local winid = winnr and vim.fn.win_getid(winnr) or 0
  if winid == 0 then
    return vim.o.columns
  end
  return vim.api.nvim_win_get_width(winid)
end

function M.project_root(bufnr)
  if root_cache[bufnr] then
    return root_cache[bufnr]
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  local root = name ~= "" and vim.fs.root(name, root_markers) or nil
  root = root or vim.fn.getcwd()
  root_cache[bufnr] = root
  return root
end

function M.relative_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return ""
  end

  name = vim.fn.fnamemodify(name, ":p")
  local rel = vim.fs.relpath(M.project_root(bufnr), name)
  if not rel then
    rel = vim.fn.fnamemodify(name, ":~:.")
  end
  return rel:gsub("\\", "/")
end

function M.split_path(path)
  local dir = vim.fn.fnamemodify(path, ":h")
  dir = dir == "." and "" or dir .. "/"

  local tail = vim.fn.fnamemodify(path, ":t")
  local ext = vim.fn.fnamemodify(tail, ":e")
  local base = vim.fn.fnamemodify(tail, ":r")
  return dir, base, ext == "" and "" or "." .. ext
end

function M.truncate_right(text, max_width)
  if max_width <= 0 then
    return ""
  end
  if M.width(text) <= max_width then
    return text
  end
  if max_width <= 1 then
    return "…"
  end

  local out = {}
  local used = 0
  for _, char in ipairs(vim.fn.split(text, "\\zs")) do
    local char_width = M.width(char)
    if used + char_width + 1 > max_width then
      break
    end
    table.insert(out, char)
    used = used + char_width
  end
  return table.concat(out) .. "…"
end

function M.truncate_path(path, max_width)
  if max_width <= 0 then
    return ""
  end
  if M.width(path) <= max_width then
    return path
  end

  local parts = vim.split(path, "/", { plain = true })
  local file = table.remove(parts) or path
  if #parts == 0 then
    return M.truncate_right(file, max_width)
  end

  local kept = {}
  local best
  for i = #parts, 1, -1 do
    table.insert(kept, 1, parts[i])
    local candidate = "…/" .. table.concat(kept, "/") .. "/" .. file
    if M.width(candidate) <= max_width then
      best = candidate
    else
      break
    end
  end

  if best then
    return best
  end
  if M.width("…/" .. file) <= max_width then
    return "…/" .. file
  end
  return M.truncate_right(file, max_width)
end

function M.fit_breadcrumbs(items, max_width)
  if max_width <= 0 or #items == 0 then
    return {}, false
  end

  local sep_width = M.width(" › ")
  local ellipsis_width = M.width("…")
  local function item_width(item)
    return M.width(item.icon) + 1 + M.width(item.name)
  end
  local function total_width(list)
    local total = 0
    for i, item in ipairs(list) do
      total = total + item_width(item)
      if i > 1 then
        total = total + sep_width
      end
    end
    return total
  end

  local kept = {}
  for i = #items, 1, -1 do
    local candidate = { items[i] }
    vim.list_extend(candidate, kept)
    if total_width(candidate) <= max_width then
      kept = candidate
    else
      break
    end
  end

  if #kept == 0 then
    local current = items[#items]
    local available = max_width - M.width(current.icon) - 1
    if available < 1 then
      return {}, false
    end
    return {
      {
        name = M.truncate_right(current.name, available),
        icon = current.icon,
        icon_fg = current.icon_fg,
        current = true,
      },
    }, true
  end

  local truncated = #kept < #items
  if truncated and #kept > 1 then
    while #kept > 1 and total_width(kept) + ellipsis_width + sep_width > max_width do
      table.remove(kept, 1)
    end
    if total_width(kept) + ellipsis_width + sep_width > max_width then
      truncated = false
    end
  end
  if #kept == #items then
    truncated = false
  end

  return kept, truncated
end

function M.icon_fg(group)
  if not group then
    return nil
  end
  if fg_cache[group] ~= nil then
    return fg_cache[group] or nil
  end

  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  local fg = ok and hl.fg or nil
  fg_cache[group] = fg and string.format("#%06x", fg) or false
  return fg_cache[group] or nil
end

local augroup = vim.api.nvim_create_augroup("HeirlineUtils", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = function()
    fg_cache = {}
  end,
})
vim.api.nvim_create_autocmd({ "BufFilePost", "BufDelete" }, {
  group = augroup,
  callback = function(args)
    root_cache[args.buf] = nil
  end,
})
vim.api.nvim_create_autocmd("DirChanged", {
  group = augroup,
  callback = function()
    root_cache = {}
  end,
})

return M
