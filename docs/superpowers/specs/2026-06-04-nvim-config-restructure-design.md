# Neovim Config Restructure: Kickstart to Flat Category-Based

**Date:** 2026-06-04  
**Status:** Approved

## Goal

Migrate from the kickstart.nvim folder structure (`lua/kickstart/plugins/`, `lua/custom/plugins/`) to a flat, category-based structure that's simpler to navigate and maintain.

## Current State

```
~/.config/nvim/
├── init.lua (344 lines)
└── lua/
    ├── kickstart/
    │   ├── health.lua
    │   └── plugins/
    │       ├── autopairs.lua
    │       ├── debug.lua
    │       ├── gitsigns.lua
    │       ├── indent_line.lua
    │       ├── lint.lua
    │       └── neo-tree.lua
    └── custom/
        └── plugins/
            ├── format.lua
            ├── init.lua
            ├── lint.lua (duplicate)
            ├── llm.lua (commented/disabled)
            ├── lsp.lua
            ├── mason.lua
            └── openscad.lua
```

**Problems:**
- Two separate plugin directories with overlapping purposes
- Duplicate lint.lua in both locations
- Deep nesting (3 levels)
- Legacy "kickstart" naming

## Target State

```
~/.config/nvim/
├── init.lua
├── README.md
└── lua/
    ├── plugins.lua
    ├── navigation.lua
    ├── git.lua
    ├── lsp.lua
    ├── format.lua
    └── debug.lua
```

**5 files in lua/**, each with a clear domain.

## File Responsibilities

### init.lua
Core Neovim settings that rarely change:
- `vim.g.mapleader`, `vim.g.have_nerd_font`
- `vim.opt.*` settings (number, mouse, tabs, clipboard, etc.)
- Basic keymaps (window navigation, terminal escape, diagnostics)
- Autocommands (highlight on yank)
- `require()` calls to load all lua/ modules

### lua/plugins.lua
Plugin installation and small plugin configs:
- `vim.pack.add` calls for all plugins
- Treesitter setup
- Colorscheme (catppuccin)
- mini.nvim (ai, statusline)
- which-key
- todo-comments
- autopairs
- indent-blankline
- nvim-surround
- leap
- guess-indent
- nvim-web-devicons
- openscad.nvim
- vim-mustache-handlebars

### lua/navigation.lua
File/buffer navigation:
- Telescope (setup + all keymaps)
- Neo-tree (setup + keymaps)

### lua/git.lua
Git integration:
- Gitsigns (setup + all keymaps including hunk navigation, staging, blame)

### lua/lsp.lua
Language intelligence and completion:
- nvim-lspconfig
- mason.nvim
- typescript-tools.nvim
- lazydev.nvim
- fidget.nvim
- blink.cmp + luasnip
- LspAttach autocommand with keymaps
- Diagnostic config
- vim.lsp.enable calls

### lua/format.lua
Code quality:
- conform.nvim (formatting)
- nvim-lint (linting)
- Format-on-save autocommand
- Lint autocommands

### lua/debug.lua
Debugging:
- nvim-dap
- nvim-dap-ui
- nvim-dap-go
- mason-nvim-dap
- Debug keymaps (F1-F7, breakpoints)

### README.md
Add a "Plugins I've Tried" section listing LLM/AI plugins that were tested:
- github/copilot.vim
- zbirenbaum/copilot.lua
- milanglacier/minuet-ai.nvim
- kiddos/gemini.nvim
- meeehdi-dev/bropilot.nvim

## Migration Steps

1. Create new lua/ files with consolidated content
2. Refactor init.lua to only contain options/keymaps and require statements
3. Move LLM plugin list to README.md
4. Delete lua/kickstart/ directory
5. Delete lua/custom/ directory
6. Verify config loads without errors

## Success Criteria

- Neovim starts without errors
- All plugins load and function correctly
- All keymaps work as before
- No duplicate code between files
- Each file is self-contained for its domain
