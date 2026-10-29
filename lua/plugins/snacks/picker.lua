local function pick_win(picker)
  if not picker.layout.split then
    picker.layout:hide()
  end

  local win = Snacks.picker.util.pick_win({
    main = picker.main,
    float = false,
    filter = function(_, buf)
      local ft = vim.bo[buf].filetype
      return ft == "snacks_dashboard" or not ft:find("^snacks")
    end,
  })

  if not win then
    if not picker.layout.split then
      picker.layout:unhide()
    end
    return true
  end

  picker.main = win
  if not picker.layout.split then
    vim.defer_fn(function()
      if not picker.closed then
        picker.layout:unhide()
      end
    end, 100)
  end
end

local function picker_window_keys()
  return {
    ["<c-d>"] = { "preview_scroll_down", mode = "n", desc = "Preview scroll down" },
    ["<c-u>"] = { "preview_scroll_up", mode = "n", desc = "Preview scroll up" },
    ["-"] = { "edit_split", mode = "n", desc = "Open in horizontal split" },
    ["|"] = { "edit_vsplit", mode = "n", desc = "Open in vertical split" },
  }
end

local function picker_list_keys()
  local keys = picker_window_keys()
  keys["<Enter>"] = {
    { "pick_win", "jump" },
    mode = { "n", "i" },
    desc = "Open in window",
  }
  return keys
end

return {
  opts = {
    enabled = true,
    layouts = {
      vscode = {
        layout = { width = 0.7 },
      },
    },
    actions = {
      pick_win = pick_win,
    },
    win = {
      input = { keys = picker_window_keys() },
      list = { keys = picker_list_keys() },
    },
    sources = {
      -- the explorer is a picker; its layout defaults to the left-hand
      -- "sidebar" preset, and the position is set through the picker source
      explorer = {
        layout = {
          hidden = { "input" },
          layout = { position = "right" },
        },
      },
    },
  },

  keys = function()
    local map = vim.keymap.set

    map("n", "<leader><leader>", "<cmd>lua Snacks.picker.smart()<CR>", { desc = "Smart find" })
    -- files and projects
    map("n", "<leader>sf", "<cmd>lua Snacks.picker.files()<CR>", { desc = "Files" })
    map("n", "<leader>sr", "<cmd>lua Snacks.picker.recent()<CR>", { desc = "Recent files" })
    map("n", "<leader>sp", "<cmd>lua Snacks.picker.projects()<CR>", { desc = "Projects" })
    map("n", "<leader>s,", "<cmd>lua Snacks.picker.buffers()<CR>", { desc = "Buffers" })
    -- text and symbols
    map("n", "<leader>sg", "<cmd>lua Snacks.picker.grep()<CR>", { desc = "Grep" })
    map("n", "<leader>s?",
      "<cmd>lua Snacks.picker.grep({ layout = 'ivy', args = { '--vimgrep', '--smart-case', '--fixed-strings' } })<CR>",
      { desc = "Grep (fixed strings)" })
    map({ "n", "x" }, "<leader>sw", "<cmd>lua Snacks.picker.grep_word()<CR>", { desc = "Grep word/selection" })
    map("n", "<leader>sB", "<cmd>lua Snacks.picker.grep_buffers()<CR>", { desc = "Grep open buffers" })
    map("n", "<leader>sb", "<cmd>lua Snacks.picker.lines()<CR>", { desc = "Buffer lines" })
    map("n", "<leader>ss", "<cmd>lua Snacks.picker.lsp_symbols()<CR>", { desc = "LSP symbols" })
    map("n", "<leader>sS", "<cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>", { desc = "Workspace symbols" })
    -- lists and history
    map("n", "<leader>sd", "<cmd>lua Snacks.picker.diagnostics()<CR>", { desc = "Diagnostics" })
    map("n", "<leader>sD", "<cmd>lua Snacks.picker.diagnostics_buffer()<CR>", { desc = "Buffer diagnostics" })
    map("n", "<leader>sq", "<cmd>lua Snacks.picker.qflist()<CR>", { desc = "Quickfix list" })
    map("n", "<leader>sl", "<cmd>lua Snacks.picker.loclist()<CR>", { desc = "Location list" })
    map("n", "<leader>sR", "<cmd>lua Snacks.picker.resume()<CR>", { desc = "Resume last picker" })
    map("n", "<leader>sc", "<cmd>lua Snacks.picker.command_history()<CR>", { desc = "Command history" })
    map("n", "<leader>s:", "<cmd>lua Snacks.picker.command_history()<CR>", { desc = "Command history" })
    map("n", "<leader>sC", "<cmd>lua Snacks.picker.commands()<CR>", { desc = "Commands" })
    map("n", '<leader>s"', "<cmd>lua Snacks.picker.registers()<CR>", { desc = "Registers" })
    map("n", "<leader>sa", "<cmd>lua Snacks.picker.autocmds()<CR>", { desc = "Autocmds" })
    map("n", "<leader>sH", "<cmd>lua Snacks.picker.highlights()<CR>", { desc = "Highlights" })
    map("n", "<leader>si", "<cmd>lua Snacks.picker.icons()<CR>", { desc = "Icons" })
    map("n", "<leader>sj", "<cmd>lua Snacks.picker.jumps()<CR>", { desc = "Jumps" })
    map("n", "<leader>sm", "<cmd>lua Snacks.picker.marks()<CR>", { desc = "Marks" })
    map("n", "<leader>sM", "<cmd>lua Snacks.picker.man()<CR>", { desc = "Man pages" })
    map("n", "<leader>su", function()
      Snacks.picker.undo({
        win = {
          input = {
            keys = {
              y = { "yank_add", mode = "n", desc = "Yank added lines" },
              Y = { "yank_del", mode = "n", desc = "Yank removed lines" },
            },
          },
        },
      })
    end, { desc = "Undo history" })
    map("n", "<leader>st", "<cmd>lua Snacks.picker.todo_comments({ layout = 'ivy' })<CR>", { desc = "Todo comments" })
    map("n", "<leader>sT",
      "<cmd>lua Snacks.picker.todo_comments({ keywords = { 'TODO', 'FIX', 'FIXME' }, layout = 'ivy' })<CR>",
      { desc = "Todo/Fix/Fixme comments" })
    map("n", "<leader>sP", "<cmd>lua Snacks.picker({ layout = 'vscode' })<CR>", { desc = "All pickers" })
    -- help
    map("n", "<leader>sh", "<cmd>lua Snacks.picker.help()<CR>", { desc = "Help pages" })
    map("n", "<leader>sk", "<cmd>lua Snacks.picker.keymaps()<CR>", { desc = "Keymaps" })
    -- LSP lists
    map("n", "<leader>lD", "<cmd>lua Snacks.picker.lsp_definitions()<CR>", { desc = "Definitions list" })
    map("n", "<leader>lC", "<cmd>lua Snacks.picker.lsp_declarations()<CR>", { desc = "Declarations list" })
    map("n", "<leader>lI", "<cmd>lua Snacks.picker.lsp_implementations()<CR>", { desc = "Implementations list" })
    map("n", "<leader>lT", "<cmd>lua Snacks.picker.lsp_type_definitions()<CR>", { desc = "Type definitions list" })
  end,
}
