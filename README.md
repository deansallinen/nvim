# Neovim Configuration

My personal Neovim configuration using `vim.pack` (Neovim 0.12+).

## Structure

```
init.lua          -- Options, globals, basic keymaps
lua/
├── plugins.lua   -- Plugin installation + small configs
├── navigation.lua -- Telescope, Neo-tree
├── git.lua       -- Gitsigns
├── lsp.lua       -- LSP, Mason, completion
├── format.lua    -- Conform, nvim-lint
└── debug.lua     -- DAP debugging
```

## Plugins I've Tried

LLM/AI completion plugins I've tested:

- `github/copilot.vim` - GitHub Copilot official
- `zbirenbaum/copilot.lua` - Lua implementation of Copilot
- `milanglacier/minuet-ai.nvim` - Local LLM completion with Ollama
- `kiddos/gemini.nvim` - Google Gemini integration
- `meeehdi-dev/bropilot.nvim` - Local LLM with Ollama
