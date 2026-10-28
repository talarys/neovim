return {
  {
    -- loaded on insert/cmdline entry, and as a dependency of nvim-lspconfig
    -- so that its LSP capabilities are registered before a server starts
    "blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dep_of = { "nvim-lspconfig" },
    after = function()
      require("blink.cmp").setup({
        -- use the "enter" preset and override the keys we care about explicitly
        keymap = {
          preset = "enter",
          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'hide', 'fallback' },
          ['<CR>'] = { 'accept', 'fallback' },
          ['<Tab>'] = { 'snippet_forward', 'fallback' },
          ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
          ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },
        cmdline = {
          keymap = {
            preset = "inherit",
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
