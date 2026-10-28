local function harpoon()
  return require("harpoon")
end

return {
  {
    "harpoon2",
    keys = {
      {
        "<leader>ba",
        function()
          harpoon():list():add()
        end,
        desc = "Add file to harpoon",
      },
      {
        "<leader>bb",
        function()
          harpoon().ui:toggle_quick_menu(harpoon():list())
        end,
        desc = "Harpoon menu",
      },
      {
        "<leader>b1",
        function()
          harpoon():list():select(1)
        end,
        desc = "Harpoon slot 1",
      },
      {
        "<leader>b2",
        function()
          harpoon():list():select(2)
        end,
        desc = "Harpoon slot 2",
      },
      {
        "<leader>b3",
        function()
          harpoon():list():select(3)
        end,
        desc = "Harpoon slot 3",
      },
      {
        "<leader>b4",
        function()
          harpoon():list():select(4)
        end,
        desc = "Harpoon slot 4",
      },
      {
        "<leader>bj",
        function()
          harpoon():list():next()
        end,
        desc = "Harpoon next file",
      },
      {
        "<leader>bk",
        function()
          harpoon():list():prev()
        end,
        desc = "Harpoon previous file",
      },
      {
        "<leader>br",
        function()
          harpoon():list():remove()
        end,
        desc = "Remove file from harpoon",
      },
    },
    after = function()
      -- harpoon2 requires setup() to install its autocmds
      require("harpoon"):setup()
    end,
  },
}
