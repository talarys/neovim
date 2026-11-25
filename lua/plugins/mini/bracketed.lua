return {
  opts = {
    buffer = { suffix = "b", options = {} },
    comment = { suffix = "c", options = {} },
    conflict = { suffix = "x", options = {} },
    diagnostic = { suffix = "d", options = {} },
    file = { suffix = "f", options = {} },
    indent = { suffix = "i", options = {} },
    jump = { suffix = "j", options = {} },
    location = { suffix = "l", options = {} },
    oldfile = { suffix = "o", options = {} },
    quickfix = { suffix = "q", options = {} },
    treesitter = { suffix = "t", options = {} },
    -- "u" also remaps u/<C-R> so every undo/redo is recorded in the linear
    -- history MiniBracketed walks
    undo = { suffix = "u" },
    window = { suffix = "w", options = {} },
    yank = { suffix = "y", options = {} },
  },
}
