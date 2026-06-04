-- Plugin installation and small configs
-- Plugins with larger configs live in their own domain files

-- Guess indent
vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

-- Icons
if vim.g.have_nerd_font then
  vim.pack.add { gh 'nvim-tree/nvim-web-devicons' }
end

-- Which-key
vim.pack.add { gh 'folke/which-key.nvim' }
require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

-- Treesitter
vim.pack.add { gh 'nvim-treesitter/nvim-treesitter' }
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Colorscheme
vim.pack.add { gh 'catppuccin/nvim' }
require('catppuccin').setup {
  integrations = {
    indent_blankline = {
      enabled = true,
      scope_color = 'lavender',
      colored_indent_levels = false,
    },
  },
}
vim.cmd.colorscheme 'catppuccin'

-- Todo comments
vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

-- Mini.nvim
vim.pack.add { gh 'nvim-mini/mini.nvim' }
require('mini.ai').setup { n_lines = 500 }
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
statusline.section_location = function()
  return '%2l:%-2v'
end

-- Autopairs
vim.pack.add { gh 'windwp/nvim-autopairs' }
require('nvim-autopairs').setup {}

-- Indent guides
vim.pack.add { gh 'lukas-reineke/indent-blankline.nvim' }
require('ibl').setup {}

-- Surround
vim.pack.add { gh 'kylechui/nvim-surround' }
require('nvim-surround').setup {}

-- Leap (fast motion)
vim.pack.add { 'https://github.com/tpope/vim-repeat' }
vim.pack.add { 'https://codeberg.org/andyg/leap.nvim' }
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')

-- Mustache/Handlebars
vim.pack.add { gh 'mustache/vim-mustache-handlebars' }

-- OpenSCAD
vim.pack.add { gh 'junegunn/fzf.vim' }
vim.pack.add { gh 'salkin-mada/openscad.nvim' }
vim.g.openscad_load_snippets = true
require 'openscad'

-- Pack update keymap
vim.keymap.set('n', '<leader>pu', vim.pack.update, { desc = '[P]ack [U]pdate' })
