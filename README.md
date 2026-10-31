# Neovim

Personal Neovim configuration built with
[nix-wrapper-modules](https://github.com/nix-community/nix-wrapper-modules)
and lazily loaded with [lze](https://github.com/BirdeeHub/lze).

```bash
nix build .
./result/bin/nvim
```

Language runtimes are system-provided. The flake ships LSPs, formatters,
linters and CLI tools.

## Plugins

| Plugin | Purpose |
| --- | --- |
| `catppuccin-nvim` | Colorscheme (mocha, transparent) |
| `heirline-nvim` | Statusline, winbar and tabline |
| `nvim-navic` | Winbar breadcrumb data |
| `mini-nvim` | `ai`, `move`, `pairs`, `splitjoin`, `surround`, `bracketed`, `icons` |
| `snacks-nvim` | Picker, explorer, scratch, rename, notifier, dashboard, animation |
| `blink-cmp` | Completion |
| `friendly-snippets` | Snippet collection for Blink |
| `nvim-lspconfig` | LSP client configuration |
| `lspsaga-nvim` | Primary LSP UI: finder, peek, rename, code actions, outline |
| `conform-nvim` | Format on save and manual formatting |
| `nvim-lint` | `statix` for Nix, `yamllint` for YAML |
| `nvim-treesitter` | Parsing, highlighting, folds |
| `nvim-treesitter-textobjects` | Function/class/parameter text objects and motions |
| `SchemaStore-nvim` | JSON and YAML schemas |
| `gitsigns-nvim` | Hunk signs, staging, blame, word diff |
| `diffview-nvim` | Side-by-side diffs and file history |
| `lazygit-nvim` | LazyGit integration |
| `harpoon2` | Pinned working files |
| `flash-nvim` | Search/jump motions |
| `noice-nvim` | Command line and message UI |
| `smart-splits-nvim` | Window navigation |
| `stay-centered-nvim` | Keeps cursor centered while scrolling |
| `which-key-nvim` | Keymap discovery |
| `auto-session` | Session save/restore |
| `lze` | Lazy loading |

### Languages

- Lua: `lua_ls`
- Nix: `nil_ls`, `nixfmt`, `statix`
- JS/TS: `ts_ls`, `eslint`, `prettier`
- JSON/YAML/TOML: `jsonls`, `yamlls`, `taplo`
- CSS/HTML: `cssls`, `html`
- Python: `ty`, `ruff`, `ruff_format`
- Rust: `rust_analyzer`, `rustfmt`
- Haskell: `hls`, `fourmolu`, `hlint` when available
- Generic: `yamllint`, SchemaStore schemas

## Keymaps

Leader is `Space`. `?` is Flash search.

### General

| Key | Action |
| --- | --- |
| `<C-s>` / `<leader>w` | Save |
| `<leader>qq` / `<leader>qw` | Quit all / close window |
| `<leader>\|` / `<leader>-` | Vertical / horizontal split |
| `jk` / `jj` | Exit insert mode |
| `<leader>cf` | Change filetype |
| `<leader>id` | Insert current date |
| `<leader>gd` | Toggle diff on all windows |
| `<leader>vt` | Select treesitter node |
| `<leader>k` | Show keymaps |
| `<Esc>` | Clear search highlight |
| `<C-d>` / `<C-u>` | Half page down/up, centered |
| `n` / `N` | Next/previous match, centered |
| `<leader>y` / `<leader>Y` | Yank / yank line to system clipboard |
| `<leader>p` / `<leader>P` | Paste / paste over selection |
| `<Esc><Esc>` (terminal) | Exit terminal mode |

### Buffers and files

| Key | Action |
| --- | --- |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bp` | Snacks buffer picker |
| `<leader>bc` | Close other buffers |
| `<leader>bh` / `<leader>bl` | Move buffer left / right |
| `<leader>e` | Toggle explorer |
| `<leader>..` / `<leader>.s` | Toggle / select scratch buffer |
| `<leader>.r` | Rename file (LSP-aware) |
| `<leader>ba` / `<leader>bb` | Harpoon add / menu |
| `<leader>b1`–`<leader>b4` | Harpoon slots 1–4 |
| `<leader>bj` / `<leader>bk` / `<leader>br` | Harpoon next / previous / remove |

### Search and pickers

| Key | Action |
| --- | --- |
| `<leader><leader>` | Smart find |
| `<leader>sf` / `sr` / `sp` / `s,` | Files / recent / projects / buffers |
| `<leader>sg` / `s?` / `sw` / `sB` / `sb` | Grep / fixed strings / word or selection / open buffers / buffer lines |
| `<leader>ss` / `sS` | LSP symbols / workspace symbols |
| `<leader>sd` / `sD` | Diagnostics / buffer diagnostics |
| `<leader>sq` / `sl` / `sR` | Quickfix / location list / resume |
| `<leader>sc` / `s:` / `sC` | Command history / command history / commands |
| `<leader>s"` / `sa` / `sH` / `si` | Registers / autocmds / highlights / icons |
| `<leader>sj` / `sm` / `sM` | Jumps / marks / man pages |
| `<leader>su` / `st` / `sT` | Undo / todo comments / TODO-FIX-FIXME |
| `<leader>sP` / `sh` / `sk` / `sn` | All pickers / help / keymaps / notifications |

Inside a Snacks picker:

| Key | Action |
| --- | --- |
| `<C-d>` / `<C-u>` | Preview scroll down / up |
| `-` / `\|` | Open in horizontal / vertical split |
| `<Enter>` | Open in window |

### LSP

| Key | Action |
| --- | --- |
| `gd` / `gpd` / `gpt` | Definition / peek definition / peek type definition |
| `K` | Hover documentation |
| `grx` / `grr` / `gri` / `gO` / `gD` | Codelens / references / implementation / document symbols / declaration |
| `<leader>lF` | Lspsaga finder |
| `<leader>lt` | Goto type definition |
| `<leader>la` / `<leader>lr` | Code action / project rename |
| `<leader>lo` / `<leader>ld` / `<leader>lw` | Outline / line diagnostics / workspace diagnostics |
| `[e` / `]e` | Previous / next diagnostic |
| `<leader>lD` / `lC` / `lI` / `lT` | Definitions / declarations / implementations / type definitions list |
| `<leader>lf` | Format |
| `<leader>li` / `ls` / `lq` / `lR` | LSP info / start / stop / restart |
| `<leader>uv` | Toggle diagnostic virtual text |

### Git

| Key | Action |
| --- | --- |
| `]h` / `[h` / `]H` / `[H` | Next / previous / last / first hunk |
| `<leader>gs` / `gr` / `gu` | Stage / reset / undo stage hunk |
| `<leader>gp` / `gP` | Preview hunk inline / popup |
| `<leader>gk` / `gK` / `gb` | Blame line / file / toggle line blame |
| `<leader>gw` / `gB` | Word diff / browse |
| `ih` | Select hunk |
| `<leader>gg` / `gl` / `gf` | LazyGit / log / current file history |
| `<leader>gv` / `<leader>gV` | Open / close Diffview |
| `<leader>gc` | Diffview: staged changes |
| `<leader>gh` / `<leader>gH` | Diffview: current file / repository history |

Inside Diffview:

| Key | Action |
| --- | --- |
| `<Tab>` / `<S-Tab>` | Next / previous file |
| `<leader>e` / `<leader>b` | Focus / toggle file panel |
| `gf` / `<C-w><C-f>` | Open file / open in split |
| `s` / `S` / `U` / `X` | Stage entry / all / unstage all / restore |
| `g?` / `q` | Help panel / close Diffview |

### Text objects and editing

| Key | Action |
| --- | --- |
| `?` | Flash search |
| `aF` / `iF` | Function outer / inner |
| `aC` / `iC` | Class outer / inner |
| `aP` / `iP` | Parameter outer / inner |
| `]F` / `[F` | Next / previous function |
| `]C` / `[C` | Next / previous class |
| `]P` / `[P` | Next / previous parameter |
| `<M-h>` / `<M-j>` / `<M-k>` / `<M-l>` | Move line/selection |
| `<` / `>` | Indent/outdent and keep selection |

### UI toggles

| Key | Action |
| --- | --- |
| `<leader>ud` / `<leader>uv` | Diagnostics / virtual text |
| `<leader>ul` / `<leader>uL` | Line numbers / relative numbers |
| `<leader>uh` / `<leader>uT` | Inlay hints / treesitter |
| `<leader>us` / `<leader>uw` / `<leader>uc` | Spelling / wrap / conceal |
| `<leader>uD` / `<leader>un` | Dim / dismiss notifications |

### Sessions

| Key | Action |
| --- | --- |
| `<leader>q.` | Restore last session |
| `<leader>ql` / `<leader>qd` | List / delete session |
| `<leader>qs` / `<leader>qD` | Save / purge orphaned sessions |
