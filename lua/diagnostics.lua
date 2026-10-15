-- shared by the LSP client and nvim-lint
local virtual_text = { source = "if_many", spacing = 2 }

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_text = virtual_text,
  float = { border = "rounded", source = "if_many" },
  jump = { float = true },
})

-- used by the <leader>ud / <leader>lL / <leader>ll keymaps
function _G.toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

function _G.toggle_virtual_text()
  virtual_text = virtual_text and false or { source = "if_many", spacing = 2 }
  vim.diagnostic.config({ virtual_text = virtual_text })
end
