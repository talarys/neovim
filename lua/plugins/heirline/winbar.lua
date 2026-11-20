local conditions = require("heirline.conditions")

local components = require("plugins.heirline.components")

---@param winnr? integer
---@return integer|nil winid, integer|nil bufnr, integer|nil win_width
local function window_context(winnr)
  local winid = (winnr and vim.fn.win_getid(winnr)) or vim.api.nvim_get_current_win()
  if winid == 0 or not vim.api.nvim_win_is_valid(winid) then
    return nil
  end
  return winid, vim.api.nvim_win_get_buf(winid), vim.api.nvim_win_get_width(winid)
end

---Replace previously generated children with the given spec tables.
---@param self table
---@param children table[]
local function set_children(self, children)
  for i = #self, 1, -1 do
    self[i] = nil
  end
  if #children > 0 then
    self[1] = self:new(children, 1)
  end
end

local Breadcrumbs = {
  condition = conditions.is_active,
  init = function(self)
    local _, bufnr, win_width = window_context(self.winnr)
    if not bufnr then
      set_children(self, {})
      return
    end

    local chip_width = components.file_chip_width(bufnr, win_width)
    local max_width = math.max(0, win_width - chip_width - 1)
    set_children(self, components.breadcrumb_children(bufnr, max_width))
  end,
  update = { "CursorMoved", "BufEnter", "BufFilePost", "FileType", "WinResized", "LspAttach", "LspDetach" },
}

local FileChip = {
  init = function(self)
    local _, bufnr, win_width = window_context(self.winnr)
    if not bufnr then
      set_children(self, {})
      return
    end
    set_children(self, components.file_chip_children(bufnr, win_width, conditions.is_active()))
  end,
  update = { "BufEnter", "BufFilePost", "FileType", "WinResized", "ColorScheme" },
}

return {
  Breadcrumbs,
  { provider = "%=" },
  FileChip,
}
