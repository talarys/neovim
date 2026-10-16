return {
  opts = {
    enabled = true,
    -- default sections minus "startup" (it requires lazy.nvim)
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
    preset = {
      -- the on-screen dashboard keys, declared explicitly
      keys = {
        { icon = "", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
        { icon = "", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
        { icon = "", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
        { icon = "", key = "e", desc = "Explorer", action = ":lua Snacks.explorer()" },
        { icon = "", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = "", key = "q", desc = "Quit", action = ":qa" },
      },
    },
  },
}
