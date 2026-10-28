return {
  {
    "nvim-lspconfig",
    event = "FileType",
    -- declared via lze `keys` so they exist before the first file is opened;
    -- pressing one loads nvim-lspconfig and then runs the command
    keys = {
      { "<leader>li", "<cmd>checkhealth vim.lsp<CR>",                                           desc = "LSP info" },
      { "<leader>ls", "<cmd>doautocmd FileType<CR>",                                            desc = "Start LSP" },
      { "<leader>lq", "<cmd>lua for _, c in ipairs(vim.lsp.get_clients()) do c:stop() end<CR>", desc = "Stop LSP" },
      {
        "<leader>lR",
        "<cmd>lua for _, c in ipairs(vim.lsp.get_clients()) do c:stop() end vim.cmd('doautocmd FileType')<CR>",
        desc = "Restart LSP",
      },
      { "<leader>uv", "<cmd>lua _G.toggle_virtual_text()<CR>", desc = "Toggle diagnostic virtual text" },
    },
    after = function()
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
                max_line_length = "120",
              },
            },
          },
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = { typeCheckingMode = "standard" },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      })

      vim.lsp.config("hls", {
        settings = {
          haskell = { formattingProvider = "fourmolu" },
        },
      })

      -- lspsaga owns rename, code actions and type definitions. Remove Neovim's
      -- built-in defaults for those so each action has exactly one implementation.
      for _, lhs in ipairs({ "grn", "gra", "grt" }) do
        pcall(vim.keymap.del, "n", lhs)
      end

      -- LSP keymaps, declared explicitly instead of relying on Neovim's defaults
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local bufmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- rename, code actions and type definitions are handled by lspsaga
          bufmap("n", "grx", vim.lsp.codelens.run, "Run codelens")
          bufmap("n", "grr", vim.lsp.buf.references, "References")
          bufmap("n", "gri", vim.lsp.buf.implementation, "Implementation")
          bufmap("n", "gO", vim.lsp.buf.document_symbol, "Document symbols")
          bufmap("n", "gD", vim.lsp.buf.declaration, "Declaration")
        end,
      })

      vim.lsp.enable({
        -- core
        "lua_ls",
        "nixd",
        -- web and data
        "ts_ls",
        "eslint",
        "jsonls",
        "cssls",
        "html",
        "yamlls",
        "taplo",
        -- other languages
        "pyright",
        "ruff",
        "rust_analyzer",
        "hls",
      })
    end,
  },
}
