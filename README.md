# Neovim Config

Modernized Neovim config built around `lazy.nvim`, `snacks.nvim`, `blink.cmp`, and Neovim `0.11.x`.

## Stack

- `snacks.nvim` for picker, explorer, terminal, notifier, statuscolumn, indent guides, bigfile, and quickfile behavior
- `blink.cmp` + `LuaSnip` for completion
- `nvim-lspconfig` + `mason.nvim` + `mason-lspconfig.nvim` for LSP management
- `gitsigns.nvim` + `neogit` + `codediff.nvim` for Git workflows
- `nvim-treesitter` for syntax highlighting and textobjects
- `lualine.nvim` + `bufferline.nvim` for UI
- `nvim-dap` + `nvim-dap-ui` + `vim-delve` for debugging
- `markdown-preview.nvim` for Markdown preview

## Requirements

- Neovim `0.11.5` or newer on the `0.11` stable line
- `git`
- `ripgrep`
- `curl` for `blink.cmp` prebuilt binaries
- `fd` for `snacks.nvim` explorer and fast file discovery
- a Nerd Font for icons

Optional but recommended:

- `node` for `markdown-preview.nvim`
- `tree-sitter-cli` for parser maintenance workflows
- Java `21+` for `jdtls`

## Layout

```text
~/.config/nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lsp.lua
│   │   ├── options.lua
│   │   └── theme.lua
│   └── plugins/
│       ├── init.lua
│       └── specs/
│           ├── colors.lua
│           ├── dap.lua
│           ├── editor.lua
│           ├── git.lua
│           ├── lsp.lua
│           └── snacks.lua
├── ftplugin/
│   └── java.lua
└── lazy-lock.json
```

## Keymaps

Core navigation:

- `<C-h>` or `<leader>ff`: find files
- `<leader>fg`: project grep
- `<leader>fb`: buffers
- `<leader>fh`: help
- `<C-y>`: open explorer, focus it when already open, or close it when focused
- `<leader>tt`: toggle terminal on the right

LSP:

- `gd`: definition
- `gD`: declaration
- `gi`: implementation
- `gr`: references
- `K`: hover
- `<C-k>`: signature help in normal mode
- `<leader>rn`: rename
- `<leader>La`: code action
- `<leader>f`: format buffer
- `<leader>e`: line diagnostics
- `[g` / `]g`: previous / next diagnostic

Git:

- `<leader>gp`: preview hunk
- `<leader>gs`: stage hunk
- `<leader>gu`: undo staged hunk
- `<leader>gr`: reset hunk
- `<leader>gb`: blame line
- `<leader>gg`: open Neogit
- `<leader>gd`: open CodeDiff
- `<leader>gh`: diff current file against `HEAD`

Buffers and tabs:

- `<Tab>` / `<S-Tab>`: next / previous buffer
- `<leader>bc`: close current buffer
- `<leader>bo`: close other buffers
- `<leader>tn`: new tab
- `<leader>tc`: close tab

Toggles:

- `<leader>ud`: diagnostics
- `<leader>uh`: inlay hints
- `<leader>ug`: indent guides
- `<leader>ul`: line numbers
- `<leader>uL`: relative numbers
- `<leader>uw`: wrap

## Notes

- EditorConfig support comes from Neovim’s built-in runtime plugin, not an external plugin.
- LSP-backed buffers format synchronously before save when the attached server supports formatting.
- Java configuration lives in [`ftplugin/java.lua`](ftplugin/java.lua) and expects the Mason-installed `jdtls` wrapper plus Java `21+`.
- The config intentionally no longer includes Copilot, Telescope, `nvim-tree`, `toggleterm`, `nvim-cmp`, `vim-gitgutter`, or the custom hover renderer.
