-- CUSTOM PLUGINS
return {
  { 'github/copilot.vim', event = 'VeryLazy' }, -- github copilot plugin
  { 'terrastruct/d2-vim', ft = 'd2' }, -- d2 diagramming language support
  {
    'kylechui/nvim-surround', -- Surround text objects with symbols
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    opts = {},
  },
}
