return {
  -- blink.cmp first: it registers LSP capabilities that must be in place
  -- before nvim-lspconfig starts any server
  { import = "plugins.blink" },
  { import = "lsp" },
  { import = "plugins.conform" },
  { import = "plugins.fzf" },
  { import = "plugins.lint" },
  { import = "plugins.lspsaga" },
  { import = "plugins.trouble" },
}
