return {
  {
    "nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>li",
        function()
          require("lint").try_lint()
        end,
        desc = "Lint buffer",
      },
    },
    after = function()
      require("lint").linters_by_ft = {
        nix = { "statix", "deadnix" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
