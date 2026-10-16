vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")
require("diagnostics")

-- lze lazy-loads the plugins declared with `lazy = true` in flake.nix.
-- The specs live in lua/plugins/, one module per area.
require("lze").load("plugins")
