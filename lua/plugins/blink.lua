return {
  {
    -- loaded on insert/cmdline entry, and as a dependency of nvim-lspconfig
    -- so that its LSP capabilities are registered before a server starts
    "blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dep_of = { "nvim-lspconfig" },
    after = function()
      require("blink.cmp").setup({
        -- keymaps are declared explicitly rather than relying on a preset
        keymap = {
          preset = "none",
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<C-y>"] = { "select_and_accept", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
          ["<C-n>"] = { "select_next", "fallback_to_mappings" },
          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },
          ["<Tab>"] = { "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "snippet_backward", "fallback" },
          ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        },
        cmdline = {
          keymap = {
            preset = "none",
            ["<Tab>"] = { "show_and_insert_or_accept_single", "select_next" },
            ["<S-Tab>"] = { "show_and_insert_or_accept_single", "select_prev" },
            ["<C-space>"] = { "show", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<Right>"] = { "select_next", "fallback" },
            ["<Left>"] = { "select_prev", "fallback" },
            ["<C-y>"] = { "select_and_accept", "fallback" },
            ["<C-e>"] = { "cancel", "fallback" },
          },
        },
        signature = { enabled = true },
        -- expand and navigate snippets through Neovim's built-in vim.snippet API
        snippets = { preset = "default" },
      })

      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
    end,
  },
}
