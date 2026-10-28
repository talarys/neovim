return {
  {
    "conform.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format()
        end,
        mode = { "n", "x", "v" },
        desc = "Format file",
      },
    },
    after = function()
      require("conform").setup({
        formatters_by_ft = {
          -- lua uses the LSP formatter (see lsp_format below)
          nix = { "nixfmt" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          mdx = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          python = { "ruff_format" },
          rust = { "rustfmt" },
          haskell = { "fourmolu" },
          toml = { "taplo", lsp_format = "never" },
        },
        default_format_opts = { lsp_format = "prefer" },
        format_on_save = {
          timeout_ms = 500,
        },
      })
    end,
  },
}
