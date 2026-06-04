-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Mustache/Handlebars syntax
vim.pack.add { 'https://github.com/mustache/vim-mustache-handlebars' }

-- Surround text objects with symbols
vim.pack.add { 'https://github.com/kylechui/nvim-surround' }
require('nvim-surround').setup {}

-- Leap.nvim for fast motion
vim.pack.add { 'https://github.com/tpope/vim-repeat' }
vim.pack.add { 'https://codeberg.org/andyg/leap.nvim' }
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
