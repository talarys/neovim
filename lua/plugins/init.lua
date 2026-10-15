return {
  -- blink.cmp first: it registers LSP capabilities that must be in place
  -- before nvim-lspconfig starts any server
  { import = "plugins.blink" },
  { import = "plugins.bufferline" },
  { import = "plugins.colorscheme" },
  { import = "plugins.conform" },
  { import = "plugins.gitsigns" },
  { import = "plugins.lint" },
  { import = "plugins.lspsaga" },
  { import = "plugins.lualine" },
  { import = "plugins.noice" },
  { import = "plugins.smart-splits" },
  { import = "plugins.snacks" },
  { import = "plugins.trouble" },
}
