return {
  {
    "nvim-navic",
    dep_of = "heirline.nvim",
    after = function()
      local navic = require("nvim-navic")
      navic.setup({
        icons = { enabled = false },
        highlight = false,
        separator = " › ",
        lazy_update_context = false,
        lsp = {
          auto_attach = true,
          preference = { "ts_ls", "rust_analyzer", "ty", "nil_ls", "hls", "lua_ls", "yamlls" },
        },
      })

      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.b[bufnr].navic_client_id == nil then
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if client.server_capabilities.documentSymbolProvider then
              navic.attach(client, bufnr)
            end
          end
        end
      end
    end,
  },
  {
    "heirline.nvim",
    event = "DeferredUIEnter",
    after = function()
      local theme = require("plugins.heirline.theme")
      theme.setup()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("HeirlineTheme", { clear = true }),
        callback = theme.setup,
      })

      local tabline = require("plugins.heirline.tabline")
      require("heirline").setup({
        statusline = require("plugins.heirline.statusline"),
        winbar = require("plugins.heirline.winbar"),
        tabline = tabline.tabline,
        opts = {
          disable_winbar_cb = function(args)
            return require("plugins.heirline.utils").is_special(args.buf)
          end,
        },
      })
      tabline.setup_keys()
      vim.o.showtabline = 2
    end,
  },
}
