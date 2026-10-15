return {
  -- blink.cmp first: it registers LSP capabilities that must be in place
  -- before nvim-lspconfig starts any server
  { import = "plugins.blink" },
  { import = "lsp" },
  { import = "plugins.colorscheme" },
  { import = "plugins.conform" },
  { import = "plugins.fzf" },
  { import = "plugins.gitsigns" },
  { import = "plugins.lint" },
  { import = "plugins.lspsaga" },
  { import = "plugins.lualine" },
  { import = "plugins.trouble" },
}
