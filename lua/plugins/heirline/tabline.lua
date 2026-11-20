local MiniIcons = require("mini.icons")

local heirline_utils = require("heirline.utils")
local theme = require("plugins.heirline.theme")
local utils = require("plugins.heirline.utils")

local function p()
  return theme.get()
end

local M = {}

---User-defined buffer order. Reconciled by listed_buffers() on every redraw.
local order = {}
local buf_meta = {}
local buf_cache = {}

local function invalidate()
  for i = #buf_cache, 1, -1 do
    buf_cache[i] = nil
  end
end

---@return table<integer, boolean>
local function listed_set()
  local set = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
      set[bufnr] = true
    end
  end
  return set
end

---Pure: returns the current buffer list in display order without mutating `order`.
---@return integer[]
local function listed_buffers()
  local remaining = listed_set()
  local out = {}
  for _, bufnr in ipairs(order) do
    if remaining[bufnr] then
      out[#out + 1] = bufnr
      remaining[bufnr] = nil
    end
  end

  local rest = vim.tbl_keys(remaining)
  table.sort(rest)
  vim.list_extend(out, rest)
  return out
end

local function sync_order()
  order = listed_buffers()
end

---@return integer|nil
local function current_index()
  local current = vim.api.nvim_get_current_buf()
  for i, bufnr in ipairs(order) do
    if bufnr == current then
      return i
    end
  end
end

---@param delta integer
function M.move(delta)
  sync_order()
  local index = current_index()
  if not index then
    return
  end

  local target = index + delta
  if target < 1 or target > #order then
    return
  end

  order[index], order[target] = order[target], order[index]
  invalidate() -- heirline only clears its own cache on BufAdd/BufDelete
  vim.cmd("redrawtabline")
end

function M.close_others()
  local current = vim.api.nvim_get_current_buf()
  local failed = 0

  for _, bufnr in ipairs(listed_buffers()) do
    if bufnr ~= current then
      if vim.bo[bufnr].modified or not pcall(vim.api.nvim_buf_delete, bufnr, { force = false }) then
        failed = failed + 1
      end
    end
  end

  if failed > 0 then
    vim.notify(("%d buffer(s) not closed (unsaved changes)"):format(failed), vim.log.levels.WARN)
  end
  vim.cmd("redrawtabline")
end

---@param bufnr integer
---@return table
local function meta(bufnr)
  local cached = buf_meta[bufnr]
  if cached then
    return cached
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  local display = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":t")
  local icon, icon_hl = MiniIcons.get("file", name == "" and display or name)

  cached = {
    name = display,
    icon = icon,
    icon_fg = utils.icon_fg(icon_hl) or p().text,
  }
  buf_meta[bufnr] = cached
  return cached
end

local Buffer = {
  init = function(self)
    local info = meta(self.bufnr)
    self.name = info.name
    self.icon = info.icon
    self.icon_fg = info.icon_fg
  end,
  {
    provider = function(self)
      return self.icon .. " "
    end,
    hl = function(self)
      return { fg = self.icon_fg }
    end,
  },
  {
    provider = function(self)
      return utils.escape(self.name)
    end,
    hl = function(self)
      if self.is_active then
        return { fg = p().text, bold = true }
      elseif self.is_visible then
        return { fg = p().subtext1 }
      else
        return { fg = p().overlay1 }
      end
    end,
  },
  {
    condition = function(self)
      return vim.bo[self.bufnr].modified
    end,
    provider = " ●",
    hl = function()
      return { fg = p().peach }
    end,
  },
  { provider = "  " },
  on_click = {
    callback = function(_, minwid)
      vim.api.nvim_win_set_buf(0, minwid)
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = "heirline_tabline_buffer_callback",
  },
}

local left_trunc = {
  provider = "‹ ",
  hl = function()
    return { fg = p().overlay0 }
  end,
}

local right_trunc = {
  provider = " ›",
  hl = function()
    return { fg = p().overlay0 }
  end,
}

M.tabline = heirline_utils.make_buflist(Buffer, left_trunc, right_trunc, listed_buffers, buf_cache)

function M.setup_keys()
  local map = vim.keymap.set
  map("n", "<leader>bp", function()
    local ok, snacks = pcall(require, "snacks")
    if not ok then
      vim.notify("Snacks is not available", vim.log.levels.WARN)
      return
    end
    snacks.picker.buffers()
  end, { desc = "Buffer pick" })
  map("n", "<leader>bc", M.close_others, { desc = "Close other buffers" })
  map("n", "<leader>bh", function()
    M.move(-1)
  end, { desc = "Move buffer left" })
  map("n", "<leader>bl", function()
    M.move(1)
  end, { desc = "Move buffer right" })
end

local augroup = vim.api.nvim_create_augroup("HeirlineTabline", { clear = true })
vim.api.nvim_create_autocmd(
  { "BufAdd", "BufDelete", "BufWipeout", "BufFilePost", "BufModifiedSet", "ColorScheme" },
  {
    group = augroup,
    callback = function(args)
      if args.event == "ColorScheme" then
        buf_meta = {}
      else
        buf_meta[args.buf] = nil
      end
      invalidate()
      vim.cmd("redrawtabline")
    end,
  }
)

return M
