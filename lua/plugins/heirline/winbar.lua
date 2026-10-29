local conditions = require("heirline.conditions")

local components = require("plugins.heirline.components")

local Breadcrumbs = {
  condition = conditions.is_active,
  init = function(self)
    local winid = vim.fn.win_getid(self.winnr)
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local win_width = vim.api.nvim_win_get_width(winid)
    local chip_width = components.file_chip_width(bufnr, win_width)
    local max_width = win_width - chip_width - 1
    local children = components.breadcrumb_children(bufnr, math.max(0, max_width))
    self.child = #children > 0 and self:new(children, 1) or nil
  end,
  provider = function(self)
    return self.child and self.child:eval() or ""
  end,
  update = { "CursorMoved", "BufEnter", "WinResized" },
}

local FileChip = {
  init = function(self)
    local winid = vim.fn.win_getid(self.winnr)
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local win_width = vim.api.nvim_win_get_width(winid)
    self.child = self:new(components.file_chip_children(bufnr, win_width, conditions.is_active()), 1)
  end,
  provider = function(self)
    return self.child and self.child:eval() or ""
  end,
}

return {
  Breadcrumbs,
  { provider = "%=" },
  FileChip,
}
