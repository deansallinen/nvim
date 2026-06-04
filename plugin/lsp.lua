-- LSP, completion, and language intelligence

vim.pack.add {
  gh 'mason-org/mason.nvim',
  { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  gh 'folke/lazydev.nvim',
  gh 'nvim-lua/plenary.nvim',
  gh 'pmizio/typescript-tools.nvim',
}

-- Mason
require('mason').setup()

-- Completion: blink.cmp
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },
  sources = {
    default = { 'lsp', 'path', 'buffer', 'lazydev' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}

-- Lazydev (Lua LSP for Neovim config)
require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}


-- TypeScript tools
require('typescript-tools').setup {
  filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'typescript.tsx', 'javascript.jsx' },
  settings = { formatter_enable = false },
}

-- LSP attach autocommand
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('<leader>ca', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
    map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
    map('<leader>oi', function()
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.name == 'typescript-tools' then
        require('typescript-tools.actions').organize_imports()
      else
        vim.lsp.buf.code_action { apply = true, context = { only = { 'source.organizeImports' } } }
      end
    end, '[O]rganize [I]mports')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method 'textDocument/inlayHint' then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Diagnostic config
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
}

-- LSP capabilities from blink.cmp
local capabilities = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config('*', { capabilities = capabilities })

-- Enable LSP servers
vim.lsp.enable {
  'svelte',
  'jsonls',
  'nixd',
  'openscad_lsp',
  'cssls',
  'html',
  'astro',
  'lua_ls',
  'gleam',
  'ols',
  'gopls',
}

-- Lua LSP config
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = {
        globals = { 'vim', 'love' },
        disable = { 'lowercase-global' },
      },
      workspace = {
        userThirdParty = { os.getenv 'HOME' .. '/.local/share/lls-addons' },
        checkThirdParty = 'Apply',
        library = { '${3rd}/love2d/library' },
      },
      telemetry = { enable = false },
    },
  },
})
