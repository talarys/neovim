-- Minimal neovim configuration.
-- The nix wrapper provides the plugins and puts runtime dependencies on PATH.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lze lazy-loads the plugins that are marked `lazy = true` in flake.nix.
-- Every spec here is looked up by the plugin's pack name, e.g. "gitsigns.nvim".
local lze = require("lze")

lze.load({
  {
    -- loaded the first time a file with a filetype is opened
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
  {
    -- loaded once the UI is up, so the finder stays off the startup path
    "fzf-lua",
    event = "DeferredUIEnter",
    after = function()
      require("fzf-lua").setup({})
      local map = vim.keymap.set
      map("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "Find files" })
      map("n", "<leader>fg", function() require("fzf-lua").live_grep() end, { desc = "Grep" })
      map("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "Buffers" })
    end,
  },
})
