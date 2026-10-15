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
          local bufmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          bufmap("n", "grn", vim.lsp.buf.rename, "Rename symbol")
          bufmap({ "n", "x" }, "gra", vim.lsp.buf.code_action, "Code action")
          bufmap("n", "grx", vim.lsp.codelens.run, "Run codelens")
          bufmap("n", "grr", vim.lsp.buf.references, "References")
          bufmap("n", "gri", vim.lsp.buf.implementation, "Implementation")
          bufmap("n", "gI", vim.lsp.buf.implementation, "Goto implementation")
          bufmap("n", "grt", vim.lsp.buf.type_definition, "Type definition")
          bufmap("n", "gO", vim.lsp.buf.document_symbol, "Document symbols")
          bufmap("n", "gD", vim.lsp.buf.declaration, "Declaration")
          bufmap({ "i", "s" }, "<C-s>", vim.lsp.buf.signature_help, "Signature help")
        end,
      })

      -- LSP controls
      local map = vim.keymap.set
      map("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", { desc = "LSP info" })
      map("n", "<leader>ls", "<cmd>doautocmd FileType<CR>", { desc = "Start LSP" })
      map("n", "<leader>lq", "<cmd>lua for _, c in ipairs(vim.lsp.get_clients()) do c:stop() end<CR>", {
        desc = "Stop LSP",
      })
      map(
        "n",
        "<leader>lR",
        "<cmd>lua for _, c in ipairs(vim.lsp.get_clients()) do c:stop() end vim.cmd('doautocmd FileType')<CR>",
        { desc = "Restart LSP" }
      )
      map("n", "<leader>lL", "<cmd>lua _G.toggle_diagnostics()<CR>", { desc = "Toggle diagnostics" })
      map("n", "<leader>ll", "<cmd>lua _G.toggle_virtual_text()<CR>", { desc = "Toggle virtual text" })

      vim.lsp.enable({ "lua_ls", "nixd" })
    end,
  },
}
