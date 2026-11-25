return {
  {
    "render-markdown.nvim",
    -- rendered as soon as a markdown buffer opens, or on the toggle key. The
    -- plugin sets itself up from its own plugin/ script, so no `after` is needed;
    -- mini.icons supplies the language icons (see lua/plugins/mini/init.lua).
    ft = { "markdown" },
    keys = {
      -- toggles rendering for the current buffer only; a no-op elsewhere
      { "<leader>um", "<cmd>RenderMarkdown buf_toggle<CR>", desc = "Toggle markdown render" },
    },
  },
}
