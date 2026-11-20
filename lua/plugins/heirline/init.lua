local navic_preference = { "ts_ls", "rust_analyzer", "ty", "nil_ls", "hls", "lua_ls", "yamlls" }

---@param name string
---@return integer
local function preference_rank(name)
  for i, preferred in ipairs(navic_preference) do
    if preferred == name then
      return i
    end
  end
  return math.huge
end

---Attach nvim-navic to buffers that already have a capable LSP client.
---`navic.setup()` only hooks future `LspAttach` events, so backfill is needed.
---@param navic table
local function backfill_navic(navic)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr)
      and vim.bo[bufnr].buftype == ""
      and vim.b[bufnr].navic_client_id == nil
    then
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      table.sort(clients, function(a, b)
        return preference_rank(a.name) < preference_rank(b.name)
      end)

      for _, client in ipairs(clients) do
        if client.server_capabilities.documentSymbolProvider then
          pcall(navic.attach, client, bufnr) -- one client per buffer, preferred first
          break
        end
      end
    end
  end
end

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
        lsp = {
          auto_attach = true,
          preference = navic_preference,
        },
      })

      backfill_navic(navic)
    end,
  },
  {
    "heirline.nvim",
    event = "DeferredUIEnter",
    after = function()
      local theme = require("plugins.heirline.theme")
      local utils = require("plugins.heirline.utils")
      local components = require("plugins.heirline.components")

      theme.setup()

      local cache_group = vim.api.nvim_create_augroup("HeirlineCaches", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = cache_group,
        callback = function()
          theme.setup()
          components.clear_cache()
        end,
      })
      vim.api.nvim_create_autocmd({ "BufFilePost", "BufWipeout", "FileType" }, {
        group = cache_group,
        callback = function()
          components.clear_cache()
        end,
      })

      -- Gitsigns refreshes its status dict asynchronously; redraw when it does.
      vim.api.nvim_create_autocmd("User", {
        group = cache_group,
        pattern = "GitSignsUpdate",
        callback = function()
          vim.cmd("redrawstatus")
        end,
      })

      local tabline = require("plugins.heirline.tabline")
      require("heirline").setup({
        statusline = require("plugins.heirline.statusline"),
        winbar = require("plugins.heirline.winbar"),
        tabline = tabline.tabline,
        opts = {
          disable_winbar_cb = function(args)
            return utils.is_special(args.buf)
          end,
        },
      })
      tabline.setup_keys()
      vim.o.showtabline = 2
    end,
  },
}
