-- Non-plugin keymaps only; plugin-specific binds live with their plugin spec.
local map = vim.keymap.set

map({ "n", "i", "v" }, "C-s", ":w<CR>", { desc = "Save file" })
map({ "n", "i", "v" }, "<leader>w", ":w<CR>", { desc = "Save file" })

map("n", "<leader>qq", ":quitall!<CR>", { desc = "Quit all" })
map("n", "<leader>qw", "<C-w>c", { desc = "Close window" })

map("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>-", ":split<CR>", { desc = "Horizontal split" })

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- General ---------------------------------------------------------------------
map("n", "<leader>ft", ":set filetype=", { desc = "Set filetype" })
map("n", "<leader>id", ":put =strftime('%Y-%m-%d')<CR>", { desc = "Insert date at cursor" })
map("n", "<leader>]q", ":cnext<CR>", { desc = "Quickfix next" })
map("n", "<leader>[q", ":cprev<CR>", { desc = "Quickfix previous" })
map("n", "<leader>cq", ":cclose<CR>", { desc = "Quickfix close" })

-- Buffers ---------------------------------------------------------------------
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Editing ---------------------------------------------------------------------
map({ "n", "v" }, "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map({ "n", "v" }, "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
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
map("n", "<leader>ud", "<cmd>lua _G.toggle_diagnostics()<CR>", { desc = "Toggle diagnostics" })
map("n", "<leader>ul", "<cmd>set number!<CR>", { desc = "Toggle line numbers" })
map("n", "<leader>uL", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative numbers" })
map("n", "<leader>uh", "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>", {
  desc = "Toggle inlay hints",
})
map("n", "<leader>uT", "<cmd>lua vim.treesitter.stop()<CR>", { desc = "Toggle treesitter" })
map("n", "<leader>us", "<cmd>set spell!<CR>", { desc = "Toggle spelling" })
map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })
map("n", "<leader>uc", "<cmd>set conceallevel=0<CR>", { desc = "Toggle conceal level" })

-- Terminal --------------------------------------------------------------------
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
