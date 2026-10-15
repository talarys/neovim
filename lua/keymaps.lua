-- Non-plugin keymaps only; plugin-specific binds live with their plugin spec.
local map = vim.keymap.set

-- Windows ---------------------------------------------------------------------
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffers ---------------------------------------------------------------------
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Editing ---------------------------------------------------------------------
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<", "<gv", { desc = "Indent and keep the selection" })
map("v", ">", ">gv", { desc = "Outdent and keep the selection" })
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

-- Terminal --------------------------------------------------------------------
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TODO: add <leader>ur to toggle relativenumber.
-- TODO: add <leader>wm to maximise the current split (:resize / :vertical resize).
-- TODO: add j/k as expr maps so they follow wrapped lines (gj/gk).
-- TODO: add <leader>qq / <leader>qw for quick quit / write-quit.
