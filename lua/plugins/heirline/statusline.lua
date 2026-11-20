local theme = require("plugins.heirline.theme")
local utils = require("plugins.heirline.utils")

local function p()
  return theme.get()
end

local mode_names = {
  n = "NORMAL",
  no = "NORMAL",
  nov = "NORMAL",
  noV = "NORMAL",
  i = "INSERT",
  ic = "INSERT",
  ix = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
  R = "REPLACE",
  Rc = "REPLACE",
  Rx = "REPLACE",
  c = "COMMAND",
  cv = "COMMAND",
  ce = "COMMAND",
  r = "PROMPT",
  rm = "MORE",
  ["!"] = "SHELL",
  t = "TERMINAL",
}

local mode_color_keys = {
  NORMAL = "blue",
  INSERT = "green",
  VISUAL = "mauve",
  ["V-LINE"] = "mauve",
  ["V-BLOCK"] = "mauve",
  SELECT = "sky",
  ["S-LINE"] = "sky",
  ["S-BLOCK"] = "sky",
  REPLACE = "red",
  COMMAND = "yellow",
  PROMPT = "peach",
  MORE = "peach",
  SHELL = "peach",
  TERMINAL = "teal",
}

---@param mode? string
---@return string
local function mode_name(mode)
  mode = mode or vim.api.nvim_get_mode().mode
  if mode == "" then
    return "NORMAL"
  end
  return mode_names[mode] or mode_names[mode:sub(1, 1)] or mode:upper()
end

---@param name string
---@return table
local function mode_hl(name)
  local key = mode_color_keys[name]
  return { fg = (key and p()[key]) or p().text, bold = true }
end

local Mode = {
  init = function(self)
    self.mode = mode_name()
  end,
  provider = function(self)
    return self.mode .. " "
  end,
  hl = function(self)
    return mode_hl(self.mode)
  end,
  update = "ModeChanged",
}

local Macro = {
  condition = function()
    return vim.fn.reg_recording() ~= ""
  end,
  provider = function()
    return "REC @" .. vim.fn.reg_recording() .. " "
  end,
  hl = function()
    return { fg = p().red, bold = true }
  end,
  update = { "RecordingEnter", "RecordingLeave" },
}

---@return table|nil
local function git_status()
  return vim.b.gitsigns_status_dict
end

local GitBranch = {
  condition = function()
    local status = git_status()
    return type(status) == "table" and status.head ~= nil and status.head ~= ""
  end,
  provider = function()
    return "󰊢 " .. utils.escape(git_status().head) .. " "
  end,
  hl = function()
    return { fg = p().blue }
  end,
  update = { "BufEnter", "BufWritePost" },
}

---@param field string
---@param sign string
---@param color_key string
---@return table
local function git_diff(field, sign, color_key)
  return {
    condition = function()
      local status = git_status()
      return type(status) == "table" and (status[field] or 0) > 0
    end,
    provider = function()
      return sign .. git_status()[field] .. " "
    end,
    hl = function()
      return { fg = p()[color_key] }
    end,
    update = { "BufEnter", "BufWritePost" },
  }
end

local GitAdded = git_diff("added", "+", "green")
local GitChanged = git_diff("changed", "~", "yellow")
local GitRemoved = git_diff("removed", "-", "red")

-- Diagnostics: compute per-severity counts once per buffer per redraw, not
-- once per component. Keyed by buffer because statuslines are evaluated per
-- window (splits show different buffers).
local diag_cache = {}

local diag_augroup = vim.api.nvim_create_augroup("HeirlineDiagnostics", { clear = true })
vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter", "BufDelete", "BufWipeout" }, {
  group = diag_augroup,
  callback = function(args)
    diag_cache[args.buf] = nil
  end,
})

---@return table<integer, integer>
local function diagnostic_counts()
  local bufnr = vim.api.nvim_get_current_buf()
  local counts = diag_cache[bufnr]
  if not counts then
    if vim.tbl_count(diag_cache) > 128 then
      diag_cache = {}
    end
    counts = vim.diagnostic.count(bufnr)
    diag_cache[bufnr] = counts
  end
  return counts
end

---@param severity integer
---@param icon string
---@param color_key string
---@return table
local function diagnostic(severity, icon, color_key)
  return {
    condition = function()
      return (diagnostic_counts()[severity] or 0) > 0
    end,
    provider = function()
      return icon .. " " .. diagnostic_counts()[severity] .. " "
    end,
    hl = function()
      return { fg = p()[color_key] }
    end,
    update = { "DiagnosticChanged", "BufEnter" },
  }
end

local DiagnosticError = diagnostic(vim.diagnostic.severity.ERROR, "󰅚", "red")
local DiagnosticWarn = diagnostic(vim.diagnostic.severity.WARN, "󰀪", "yellow")
local DiagnosticInfo = diagnostic(vim.diagnostic.severity.INFO, "󰋽", "blue")
local DiagnosticHint = diagnostic(vim.diagnostic.severity.HINT, "󰌶", "teal")

local Search = {
  condition = function()
    return vim.v.hlsearch == 1
  end,
  provider = function()
    local ok, count = pcall(vim.fn.searchcount, { maxcount = 99, timeout = 100 })
    if not ok or type(count) ~= "table" or (count.total or 0) == 0 then
      return ""
    end
    local suffix = count.incomplete == 1 and "+" or ""
    return "[" .. (count.current or 0) .. "/" .. count.total .. suffix .. "] "
  end,
  hl = function()
    return { fg = p().overlay1 }
  end,
  update = { "CursorMoved", "CmdlineLeave", "SearchWrapped" },
}

local Lsp = {
  provider = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      return ""
    end
    local names = {}
    for _, client in ipairs(clients) do
      names[#names + 1] = client.name
    end
    table.sort(names)
    return "[" .. utils.escape(table.concat(names, ", ")) .. "] "
  end,
  hl = function()
    return { fg = p().overlay1 }
  end,
  update = { "LspAttach", "LspDetach", "BufEnter" },
}

local FileType = {
  condition = function()
    return vim.bo.filetype ~= ""
  end,
  provider = function()
    return utils.escape(vim.bo.filetype) .. " "
  end,
  hl = function()
    return { fg = p().overlay1 }
  end,
  update = { "FileType", "BufEnter" },
}

local Position = {
  provider = function()
    local line = vim.fn.line(".")
    local total = math.max(vim.fn.line("$"), 1)
    return string.format("%d:%d %d%% ", line, vim.fn.virtcol("."), math.floor(line * 100 / total))
  end,
  hl = function()
    return { fg = p().text }
  end,
  update = { "CursorMoved", "CursorMovedI", "BufEnter" },
}

return {
  Mode,
  Macro,
  GitBranch,
  GitAdded,
  GitChanged,
  GitRemoved,
  DiagnosticError,
  DiagnosticWarn,
  DiagnosticInfo,
  DiagnosticHint,
  Search,
  { provider = "%=" },
  Lsp,
  FileType,
  Position,
}
