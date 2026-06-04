-- OpenSCAD support

-- Dependencies (LuaSnip may already be loaded in init.lua)
vim.pack.add { 'https://github.com/L3MON4D3/LuaSnip' }
vim.pack.add { 'https://github.com/junegunn/fzf.vim' }
vim.pack.add { 'https://github.com/salkin-mada/openscad.nvim' }

vim.g.openscad_load_snippets = true
require 'openscad'
