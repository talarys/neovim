local theme = require("plugins.heirline.theme")
local utils = require("plugins.heirline.utils")

local p = theme.get()

local function mode_name()
  local mode = vim.api.nvim_get_mode().mode
  local names = {
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
  return names[mode] or mode:upper()
end

local mode_colors = {
  NORMAL = p.blue,
  INSERT = p.green,
  VISUAL = p.mauve,
  ["V-LINE"] = p.mauve,
  ["V-BLOCK"] = p.mauve,
  SELECT = p.sky,
  ["S-LINE"] = p.sky,
  ["S-BLOCK"] = p.sky,
  REPLACE = p.red,
  COMMAND = p.yellow,
  PROMPT = p.peach,
  MORE = p.peach,
  SHELL = p.peach,
  TERMINAL = p.teal,
}

local Mode = {
  provider = function()
    return mode_name() .. " "
  end,
  hl = function()
    return { fg = mode_colors[mode_name()] or p.text, bold = true }
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
  hl = { fg = p.red, bold = true },
  update = { "RecordingEnter", "RecordingLeave" },
}

local function git_status()
  return vim.b.gitsigns_status_dict
end

local GitBranch = {
  condition = function()
    local status = git_status()
    return status ~= nil and status.head ~= nil and status.head ~= ""
  end,
  provider = function()
    return "󰊢 " .. utils.escape(git_status().head) .. " "
  end,
  hl = { fg = p.blue },
  update = { "BufEnter", "BufWritePost", "User" },
}

local function git_diff(field, sign, color)
  return {
    condition = function()
      local status = git_status()
      return status ~= nil and (status[field] or 0) > 0
    end,
    provider = function()
      return sign .. git_status()[field] .. " "
    end,
    hl = { fg = color },
    update = { "BufEnter", "BufWritePost", "User" },
  }
end

local GitAdded = git_diff("added", "+", p.green)
local GitChanged = git_diff("changed", "~", p.yellow)
local GitRemoved = git_diff("removed", "-", p.red)

local function diagnostic_count(severity)
  return #vim.diagnostic.get(0, { severity = severity })
end

local function diagnostic(severity, icon, color)
  return {
    condition = function()
      return diagnostic_count(severity) > 0
    end,
    provider = function()
      return icon .. " " .. diagnostic_count(severity) .. " "
    end,
    hl = { fg = color },
    update = { "DiagnosticChanged", "BufEnter" },
  }
end

local DiagnosticError = diagnostic(vim.diagnostic.severity.ERROR, "󰅚", p.red)
local DiagnosticWarn = diagnostic(vim.diagnostic.severity.WARN, "󰀪", p.yellow)
local DiagnosticInfo = diagnostic(vim.diagnostic.severity.INFO, "󰋽", p.blue)
local DiagnosticHint = diagnostic(vim.diagnostic.severity.HINT, "󰌶", p.teal)

local Search = {
  condition = function()
    return vim.v.hlsearch == 1
  end,
  provider = function()
    local ok, count = pcall(vim.fn.searchcount, { maxcount = 99, timeout = 100 })
    if not ok or not count or count.total == 0 then
      return ""
    end
    local suffix = count.incomplete == 1 and "+" or ""
    return "[" .. count.current .. "/" .. count.total .. suffix .. "] "
  end,
  hl = { fg = p.overlay1 },
  update = { "CursorMoved", "CmdlineLeave", "SearchWrapped" },
}

local Lsp = {
  condition = function()
    return #vim.lsp.get_clients({ bufnr = 0 }) > 0
  end,
  provider = function()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      names[#names + 1] = client.name
    end
    table.sort(names)
    return "[" .. utils.escape(table.concat(names, ", ")) .. "] "
  end,
  hl = { fg = p.overlay1 },
  update = { "LspAttach", "LspDetach", "BufEnter" },
}

local FileType = {
  condition = function()
    return vim.bo.filetype ~= ""
  end,
  provider = function()
    return utils.escape(vim.bo.filetype) .. " "
  end,
  hl = { fg = p.overlay1 },
  update = { "FileType", "BufEnter" },
}

local Location = {
  provider = function()
    return vim.fn.line(".") .. ":" .. vim.fn.col(".") .. " "
  end,
  hl = { fg = p.text },
  update = { "CursorMoved", "CursorMovedI", "BufEnter" },
}

local Percentage = {
  provider = function()
    local line = vim.fn.line(".")
    local total = math.max(vim.fn.line("$"), 1)
    return math.floor(line * 100 / total) .. "% "
  end,
  hl = { fg = p.overlay1 },
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
  Location,
  Percentage,
}
