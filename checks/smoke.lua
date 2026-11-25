-- Headless smoke test for the configuration, run by `nix flake check`.
--
-- It loads the same deferred plugins a real UI loads and asserts that the parts
-- with no visible fallback work: the mini.bracketed undo target, a treesitter
-- highlighter for a filetype Neovim has no ftplugin for, a running LSP client,
-- and the keymaps that were deliberately added or removed.
--
-- Failures are written to stderr and the process exits non-zero.

local failures = {}

local function check(condition, message)
  if not condition then
    failures[#failures + 1] = message
  end
end

local function loaded(module)
  return package.loaded[module] ~= nil
end

local function wait(predicate, timeout)
  return vim.wait(timeout or 8000, predicate, 100)
end

---Empty file with the given extension, so filetype detection picks it up.
---@param extension string
---@return string
local function scratch_file(extension)
  local path = vim.fn.tempname() .. "." .. extension
  vim.fn.writefile({ "" }, path)
  return path
end

---@return integer
local function current_highlighter()
  return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] and 1 or 0
end

local function run()
  -- the deferred plugin stack only loads once a UI exists
  vim.api.nvim_exec_autocmds("User", { pattern = "DeferredUIEnter" })
  check(
    wait(function()
      return loaded("heirline")
        and loaded("which-key")
        and loaded("mini.bracketed")
        and loaded("stay-centered")
    end),
    "deferred UI plugins did not load"
  )

  check(
    wait(function()
      return vim.fn.maparg("[u", "n") ~= "" and vim.fn.maparg("]u", "n") ~= ""
    end, 2000),
    "mini.bracketed undo mappings are missing (undo.suffix = \"u\")"
  )

  check(
    loaded("stay-centered") and require("stay-centered").cfg.enabled,
    "stay-centered is not active after startup"
  )

  -- treesitter for a filetype whose highlighting only comes from our autocmd
  vim.cmd.edit(scratch_file("yaml"))
  check(wait(function() return current_highlighter() == 1 end), "no treesitter highlighter for yaml")
  check(vim.bo.syntax == "", "regex syntax was not disabled for the treesitter buffer")

  -- LSP on a real file
  vim.cmd.edit(scratch_file("lua"))
  check(
    wait(function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end),
    "no LSP client attached to a lua buffer"
  )
  check(
    #vim.lsp.get_clients({ bufnr = 0 }) > 0
      and vim.fn.maparg("grx", "n") ~= ""
      and vim.fn.maparg("gD", "n") ~= "",
    "LSP buffer mappings are missing"
  )

  -- keymaps: one is intentionally gone, the rest are load bearing
  check(vim.fn.maparg("jk", "i") == "", "the jk insert mapping should be removed")
  check(vim.fn.maparg("jj", "i") ~= "", "the jj insert mapping is missing")
  check(vim.fn.maparg("<C-d>", "n") == "", "the <C-d>zz mapping should be removed")
  check(vim.fn.maparg("<leader>qq", "n") == "<Cmd>quitall<CR>", "<leader>qq should use quitall")
  check(vim.fn.maparg("<leader>cf", "n") == ":setfiletype ", "<leader>cf should use :setfiletype")
  check(vim.fn.maparg("<leader>uv", "n") ~= "", "the <leader>uv toggle is missing")

  -- auto-session loads on UIEnter; restoring itself needs a real UI
  vim.api.nvim_exec_autocmds("UIEnter", {})
  check(wait(function() return loaded("auto-session") end), "auto-session did not load on UIEnter")
end

-- watchdog: a hanging plugin must fail the check instead of stalling it
vim.defer_fn(function()
  io.stderr:write("smoke: timed out\n")
  vim.cmd("cquit 1")
end, 60000)

vim.schedule(function()
  local ok, err = pcall(run)
  if not ok then
    failures[#failures + 1] = "smoke test errored: " .. tostring(err)
  end

  if #failures > 0 then
    for _, failure in ipairs(failures) do
      io.stderr:write("smoke: " .. failure .. "\n")
    end
    vim.cmd("cquit 1")
  end

  vim.cmd("qa!")
end)
