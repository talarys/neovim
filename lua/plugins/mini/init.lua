-- One spec for mini.nvim: each module has its own setup() function, so the
-- per-module configs and mappings live in the files next to this one.
local modules = {
  "icons",
  "pairs",
  "ai",
  "move",
  "splitjoin",
  "surround",
  "bracketed",
}

return {
  {
    "mini.nvim",
    -- heirline renders with the icons; render-markdown resolves its icon
    -- provider at setup, so mini must be loaded before a markdown buffer
    dep_of = { "heirline.nvim", "render-markdown.nvim" },
    event = "DeferredUIEnter",
    after = function()
      for _, name in ipairs(modules) do
        require("mini." .. name).setup(require("plugins.mini." .. name).opts)
      end

      -- serve icon requests from plugins that only know nvim-web-devicons
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },
}
