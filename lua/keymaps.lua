-- Non-plugin keymaps only; plugin-specific binds live with their plugin spec.
local map = vim.keymap.set

map({ "n", "i", "v" }, "<C-s>", "<Cmd>write<CR>", { desc = "Save file" })
map({ "n" }, "<leader>w", "<Cmd>write<CR>", { desc = "Save file" })

-- `quitall` asks about modified buffers because `confirm` is on (options.lua)
map("n", "<leader>qq", "<Cmd>quitall<CR>", { desc = "Quit all" })
map("n", "<leader>qw", "<C-w>c", { desc = "Close window" })

map("n", "<leader>|", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>-", "<Cmd>split<CR>", { desc = "Horizontal split" })

map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- General ---------------------------------------------------------------------
map("n", "<leader>cf", ":setfiletype ", { desc = "Change filetype" })
map("n", "<leader>id", "<Cmd>put =strftime('%Y-%m-%d')<CR>", { desc = "Insert date at cursor" })

-- Defaults we don't want ------------------------------------------------------
-- lspsaga's <leader>l* bindings own rename, code actions and type definitions,
-- so Neovim's built-in duplicates are dropped to keep one binding per action.
-- They are plain global defaults, so removing them during startup is enough.
for _, lhs in ipairs({ "grn", "gra", "grt" }) do
  pcall(vim.keymap.del, "n", lhs)
end

-- Diff ------------------------------------------------------------------------
local function toggle_diff()
  local active = false
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.wo[win].diff then
      active = true
      break
    end
  end
  vim.cmd(active and "windo diffoff!" or "windo diffthis")
end

map("n", "<leader>gd", toggle_diff, { desc = "Toggle diff on all windows" })

-- Treesitter ------------------------------------------------------------------
map("n", "<leader>vt", function()
  require("treesitter").select_node()
end, { desc = "Select treesitter node" })

-- Buffers ---------------------------------------------------------------------
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Editing ---------------------------------------------------------------------
map({ "n", "v" }, "<", "<gv", { desc = "Indent and keep the selection" })
map({ "n", "v" }, ">", ">gv", { desc = "Outdent and keep the selection" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- UI toggles ------------------------------------------------------------------
local function toggle_conceal()
  vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
end

-- absolute and relative numbers are toggled as a pair so they can never end up
-- in a half-on state
local function toggle_numbers()
  local enabled = vim.wo.number
  vim.wo.number = not enabled
  vim.wo.relativenumber = not enabled
end

map("n", "<leader>ud", function()
  require("diagnostics").toggle()
end, { desc = "Toggle diagnostics" })
map("n", "<leader>uv", function()
  require("diagnostics").toggle_virtual_text()
end, { desc = "Toggle diagnostic virtual text" })
map("n", "<leader>ul", toggle_numbers, { desc = "Toggle line numbers" })
map("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
map("n", "<leader>uT", function()
  require("treesitter").toggle()
end, { desc = "Toggle treesitter" })
map("n", "<leader>us", "<cmd>set spell!<CR>", { desc = "Toggle spelling" })
map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })
map("n", "<leader>uc", toggle_conceal, { desc = "Toggle conceal level" })

-- Terminal --------------------------------------------------------------------
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
