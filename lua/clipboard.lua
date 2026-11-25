-- WSL has no native clipboard provider; bridge to the Windows clipboard.
local M = {}

local binary = "win32yank.exe"

function M.setup()
  if vim.fn.has("wsl") ~= 1 then
    return
  end

  if vim.fn.executable(binary) == 0 then
    -- `clipboard = "unnamedplus"` (see options.lua) would error on every yank
    -- without a provider, so turn it back off once the rest of startup is done.
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        vim.opt.clipboard = ""
        vim.notify(("%s not found, system clipboard disabled"):format(binary), vim.log.levels.WARN)
      end,
    })
    return
  end

  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = binary .. " -i --crlf",
      ["*"] = binary .. " -i --crlf",
    },
    paste = {
      ["+"] = binary .. " -o --lf",
      ["*"] = binary .. " -o --lf",
    },
    -- keep the clipboard content in memory instead of re-running the binary
    cache_enabled = 1,
  }
end

return M
