return {
  {
    -- loaded once the UI is up: it has to be listening before a leader key is pressed
    "which-key.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("which-key").setup({
        preset = "helix",
        icons = {
          -- no plugin/file icons next to mappings
          mappings = false,
        },
        win = { title = false },
        spec = {
          { "<leader>b", group = "buffers" },
          { "<leader>c", group = "change" },
          { "<leader>g", group = "git" },
          { "<leader>l", group = "lsp" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui/toggles" },
          { "<leader>v", group = "treesitter" },
          { "<leader>.", group = "scratch/rename" },
          { "<leader>i", group = "insert" },
          { "<leader>p", hidden = true },
          { "<leader>w", hidden = true },
          { "<leader>y", hidden = true },
          { "<leader>Y", hidden = true },
        },
      })

      -- which-key's recommended keybind: show the keymaps of the current buffer
      vim.keymap.set("n", "<leader>?", function()
        require("which-key").show({ global = false })
      end, { desc = "Show keymaps" })
    end,
  },
}
