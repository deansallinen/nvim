-- TypeScript Tools
vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add { 'https://github.com/neovim/nvim-lspconfig' }
vim.pack.add { 'https://github.com/pmizio/typescript-tools.nvim' }

require('typescript-tools').setup {
  filetypes = {
    'typescript',
    'javascript',
    'typescriptreact',
    'javascriptreact',
    'typescript.tsx',
    'javascript.jsx',
    -- 'svelte',
  },
  settings = {
    -- diagnostics_enable = true,
    -- expose_as_code_action = { 'all' },
    -- You can also disable the built-in formatter if you want Biome to handle all formatting
    -- formatter = 'false', -- or just disable it: formatter_enable = false,
    formatter_enable = false,
  },
}

-- Lazydev for Lua LSP
-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
-- used for completion, annotations and signatures of Neovim apis
vim.pack.add { 'https://github.com/folke/lazydev.nvim' }
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

-- LSP Config
-- Fidget for status updates
vim.pack.add { 'https://github.com/j-hui/fidget.nvim' }
require('fidget').setup {}

-- Blink.cmp should already be loaded from init.lua

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
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

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
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
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

local capabilities = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.enable {
  'svelte',
  'jsonls',
  'nixd',
  'openscad_lsp',
  'cssls',
  -- 'biome',
  'html',
  'astro',
  'lua_ls',
  'gleam',
  -- 'eslint',
  'ols',
  'gopls',
}

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'love' },
        disable = { 'lowercase-global' },
      },
      workspace = {
        userThirdParty = { os.getenv 'HOME' .. '/.local/share/lls-addons' },
        checkThirdParty = 'Apply',
        -- manually add love2d since it doesn't appear otherwise - dunno why
        library = {
          '${3rd}/love2d/library',
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
