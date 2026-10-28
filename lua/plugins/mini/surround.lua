-- NOTE: mappings starting with "s" make mini.surround map "s" to <Nop> so the
-- built-in "s" does not fire while waiting for a surround command.
return {
  opts = {
    custom_surroundings = {},
    highlight_duration = 500,
    mappings = {
      add = "sa",
      delete = "sd",
      find = "sf",
      find_left = "sF",
      highlight = "sh",
      replace = "sr",

      suffix_last = "l",
      suffix_next = "n",
    },
    n_lines = 20,
    respect_selection_type = false,
    search_method = "cover",
    silent = false,
  },
}
