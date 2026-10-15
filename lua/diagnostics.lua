-- shared by the LSP client and nvim-lint
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_text = { source = "if_many", spacing = 2 },
  float = { border = "rounded", source = "if_many" },
  jump = { float = true },
})
