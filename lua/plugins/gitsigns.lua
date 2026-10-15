return {
  {
    "gitsigns.nvim",
    -- must already be configured before the first buffer is read, otherwise
    -- gitsigns' own setup() attaches that buffer without our on_attach maps
    after = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "Git: " .. desc })
          end

          -- navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, "Next hunk")
          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, "Previous hunk")

          -- actions
          map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
          map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, "Stage hunk")
          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, "Reset hunk")
          map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
          map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")
          map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
          map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Preview hunk inline")
          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, "Blame line")
          map("n", "<leader>hd", gitsigns.diffthis, "Diff this")
          map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end, "Diff this against last commit")
          map("n", "<leader>hQ", function()
            gitsigns.setqflist("all")
          end, "Hunks to quickfix (all)")
          map("n", "<leader>hq", gitsigns.setqflist, "Hunks to quickfix")

          -- toggles
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle line blame")
          map("n", "<leader>tw", gitsigns.toggle_word_diff, "Toggle word diff")

          -- text object
          map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
        end,
      })
    end,
  },
}
