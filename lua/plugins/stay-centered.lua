return {
  {
    "stay-centered.nvim",
    -- loaded once the UI exists: setup() installs the cursor hooks, so the
    -- plugin is active from startup instead of only after the first toggle
    event = "DeferredUIEnter",
    keys = {
      { "<leader>uC", function() require("stay-centered").toggle() end, desc = "Toggle stay-centered" },
    },
    after = function()
      require("stay-centered").setup({
        -- window scrolling is left to snacks.scroll, which animates it; only
        -- cursor motions re-center the view here
        allow_scroll_move = true,
        -- pickers (the explorer included) drive their own list and preview
        -- panes, so forcing the cursor to stay centered fights them. The same
        -- goes for markdown: render-markdown moves lines between the raw text
        -- and the rendered view, which makes recentring jump around
        skip_filetypes = {
          "markdown",
          "markdown.mdx",
          "snacks_picker_list",
          "snacks_picker_input",
        },
      })
    end,
  },
}
