-- One spec for the whole plugin: lze drops duplicate specs for the same plugin
-- name, and Snacks.setup() errors when called twice. The per-feature configs
-- and keymaps live in the modules next to this file.
local features = {
  "picker",
  "explorer",
  "scratch",
  "rename",
  "notifier",
  "dashboard",
  "animate",
  "scroll",
  "indent",
  "dim",
}

return {
  {
    -- must be set up at startup: it registers autocmds (dashboard, netrw replacement)
    "snacks.nvim",
    after = function()
      local opts = {}
      for _, name in ipairs(features) do
        opts[name] = require("plugins.snacks." .. name).opts
      end
      require("snacks").setup(opts)

      for _, name in ipairs(features) do
        local keys = require("plugins.snacks." .. name).keys
        if keys then
          keys()
        end
      end
    end,
  },
}
