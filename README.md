# minivim

A personal Neovim configuration built on native `vim.pack`, with a small Lua module layout, custom plugin UI, LSP defaults, Treesitter, formatting, Git tooling, and a few focused editing conveniences.

## Highlights

- Uses Neovim's native `vim.pack` package manager instead of `lazy.nvim` or `packer.nvim`
- Custom `:Pack` floating UI for updating and removing plugins
- LSP setup through `mason.nvim`, `mason-lspconfig.nvim`, and `nvim-lspconfig`
- Completion powered by `blink.cmp`, `LuaSnip`, and GitHub Copilot integration
- Treesitter parsing, textobjects, and movement mappings
- Formatting through `conform.nvim`
- Git workflow helpers from `gitsigns.nvim`, `vdiff.nvim`, and `snacks.nvim`
- Fuzzy finding with `fff.nvim`
- Gruvbox-based UI with custom statusline, tabline, and diagnostics styling

## Requirements

This config targets a recent Neovim build with support for `vim.pack`. If your Neovim does not include `vim.pack`, this config will not work as-is.

Recommended tools:

- `git`
- `ripgrep`
- `fd` or another fast file finder supported by your fuzzy workflow
- `node` 18+ for `copilot.lua`
- `stylua` for Lua formatting
- `prettierd` and/or `oxfmt` for web formatting
- `goimports` or `gofmt` for Go
- `ruff-format`, `isort`, or `black` for Python
- `taplo` for TOML
- `nixfmt` for Nix
- `difft` for the optional two-file diff shortcut

## Install

If you want to run this config as a separate Neovim app:

```bash
git clone <your-repo-url> ~/.config/minivim
NVIM_APPNAME=minivim nvim
```

Optional shell alias:

```bash
alias minivim='NVIM_APPNAME=minivim nvim'
```

On first launch, Neovim will read `init.lua`, load the plugin specs, and use `vim.pack` to manage them.

## Project Layout

```text
.
├── init.lua
├── after/lsp/          # per-server LSP overrides
├── lua/config/         # core editor config, UI, keymaps, diagnostics
├── lua/plugins/        # plugin declarations and setup
├── nvim-pack-lock.json # pinned plugin revisions
└── stylua.toml         # formatting rules for this config
```

## Included Plugins

Core plugins currently configured here:

- `gruvbox.nvim`
- `mason.nvim`
- `mason-lspconfig.nvim`
- `nvim-lspconfig`
- `blink.cmp`
- `blink-copilot`
- `copilot.lua`
- `LuaSnip`
- `nvim-treesitter`
- `nvim-treesitter-textobjects`
- `conform.nvim`
- `fff.nvim`
- `snacks.nvim`
- `nvim-web-devicons`
- `gitsigns.nvim`
- `vdiff.nvim`
- `Comment.nvim`
- `nvim-autopairs`

Exact pinned revisions live in [`nvim-pack-lock.json`](~/.config/minivim/nvim-pack-lock.json).

## LSP and Formatting

Language servers are configured with Mason plus server-specific overrides in `after/lsp/`.

Configured servers include:

- `lua_ls`
- `rust_analyzer`
- `ts_ls`
- `denols`
- `astro`
- `cssls`
- `dockerls`
- `html`
- `intelephense`
- `jsonls`
- `laravel_ls`
- `quick_lint_js`
- `sqlls`
- `svelte`
- `tailwindcss`
- `yamlls`

Formatting is handled by `conform.nvim`. This config includes formatter mappings for Lua, Go, Python, JSON, JavaScript, TypeScript, CSS, HTML, Vue, Svelte, Astro, Markdown, GraphQL, XML, TOML, and Nix.

## Keymaps

This section documents the explicit keymaps defined in this config. It does not try to list plugin defaults that are not mapped here directly.

### Global Keymaps

#### Editing

- `x` `<leader>v` - better paste without overwriting the unnamed register
- `i` `jj` - exit insert mode
- `v` `aa` - exit visual mode
- `n` `<A-j>` - move current line down
- `n` `<A-k>` - move current line up
- `i` `<A-j>` - move current line down from insert mode
- `i` `<A-k>` - move current line up from insert mode
- `v` `<A-j>` - move selected text down
- `v` `<A-k>` - move selected text up
- `v` `J` - move selected text down
- `v` `K` - move selected text up
- `n` `==` - select the whole buffer
- `n` `gl` - go to end of line
- `n` `gh` - go to start of line
- `n` `dm` - delete a mark after prompting for the mark character

#### Tabs and Windows

- `n` `<Tab>` - next tab
- `n` `<S-Tab>` - previous tab
- `n` `<leader>tn` - open a new tab
- `n` `<C-h>` - move to left window
- `n` `<C-l>` - move to right window
- `n` `<C-j>` - move to lower window
- `n` `<C-k>` - move to upper window
- `n` `<C-M-h>` - resize window left
- `n` `<C-M-l>` - resize window right
- `n` `<C-M-j>` - resize window down
- `n` `<C-M-k>` - resize window up

#### Lists and Diagnostics

- `n` `<leader>xl` - toggle the location list
- `n` `<leader>xq` - toggle the quickfix list
- `n` `[q` - previous quickfix item
- `n` `]q` - next quickfix item
- `n` `<leader>cd` - show diagnostics for the current line
- `n` `]d` - next diagnostic
- `n` `[d` - previous diagnostic
- `n` `]e` - next error
- `n` `[e` - previous error
- `n` `]w` - next warning
- `n` `[w` - previous warning

#### Plugin Management

- `n` `<leader>pp` - open the custom `:Pack` UI
- `n` `<leader>pu` - update all plugins with `vim.pack.update()`
- `n` `<leader>pd` - delete a plugin by name
- `n` `<leader>R` - restart Neovim and restore a saved session

#### Search and Explorer

- `n` `<leader>ff` - file search via `fff.nvim`
- `n` `<leader>sg` - live grep via `fff.nvim`
- `n` `<leader>e` - open the Snacks explorer

#### Formatting

- `n`, `v` `<leader>fi` - open `ConformInfo`
- `n`, `v` `<leader>fr` - format the current buffer

#### Git

- `n` `<leader>gb` - Git branches picker
- `n` `<leader>gl` - Git log picker
- `n` `<leader>gL` - Git log for current line
- `n` `<leader>gs` - Git status picker
- `n` `<leader>gS` - Git stash picker
- `n` `git` - open LazyGit through Snacks
- `n` `<leader>gc` - compare working tree against a chosen ref
- `n` `<leader>gC` - compare two refs
- `n` `<leader>gd` - compare working tree across files
- `n` `<leader>gD` - compare staged changes across files
- `n` `<leader>gV` - show file history
- `v` `<leader>gv` - show line history for the current selection
- `n` `<leader>gx` - close all VDiff windows
- `n` `<leader>gm` - open merge-conflict view
- `n` `<leader>gf` - diff current file against `HEAD`
- `n` `<leader>gF` - diff current file against a chosen ref
- `n` `<leader>g2` - compare two arbitrary files

#### Terminal

- `n` `<M-t>` - open a terminal
- `n` `<M-w>` - toggle the terminal

### Treesitter Textobjects

#### Selection

- `x`, `o` `af` - select function outer
- `x`, `o` `if` - select function inner
- `x`, `o` `ac` - select class outer
- `x`, `o` `ic` - select class inner
- `x`, `o` `aa` - select parameter outer
- `x`, `o` `ia` - select parameter inner
- `x`, `o` `ad` - select comment outer
- `x`, `o` `as` - select statement outer

#### Movement

- `n`, `x`, `o` `]m` - next function start
- `n`, `x`, `o` `[m` - previous function start
- `n`, `x`, `o` `]]` - next class start
- `n`, `x`, `o` `[[` - previous class start
- `n`, `x`, `o` `]M` - next function end
- `n`, `x`, `o` `[M` - previous function end
- `n`, `x`, `o` `]o` - next loop
- `n`, `x`, `o` `[o` - previous loop

### Buffer-Local and Conditional Keymaps

These mappings only exist in certain contexts.

#### LSP Attach

Set when an LSP client attaches to the current buffer, with capability checks where noted:

- `n` `<leader>ca` - code actions
- `n` `<leader>cl` - run fix-all through Oxlint, ESLint, or generic LSP source fixes
- `n` `<leader>rn` - rename symbol
- `n` `K` - hover documentation, when supported
- `n` `gd` - go to definition, when supported
- `n` `grt` - go to type definition, when supported
- `n` `grx` - run code lens, when supported
- `n` `<leader>cw` - workspace diagnostics

#### Gitsigns Attach

Set for buffers where `gitsigns.nvim` attaches:

- `n` `]h` - next hunk
- `n` `[h` - previous hunk
- `n` `]H` - last hunk
- `n` `[H` - first hunk
- `n`, `v` `<leader>ghs` - stage hunk
- `n`, `v` `<leader>ghr` - reset hunk
- `n` `<leader>ghS` - stage buffer
- `n` `<leader>ghu` - undo stage hunk
- `n` `<leader>ghR` - reset buffer
- `n` `<leader>ghp` - preview hunk inline
- `n` `<leader>ghb` - blame current line
- `n` `<leader>ghB` - blame current buffer
- `n` `<leader>ghd` - diff this
- `n` `<leader>ghD` - diff this against `~`
- `o`, `x` `ih` - select hunk

#### Pack UI

Available only inside the custom `:Pack` floating window:

- `n` `q` - close the Pack UI
- `n` `<Esc>` - close the Pack UI
- `n` `?` - toggle inline help
- `n` `]]` - jump to next plugin
- `n` `[[` - jump to previous plugin
- `n` `<CR>` - toggle plugin detail view
- `n` `U` - update all plugins
- `n` `u` - update plugin under cursor
- `n` `D` - delete inactive plugin under cursor
- `n` `L` - open the pack log

#### Special Buffers

For these filetypes, `q` is mapped buffer-locally to close the window and delete the buffer:

- `PlenaryTestPopup`
- `checkhealth`
- `dbout`
- `gitsigns-blame`
- `grug-far`
- `help`
- `lspinfo`
- `neotest-output`
- `neotest-output-panel`
- `neotest-summary`
- `notify`
- `qf`
- `spectre_panel`
- `startuptime`
- `tsplayground`

## Plugin Management

This config ships with a custom `:Pack` UI defined in `lua/config/packui.lua`.

From normal mode:

- `<leader>pp` opens the UI
- `U` updates all plugins
- `u` updates the plugin under the cursor
- `D` deletes an inactive plugin
- `L` opens the update log
- `?` toggles help

## Notes

- Clipboard is set to `unnamedplus`
- Relative numbers, cursorline, smart case search, and persistent undo are enabled
- The default colorscheme is Gruvbox
- Copilot suggestions are enabled, but not auto-triggered
- Treesitter updates run after plugin updates through a `PackChanged` autocmd

## Formatting This Repo

Use `stylua` from the project root:

```bash
stylua .
```
