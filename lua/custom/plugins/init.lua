-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'github/copilot.vim' },
  { 'terrastruct/d2-vim', ft = 'd2' },
  {
    'S1M0N38/love2d.nvim',
    ft = 'lua',
    cmd = 'LoveRun',
    opts = {},
    keys = {
      { '<leader>v', ft = 'lua', desc = 'LOVE' },
      { '<leader>vv', '<cmd>LoveRun<cr>', ft = 'lua', desc = 'Run LOVE' },
      { '<leader>vs', '<cmd>LoveStop<cr>', ft = 'lua', desc = 'Stop LOVE' },
    },
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    opts = {},
  },
}
