local MiniIcons = require("mini.icons")

local theme = require("plugins.heirline.theme")
local utils = require("plugins.heirline.utils")

local p = theme.get()

local M = {}

local order = {}

local function listed_buffers()
  local listed = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
      listed[bufnr] = true
    end
  end

  local next_order = {}
  for _, bufnr in ipairs(order) do
    if listed[bufnr] then
      next_order[#next_order + 1] = bufnr
      listed[bufnr] = nil
    end
  end

  local remaining = {}
  for bufnr in pairs(listed) do
    remaining[#remaining + 1] = bufnr
  end
  table.sort(remaining)
  vim.list_extend(next_order, remaining)

  order = next_order
  return order
end

local function current_index()
  local current = vim.api.nvim_get_current_buf()
  for i, bufnr in ipairs(listed_buffers()) do
    if bufnr == current then
      return i
    end
  end
end

function M.move(delta)
  local index = current_index()
  if not index then
    return
  end

  local target = index + delta
  if target < 1 or target > #order then
    return
  end

  order[index], order[target] = order[target], order[index]
  vim.cmd.redrawtabline()
end

function M.close_others()
  local current = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(listed_buffers()) do
    if bufnr ~= current then
      pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
    end
  end
  vim.cmd.redrawtabline()
end

local Buffer = {
  init = function(self)
    local name = vim.api.nvim_buf_get_name(self.bufnr)
    self.name = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":t")
    local icon, icon_hl = MiniIcons.get("file", name == "" and self.name or name)
    self.icon = icon
    self.icon_fg = utils.icon_fg(icon_hl) or p.text
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
        return { fg = p.text, bold = true }
      elseif self.is_visible then
        return { fg = p.subtext1 }
      else
        return { fg = p.overlay1 }
      end
    end,
  },
  {
    condition = function(self)
      return vim.bo[self.bufnr].modified
    end,
    provider = " ●",
    hl = { fg = p.peach },
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
  hl = { fg = p.overlay0 },
}

local right_trunc = {
  provider = " ›",
  hl = { fg = p.overlay0 },
}

M.tabline = utils.make_buflist(Buffer, left_trunc, right_trunc, listed_buffers, false)

function M.setup_keys()
  local map = vim.keymap.set
  map("n", "<leader>bp", "<cmd>lua Snacks.picker.buffers()<CR>", { desc = "Buffer pick" })
  map("n", "<leader>bc", M.close_others, { desc = "Close other buffers" })
  map("n", "<leader>bh", function()
    M.move(-1)
  end, { desc = "Move buffer left" })
  map("n", "<leader>bl", function()
    M.move(1)
  end, { desc = "Move buffer right" })
end

local augroup = vim.api.nvim_create_augroup("HeirlineTabline", { clear = true })
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufModifiedSet", "BufFilePost" }, {
  group = augroup,
  callback = function()
    vim.cmd.redrawtabline()
  end,
})

return M
