return {
  {
    "harpoon2",
    keys = {
      {
        "<leader>bb",
        function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
        desc = "Harpoon UI",
      },
      {
        "<leader>b.",
        function() require("harpoon"):list():add() end,
        desc = "Add file to harpoon",
      },
    },
    after = function()
      -- harpoon2 requires setup() to install its autocmds
      require("harpoon"):setup()
    end,
  },
}
