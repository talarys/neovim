-- Non-plugin keymaps only; plugin-specific binds live with their plugin spec.
local map = vim.keymap.set

map({ "n", "i", "v" }, "<C-s>", "<Cmd>write<CR>", { desc = "Save file" })
map({ "n", "i", "v" }, "<leader>w", "<Cmd>write<CR>", { desc = "Save file" })

map("n", "<leader>qq", "<Cmd>quitall!<CR>", { desc = "Quit all" })
map("n", "<leader>qw", "<C-w>c", { desc = "Close window" })

map("n", "<leader>|", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>-", "<Cmd>split<CR>", { desc = "Horizontal split" })

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- General ---------------------------------------------------------------------
map("n", "<leader>cf", ":set filetype=", { desc = "Change filetype" })
map("n", "<leader>id", "<Cmd>put =strftime('%Y-%m-%d')<CR>", { desc = "Insert date at cursor" })
-- Diff -------------------------------------------------------------------------
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

-- Treesitter -------------------------------------------------------------------
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
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down, cursor centred" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up, cursor centred" })
map("n", "n", "nzzzv", { desc = "Next match, cursor centred" })
map("n", "N", "Nzzzv", { desc = "Previous match, cursor centred" })

-- Clipboard (keeps the unnamed register free) ---------------------------------
map({ "n", "v", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v", "x" }, "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map("x", "<leader>P", '"_dP', { desc = "Paste over selection without clobbering" })

-- UI toggles ------------------------------------------------------------------
local function toggle_conceal()
  vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
end

local function toggle_treesitter()
  local buf = vim.api.nvim_get_current_buf()
  if vim.treesitter.highlighter.active[buf] then
    vim.treesitter.stop(buf)
  else
    pcall(vim.treesitter.start, buf)
  end
end

map("n", "<leader>ud", "<cmd>lua _G.toggle_diagnostics()<CR>", { desc = "Toggle diagnostics" })
map("n", "<leader>ul", "<cmd>set number!<CR>", { desc = "Toggle line numbers" })
map("n", "<leader>uL", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative numbers" })
map("n", "<leader>uh", "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
  { desc = "Toggle inlay hints", })
map("n", "<leader>uT", toggle_treesitter, { desc = "Toggle treesitter" })
map("n", "<leader>us", "<cmd>set spell!<CR>", { desc = "Toggle spelling" })
map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })
map("n", "<leader>uc", toggle_conceal, { desc = "Toggle conceal level" })

-- Terminal --------------------------------------------------------------------
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
