-- Servers are listed once and reused by the keymaps below and by startup.
local servers = {
  -- core
  "lua_ls",
  "nil_ls",
  -- web and data
  "ts_ls",
  "eslint",
  "jsonls",
  "cssls",
  "html",
  "yamlls",
  "taplo",
  -- other languages
  "ty",
  "ruff",
  "rust_analyzer",
}

-- HLS drags GHC into the closure, so it is system-provided. Only enable it when
-- the system actually has it.
if vim.fn.executable("haskell-language-server-wrapper") == 1 then
  table.insert(servers, "hls")
end

---Stop every running client. A stopped client is not reused, so calling
---`vim.lsp.enable()` afterwards starts fresh ones for the open buffers.
local function stop_servers()
  for _, client in ipairs(vim.lsp.get_clients()) do
    client:stop()
  end
end

return {
  {
    "nvim-lspconfig",
    -- a real file must be opened, so plugin UIs (dashboard, help, terminal)
    -- never load the LSP stack
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>li", "<cmd>checkhealth vim.lsp<CR>", desc = "LSP info" },
      { "<leader>ls", function() vim.lsp.enable(servers) end, desc = "Start LSP" },
      { "<leader>lq", stop_servers, desc = "Stop LSP" },
      {
        "<leader>lR",
        function()
          stop_servers()
          vim.lsp.enable(servers)
        end,
        desc = "Restart LSP",
      },
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

      vim.lsp.config("nil_ls", {
        settings = {
          ["nil"] = {
            formatting = { command = { "nixfmt" } },
          },
        },
      })

      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
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

      -- grr (references), gri (implementation) and gO (document symbols) are
      -- Neovim defaults and need no mapping here. grx (codelens) and gD
      -- (declaration) are not, so they are added per buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local bufmap = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          bufmap("grx", vim.lsp.codelens.run, "Run codelens")
          bufmap("gD", vim.lsp.buf.declaration, "Declaration")
        end,
      })

      vim.lsp.enable(servers)
    end,
  },
}
