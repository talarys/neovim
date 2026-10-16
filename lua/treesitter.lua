-- Incremental node selection for the <leader>vt keymap. Neovim ships the
-- treesitter API but no "select the node under the cursor" helper, so this
-- grows the visual selection from the node to its parent on every call.
local M = {}

--- nearest named ancestor (skips anonymous nodes such as brackets/commas)
local function named_parent(node)
  local parent = node:parent()
  while parent and not parent:named() do
    parent = parent:parent()
  end
  return parent
end

--- last visual selection as { srow, scol, erow, ecol }, 0-based, end exclusive
local function last_selection()
  local from, to = vim.fn.getpos("'<"), vim.fn.getpos("'>")
  if from[2] == 0 or to[2] == 0 then
    return nil
  end
  return { from[2] - 1, from[3] - 1, to[2] - 1, to[3] }
end

--- does the visual selection cover exactly this node?
local function is_selected(node, sel)
  local srow, scol, erow, ecol = node:range()
  if srow ~= sel[1] or erow ~= sel[3] or scol ~= sel[2] then
    return false
  end
  -- a charwise selection cannot contain the trailing newline, so a node ending
  -- at column 0 of the next line selects up to the end of the previous line
  return ecol == sel[4] or (ecol == 0 and erow > srow)
end

local function clamp(bufnr, row, col)
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
  return math.min(math.max(col, 0), math.max(#line - 1, 0))
end

--- select the node under the cursor, or its parent when it is already selected
function M.select_node()
  local bufnr = vim.api.nvim_get_current_buf()
  local sel = last_selection()
  local ok, node = pcall(vim.treesitter.get_node, {
    bufnr = bufnr,
    pos = sel and { sel[1], sel[2] } or nil,
  })
  if not ok or not node then
    return
  end

  if sel then
    local selected = node
    while selected and not is_selected(selected, sel) do
      selected = named_parent(selected)
    end
    if selected then
      node = named_parent(selected)
      if not node then
        return -- already the outermost node, nothing left to grow into
      end
    end
  end

  local srow, scol, erow, ecol = node:range()
  -- nodes may end at column 0 of the following line: stop on the line before
  if ecol == 0 and erow > srow then
    erow = erow - 1
    ecol = #(vim.api.nvim_buf_get_lines(bufnr, erow, erow + 1, false)[1] or "")
  end

  vim.api.nvim_win_set_cursor(0, { srow + 1, clamp(bufnr, srow, scol) })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { erow + 1, clamp(bufnr, erow, ecol - 1) })
end

return M
