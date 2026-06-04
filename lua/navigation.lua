-- Navigation: Telescope and Neo-tree

local function gh(repo)
  return 'https://github.com/' .. repo
end

-- Telescope dependencies
local has_make = vim.fn.executable 'make' == 1
vim.pack.add {
  gh 'nvim-lua/plenary.nvim',
  gh 'nvim-telescope/telescope-ui-select.nvim',
}
if has_make then
  vim.pack.add { gh 'nvim-telescope/telescope-fzf-native.nvim' }
end
vim.pack.add { gh 'nvim-telescope/telescope.nvim' }

-- Telescope setup
require('telescope').setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}
if has_make then
  pcall(require('telescope').load_extension, 'fzf')
end
pcall(require('telescope').load_extension, 'ui-select')

-- Telescope keymaps
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

-- Neo-tree dependencies
vim.pack.add { gh 'MunifTanjim/nui.nvim' }
vim.pack.add { gh 'nvim-neo-tree/neo-tree.nvim' }

-- Neo-tree setup
require('neo-tree').setup {
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}

-- Neo-tree keymaps
vim.keymap.set('n', '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })
vim.keymap.set('n', '<leader>n', ':Neotree toggle<CR>', { desc = 'NeoTree toggle', silent = true })
