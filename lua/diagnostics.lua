-- shared by the LSP client and nvim-lint
local function virtual_text()
  return { source = "if_many", spacing = 2 }
end

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_text = virtual_text(),
  float = { border = "rounded", source = "if_many" },
  jump = { float = true },
})

-- used by the <leader>ud / <leader>lL / <leader>ll keymaps
function _G.toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

function _G.toggle_virtual_text()
  -- read the live config back; `x and false or y` would always yield y
  if vim.diagnostic.config().virtual_text ~= false then
    vim.diagnostic.config({ virtual_text = false })
  else
    vim.diagnostic.config({ virtual_text = virtual_text() })
  end
end
