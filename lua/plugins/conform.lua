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
          lua = { "lsp" },
          nix = { "nixfmt" },
        },
        default_format_opts = { lsp_format = "prefer" },
        format_on_save = {
          lsp_format = "prefer",
          timeout_ms = 500,
        },
      })
    end,
  },
}
