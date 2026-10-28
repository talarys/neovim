-- WSL has no native clipboard provider; bridge to the Windows clipboard.
local M = {}

function M.setup()
  if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = "powershell.exe -c Get-Clipboard",
        ["*"] = "powershell.exe -c Get-Clipboard",
      },
      cache_enabled = 0,
    }
  end
end

return M
