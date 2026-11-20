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
  if type(text) ~= "string" or text == "" then
    return 0
  end
  return vim.fn.strdisplaywidth(text)
end

function M.escape(text)
  if type(text) ~= "string" then
    text = tostring(text)
  end
  return (text:gsub("%%", "%%%%"):gsub("\n", " "))
end

---Whether the buffer should not get a winbar (non-file buffers and plugin UIs).
---@param bufnr? integer
---@return boolean
function M.is_special(bufnr)
  bufnr = bufnr or 0
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return true
  end

  local bo = vim.bo[bufnr]
  if bo.buftype ~= "" then
    return true
  end

  local ft = bo.filetype
  if ft == "" then
    return false
  end

  for _, pattern in ipairs(special_filetypes) do
    if ft:find(pattern) then
      return true
    end
  end
  return false
end

---Resolve the project root for a buffer, caching the result until the buffer is
---renamed, wiped, or the working directory changes.
---@param bufnr integer
---@return string
function M.project_root(bufnr)
  if root_cache[bufnr] then
    return root_cache[bufnr]
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  local is_file = name ~= "" and vim.bo[bufnr].buftype == ""
  local root = is_file and vim.fs.root(name, root_markers) or nil
  root = root or vim.fn.getcwd()
  root_cache[bufnr] = root
  return root
end

---@param bufnr integer
---@return string
function M.relative_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" or vim.bo[bufnr].buftype ~= "" then
    return ""
  end

  name = vim.fn.fnamemodify(name, ":p")
  local rel = vim.fs.relpath(M.project_root(bufnr), name)
  if not rel then
    rel = vim.fn.fnamemodify(name, ":~:.")
  end
  return rel:gsub("\\", "/")
end

---@param path string
---@return string dir, string base, string ext
function M.split_path(path)
  local dir = vim.fn.fnamemodify(path, ":h")
  dir = dir == "." and "" or dir .. "/"

  local tail = vim.fn.fnamemodify(path, ":t")
  local ext = vim.fn.fnamemodify(tail, ":e")
  local base = vim.fn.fnamemodify(tail, ":r")
  return dir, base, ext == "" and "" or "." .. ext
end

---Truncate a single line from the right, keeping `max_width` display cells.
---Uses a binary search over characters to avoid one Vimscript call per char.
---@param text string
---@param max_width integer
---@return string
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

  local lo, hi = 0, vim.fn.strchars(text)
  while lo < hi do
    local mid = math.floor((lo + hi + 1) / 2)
    if M.width(vim.fn.strcharpart(text, 0, mid)) + 1 <= max_width then
      lo = mid
    else
      hi = mid - 1
    end
  end
  return vim.fn.strcharpart(text, 0, lo) .. "…"
end

---Truncate a path from the left, preserving the file name and as many trailing
---directories as fit.
---@param path string
---@param max_width integer
---@return string
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

---Fit as many trailing breadcrumb items as possible within `max_width`,
---reserving room for the truncation marker when items are dropped.
---@param items table[]
---@param max_width integer
---@return table[] fitted, boolean truncated
function M.fit_breadcrumbs(items, max_width)
  if max_width <= 0 or #items == 0 then
    return {}, false
  end

  local sep_width = M.width(" › ")
  local marker_width = M.width("…") + sep_width

  local widths = {}
  for i, item in ipairs(items) do
    widths[i] = M.width(item.icon) + 1 + M.width(item.name)
  end

  ---@param budget integer
  ---@return table[] kept, integer used
  local function fit(budget)
    local kept = {}
    local used = 0
    for i = #items, 1, -1 do
      local cost = widths[i] + (used > 0 and sep_width or 0)
      if used + cost > budget then
        break
      end
      table.insert(kept, 1, items[i])
      used = used + cost
    end
    return kept, used
  end

  local kept = fit(max_width)
  if #kept == #items then
    return kept, false
  end

  -- Truncation is active: reserve space for the marker before fitting again.
  local refit = fit(max_width - marker_width)
  if #refit > 0 then
    return refit, true
  end

  -- Not even one crumb plus marker fits; show a single truncated deepest crumb.
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
  }, false
end

---Resolve the foreground color of a highlight group (cached per ColorScheme).
---@param group? string
---@return string|nil
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

vim.api.nvim_create_autocmd({ "BufFilePost", "BufDelete", "BufWipeout" }, {
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
