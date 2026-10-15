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

      -- LSP keymaps, declared explicitly instead of relying on Neovim's defaults
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("n", "grn", vim.lsp.buf.rename, "Rename symbol")
          map({ "n", "x" }, "gra", vim.lsp.buf.code_action, "Code action")
          map("n", "grx", vim.lsp.codelens.run, "Run codelens")
          map("n", "grr", vim.lsp.buf.references, "References")
          map("n", "gri", vim.lsp.buf.implementation, "Implementation")
          map("n", "grt", vim.lsp.buf.type_definition, "Type definition")
          map("n", "gO", vim.lsp.buf.document_symbol, "Document symbols")
          map("n", "gD", vim.lsp.buf.declaration, "Declaration")
          map({ "i", "s" }, "<C-s>", vim.lsp.buf.signature_help, "Signature help")
        end,
      })

      vim.lsp.enable({ "lua_ls", "nixd" })
    end,
  },
}
