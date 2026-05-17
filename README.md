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
- `which-key.nvim`

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

| Mode | Mode Description | Keymap | Description |
| --- | --- | --- | --- |
| `x` | Visual block/select | `<leader>v` | Better paste without overwriting the unnamed register |
| `i` | Insert | `jj` | Exit insert mode |
| `v` | Visual | `aa` | Exit visual mode |
| `n` | Normal | `<A-j>` | Move current line down |
| `n` | Normal | `<A-k>` | Move current line up |
| `i` | Insert | `<A-j>` | Move current line down from insert mode |
| `i` | Insert | `<A-k>` | Move current line up from insert mode |
| `v` | Visual | `<A-j>` | Move selected text down |
| `v` | Visual | `<A-k>` | Move selected text up |
| `v` | Visual | `J` | Move selected text down |
| `v` | Visual | `K` | Move selected text up |
| `n` | Normal | `==` | Select the whole buffer |
| `n` | Normal | `gl` | Go to end of line |
| `n` | Normal | `gh` | Go to start of line |
| `n` | Normal | `dm` | Delete a mark after prompting for the mark character |
| `n` | Normal | `<Tab>` | Next tab |
| `n` | Normal | `<S-Tab>` | Previous tab |
| `n` | Normal | `<leader>tn` | Open a new tab |
| `n` | Normal | `<C-h>` | Move to left window |
| `n` | Normal | `<C-l>` | Move to right window |
| `n` | Normal | `<C-j>` | Move to lower window |
| `n` | Normal | `<C-k>` | Move to upper window |
| `n` | Normal | `<C-M-h>` | Resize window left |
| `n` | Normal | `<C-M-l>` | Resize window right |
| `n` | Normal | `<C-M-j>` | Resize window down |
| `n` | Normal | `<C-M-k>` | Resize window up |
| `n` | Normal | `<leader>xl` | Toggle the location list |
| `n` | Normal | `<leader>xq` | Toggle the quickfix list |
| `n` | Normal | `[q` | Previous quickfix item |
| `n` | Normal | `]q` | Next quickfix item |
| `n` | Normal | `<leader>cd` | Show diagnostics for the current line |
| `n` | Normal | `]d` | Next diagnostic |
| `n` | Normal | `[d` | Previous diagnostic |
| `n` | Normal | `]e` | Next error |
| `n` | Normal | `[e` | Previous error |
| `n` | Normal | `]w` | Next warning |
| `n` | Normal | `[w` | Previous warning |
| `n` | Normal | `<leader>pp` | Open the custom `:Pack` UI |
| `n` | Normal | `<leader>pu` | Update all plugins with `vim.pack.update()` |
| `n` | Normal | `<leader>pd` | Delete a plugin by name |
| `n` | Normal | `<leader>R` | Restart Neovim and restore a saved session |
| `n` | Normal | `<leader>ff` | File search via `fff.nvim` |
| `n` | Normal | `<leader>sg` | Live grep via `fff.nvim` |
| `n` | Normal | `<leader>e` | Open the Snacks explorer |
| `n`, `v` | Normal, Visual | `<leader>fi` | Open `ConformInfo` |
| `n`, `v` | Normal, Visual | `<leader>fr` | Format the current buffer |
| `n` | Normal | `<leader>gb` | Git branches picker |
| `n` | Normal | `<leader>gl` | Git log picker |
| `n` | Normal | `<leader>gL` | Git log for current line |
| `n` | Normal | `<leader>gs` | Git status picker |
| `n` | Normal | `<leader>gS` | Git stash picker |
| `n` | Normal | `git` | Open LazyGit through Snacks |
| `n` | Normal | `<leader>gc` | Compare working tree against a chosen ref |
| `n` | Normal | `<leader>gC` | Compare two refs |
| `n` | Normal | `<leader>gd` | Compare working tree across files |
| `n` | Normal | `<leader>gD` | Compare staged changes across files |
| `n` | Normal | `<leader>gV` | Show file history |
| `v` | Visual | `<leader>gv` | Show line history for the current selection |
| `n` | Normal | `<leader>gx` | Close all VDiff windows |
| `n` | Normal | `<leader>gm` | Open merge-conflict view |
| `n` | Normal | `<leader>gf` | Diff current file against `HEAD` |
| `n` | Normal | `<leader>gF` | Diff current file against a chosen ref |
| `n` | Normal | `<leader>g2` | Compare two arbitrary files |
| `n` | Normal | `<M-t>` | Open a terminal |
| `n` | Normal | `<M-w>` | Toggle the terminal |

### Treesitter Textobjects

| Mode | Mode Description | Keymap | Description |
| --- | --- | --- | --- |
| `x`, `o` | Visual, Operator-pending | `af` | Select function outer |
| `x`, `o` | Visual, Operator-pending | `if` | Select function inner |
| `x`, `o` | Visual, Operator-pending | `ac` | Select class outer |
| `x`, `o` | Visual, Operator-pending | `ic` | Select class inner |
| `x`, `o` | Visual, Operator-pending | `aa` | Select parameter outer |
| `x`, `o` | Visual, Operator-pending | `ia` | Select parameter inner |
| `x`, `o` | Visual, Operator-pending | `ad` | Select comment outer |
| `x`, `o` | Visual, Operator-pending | `as` | Select statement outer |
| `n`, `x`, `o` | Normal, Visual, Operator-pending | `]m` | Next function start |
| `n`, `x`, `o` | Normal, Visual, Operator-pending | `[m` | Previous function start |
| `n`, `x`, `o` | Normal, Visual, Operator-pending | `]]` | Next class start |
| `n`, `x`, `o` | Normal, Visual, Operator-pending | `[[` | Previous class start |
| `n`, `x`, `o` | Normal, Visual, Operator-pending | `]M` | Next function end |
| `n`, `x`, `o` | Normal, Visual, Operator-pending | `[M` | Previous function end |
| `n`, `x`, `o` | Normal, Visual, Operator-pending | `]o` | Next loop |
| `n`, `x`, `o` | Normal, Visual, Operator-pending | `[o` | Previous loop |

### Buffer-Local and Conditional Keymaps

These mappings only exist in certain contexts.

#### LSP Attach

Set when an LSP client attaches to the current buffer, with capability checks where noted:

| Mode | Mode Description | Keymap | Description |
| --- | --- | --- | --- |
| `n` | Normal | `<leader>ca` | Code actions |
| `n` | Normal | `<leader>cl` | Run fix-all through Oxlint, ESLint, or generic LSP source fixes |
| `n` | Normal | `<leader>rn` | Rename symbol |
| `n` | Normal | `K` | Hover documentation, when supported |
| `n` | Normal | `gd` | Go to definition, when supported |
| `n` | Normal | `grt` | Go to type definition, when supported |
| `n` | Normal | `grx` | Run code lens, when supported |
| `n` | Normal | `<leader>cw` | Workspace diagnostics |

#### Gitsigns Attach

Set for buffers where `gitsigns.nvim` attaches:

| Mode | Mode Description | Keymap | Description |
| --- | --- | --- | --- |
| `n` | Normal | `]h` | Next hunk |
| `n` | Normal | `[h` | Previous hunk |
| `n` | Normal | `]H` | Last hunk |
| `n` | Normal | `[H` | First hunk |
| `n`, `v` | Normal, Visual | `<leader>ghs` | Stage hunk |
| `n`, `v` | Normal, Visual | `<leader>ghr` | Reset hunk |
| `n` | Normal | `<leader>ghS` | Stage buffer |
| `n` | Normal | `<leader>ghu` | Undo stage hunk |
| `n` | Normal | `<leader>ghR` | Reset buffer |
| `n` | Normal | `<leader>ghp` | Preview hunk inline |
| `n` | Normal | `<leader>ghb` | Blame current line |
| `n` | Normal | `<leader>ghB` | Blame current buffer |
| `n` | Normal | `<leader>ghd` | Diff this |
| `n` | Normal | `<leader>ghD` | Diff this against `~` |
| `o`, `x` | Operator-pending, Visual | `ih` | Select hunk |

#### Pack UI

Available only inside the custom `:Pack` floating window:

| Mode | Mode Description | Keymap | Description |
| --- | --- | --- | --- |
| `n` | Normal | `q` | Close the Pack UI |
| `n` | Normal | `<Esc>` | Close the Pack UI |
| `n` | Normal | `?` | Toggle inline help |
| `n` | Normal | `]]` | Jump to next plugin |
| `n` | Normal | `[[` | Jump to previous plugin |
| `n` | Normal | `<CR>` | Toggle plugin detail view |
| `n` | Normal | `U` | Update all plugins |
| `n` | Normal | `u` | Update plugin under cursor |
| `n` | Normal | `D` | Delete inactive plugin under cursor |
| `n` | Normal | `L` | Open the pack log |

#### Special Buffers

For these filetypes, `q` is mapped buffer-locally to close the window and delete the buffer:

| Mode | Mode Description | Keymap | Description |
| --- | --- | --- | --- |
| `n` | Normal | `q` | Close special buffers for `PlenaryTestPopup`, `checkhealth`, `dbout`, `gitsigns-blame`, `grug-far`, `help`, `lspinfo`, `neotest-output`, `neotest-output-panel`, `neotest-summary`, `notify`, `qf`, `spectre_panel`, `startuptime`, and `tsplayground` |

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
