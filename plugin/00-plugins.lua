-- Plugin installation and small configs
-- Plugins with larger configs live in their own domain files

vim.pack.add {
  gh 'NMAC427/guess-indent.nvim',
  gh 'folke/which-key.nvim',
  gh 'nvim-treesitter/nvim-treesitter',
  gh 'catppuccin/nvim',
  gh 'folke/todo-comments.nvim',
  gh 'nvim-mini/mini.nvim',
  gh 'windwp/nvim-autopairs',
  gh 'lukas-reineke/indent-blankline.nvim',
  gh 'kylechui/nvim-surround',
  gh 'tpope/vim-repeat',
  gh 'mustache/vim-mustache-handlebars',
  gh 'junegunn/fzf.vim',
  gh 'salkin-mada/openscad.nvim',
  'https://codeberg.org/andyg/leap.nvim',
}

if vim.g.have_nerd_font then
  vim.pack.add { gh 'nvim-tree/nvim-web-devicons' }
end

-- Guess indent
require('guess-indent').setup()

-- Which-key
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
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Colorscheme
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
require('todo-comments').setup { signs = false }

-- Mini.nvim
require('mini.ai').setup { n_lines = 500 }
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
statusline.section_location = function()
  return '%2l:%-2v'
end

-- Autopairs
require('nvim-autopairs').setup()

-- Indent guides
require('ibl').setup()

-- Surround (auto-initializes via plugin/ script)

-- Leap
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')

-- OpenSCAD
vim.g.openscad_load_snippets = true
require 'openscad'

-- Pack update keymap
vim.keymap.set('n', '<leader>pu', vim.pack.update, { desc = '[P]ack [U]pdate' })
