# Neovim Configuration

My personal Neovim configuration using `vim.pack` (Neovim 0.12+).

## Structure

```
init.lua              -- Options, globals, keymaps, PackChanged hooks
plugin/               -- Auto-sourced alphabetically by Neovim
├── 00-plugins.lua    -- Core plugins: colorscheme, treesitter, mini, etc.
├── debug.lua         -- DAP debugging
├── format.lua        -- Conform, nvim-lint
├── git.lua           -- Gitsigns
├── lsp.lua           -- LSP, Mason, completion
└── navigation.lua    -- Telescope, Neo-tree
```

## Plugins I've Tried

LLM/AI completion plugins I've tested:

- `github/copilot.vim` - GitHub Copilot official
- `zbirenbaum/copilot.lua` - Lua implementation of Copilot
- `milanglacier/minuet-ai.nvim` - Local LLM completion with Ollama
- `kiddos/gemini.nvim` - Google Gemini integration
- `meeehdi-dev/bropilot.nvim` - Local LLM with Ollama
