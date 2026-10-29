return {
  {
    "nvim-treesitter-textobjects",
    event = "DeferredUIEnter",
    after = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local map = vim.keymap.set
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      -- Uppercase keys avoid mini.ai's af/aa and mini.bracketed's ]f/]c.
      local function select_object(lhs, query, desc)
        map({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end, { desc = desc })
      end

      select_object("aF", "@function.outer", "Function outer")
      select_object("iF", "@function.inner", "Function inner")
      select_object("aC", "@class.outer", "Class outer")
      select_object("iC", "@class.inner", "Class inner")
      select_object("aP", "@parameter.outer", "Parameter outer")
      select_object("iP", "@parameter.inner", "Parameter inner")

      local function move_object(lhs, method, query, desc)
        map({ "n", "x", "o" }, lhs, function()
          move[method](query, "textobjects")
        end, { desc = desc })
      end

      move_object("]F", "goto_next_start", "@function.outer", "Next function")
      move_object("[F", "goto_previous_start", "@function.outer", "Previous function")
      move_object("]C", "goto_next_start", "@class.outer", "Next class")
      move_object("[C", "goto_previous_start", "@class.outer", "Previous class")
      move_object("]P", "goto_next_start", "@parameter.outer", "Next parameter")
      move_object("[P", "goto_previous_start", "@parameter.outer", "Previous parameter")
    end,
  },
}
