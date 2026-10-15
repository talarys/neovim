return {
  {
    "nvim-lspconfig",
    event = "FileType",
    after = function()
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
      vim.lsp.enable({ "lua_ls", "nixd" })
    end,
  },
}
