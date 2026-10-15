-- Editor options, grouped by concern.
local opt = vim.opt

-- Editing ---------------------------------------------------------------------
opt.expandtab = true -- use spaces instead of tabs
opt.shiftwidth = 2 -- >> and << indent by 2 spaces
opt.tabstop = 2 -- a tab character renders as 2 spaces
opt.softtabstop = 2 -- <Tab> inserts 2 spaces
opt.smartindent = true -- indent new lines based on syntax
opt.formatoptions:remove({ "c", "r", "o" }) -- don't continue comments on <CR>

-- Files -----------------------------------------------------------------------
opt.undofile = true -- keep undo history between sessions
opt.swapfile = false -- no swap files (undo + git are enough)
opt.backup = false -- no backup files
opt.confirm = true -- ask to save instead of failing on :q

-- Search ----------------------------------------------------------------------
opt.ignorecase = true -- case-insensitive search...
opt.smartcase = true -- ...unless the pattern contains an uppercase letter
opt.hlsearch = true -- highlight all matches
opt.incsearch = true -- show matches while still typing
opt.inccommand = "split" -- live preview of :substitute

-- Appearance ------------------------------------------------------------------
opt.number = true -- absolute number on the cursor line
opt.relativenumber = true -- relative numbers on every other line
opt.signcolumn = "yes" -- always reserve the sign column
opt.cursorline = true -- highlight the line the cursor is on
opt.termguicolors = true -- 24-bit colour (required by the colorscheme)
opt.laststatus = 3 -- a single global statusline (lualine)
opt.showmode = false -- the mode is already shown in the statusline
opt.scrolloff = 10 -- keep 10 lines visible above/below the cursor
opt.sidescrolloff = 8 -- keep 8 columns visible left/right of the cursor
opt.wrap = false -- don't wrap long lines
opt.list = true -- show invisible characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- how to render them
opt.fillchars = { eob = " " } -- hide the ~ on empty lines

-- Windows ---------------------------------------------------------------------
opt.splitright = true -- vertical splits open to the right
opt.splitbelow = true -- horizontal splits open below
opt.mouse = "a" -- enable the mouse in all modes

-- Completion / responsiveness -------------------------------------------------
opt.completeopt = "menu,menuone,noselect" -- never auto-insert a completion
opt.pumheight = 10 -- cap the completion popup height
opt.updatetime = 250 -- faster CursorHold (gitsigns, diagnostics)
opt.timeoutlen = 300 -- wait less for a mapped sequence to finish

-- Folding ---------------------------------------------------------------------
opt.foldmethod = "expr" -- compute folds with an expression...
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- ...from the treesitter tree
opt.foldlevel = 99 -- start with all folds open
