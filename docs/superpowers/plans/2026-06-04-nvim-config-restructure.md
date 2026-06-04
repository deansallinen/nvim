# Neovim Config Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure Neovim config from nested kickstart layout to flat category-based layout with 5 files in lua/.

**Architecture:** Move vim.opt settings to init.lua, consolidate plugins by domain into focused lua/ files, delete legacy kickstart/custom directories.

**Tech Stack:** Neovim 0.12, vim.pack, Lua

---

## File Structure

| File | Purpose |
|------|---------|
| `init.lua` | Options, globals, basic keymaps, require calls |
| `lua/plugins.lua` | vim.pack.add + small plugin configs |
| `lua/navigation.lua` | Telescope, Neo-tree |
| `lua/git.lua` | Gitsigns with all keymaps |
| `lua/lsp.lua` | LSP, Mason, TypeScript, completion |
| `lua/format.lua` | Conform + nvim-lint |
| `lua/debug.lua` | DAP and debugging |
| `README.md` | Add "Plugins I've Tried" section |

---

### Task 1: Create lua/plugins.lua

**Files:**
- Create: `lua/plugins.lua`

- [ ] **Step 1: Create plugins.lua with all small plugin configs**

```lua
-- Plugin installation and small configs
-- Plugins with larger configs live in their own domain files

local function gh(repo)
  return 'https://github.com/' .. repo
end

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
```

- [ ] **Step 2: Verify file is valid Lua**

Run: `nvim --headless -c "lua if loadfile('lua/plugins.lua') then print('OK') else print('FAIL') end" -c q 2>&1 | grep -E '(OK|FAIL|Error)'`

Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add lua/plugins.lua
git commit -m "feat: create lua/plugins.lua with small plugin configs"
```

---

### Task 2: Create lua/navigation.lua

**Files:**
- Create: `lua/navigation.lua`

- [ ] **Step 1: Create navigation.lua with Telescope and Neo-tree**

```lua
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
```

- [ ] **Step 2: Verify file is valid Lua**

Run: `nvim --headless -c "lua if loadfile('lua/navigation.lua') then print('OK') else print('FAIL') end" -c q 2>&1 | grep -E '(OK|FAIL|Error)'`

Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add lua/navigation.lua
git commit -m "feat: create lua/navigation.lua with Telescope and Neo-tree"
```

---

### Task 3: Create lua/git.lua

**Files:**
- Create: `lua/git.lua`

- [ ] **Step 1: Create git.lua with gitsigns and keymaps**

```lua
-- Git integration: Gitsigns

local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add { gh 'lewis6991/gitsigns.nvim' }

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions (visual mode)
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [s]tage hunk' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'git [r]eset hunk' })

    -- Actions (normal mode)
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis '@'
    end, { desc = 'git [D]iff against last commit' })

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
  end,
}
```

- [ ] **Step 2: Verify file is valid Lua**

Run: `nvim --headless -c "lua if loadfile('lua/git.lua') then print('OK') else print('FAIL') end" -c q 2>&1 | grep -E '(OK|FAIL|Error)'`

Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add lua/git.lua
git commit -m "feat: create lua/git.lua with gitsigns"
```

---

### Task 4: Create lua/lsp.lua

**Files:**
- Create: `lua/lsp.lua`

- [ ] **Step 1: Create lsp.lua with LSP, completion, and related configs**

```lua
-- LSP, completion, and language intelligence

local function gh(repo)
  return 'https://github.com/' .. repo
end

-- Mason (package manager for LSP servers)
vim.pack.add { gh 'mason-org/mason.nvim' }
require('mason').setup {}

-- Completion: blink.cmp + LuaSnip
vim.pack.add {
  { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
  { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
}

require('luasnip').setup {}
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}

-- Lazydev (Lua LSP for Neovim config)
vim.pack.add { gh 'folke/lazydev.nvim' }
require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

-- Fidget (LSP status)
vim.pack.add { gh 'j-hui/fidget.nvim' }
require('fidget').setup {}

-- TypeScript tools
vim.pack.add { gh 'neovim/nvim-lspconfig' }
vim.pack.add { gh 'pmizio/typescript-tools.nvim' }
require('typescript-tools').setup {
  filetypes = {
    'typescript',
    'javascript',
    'typescriptreact',
    'javascriptreact',
    'typescript.tsx',
    'javascript.jsx',
  },
  settings = {
    formatter_enable = false,
  },
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
```

- [ ] **Step 2: Verify file is valid Lua**

Run: `nvim --headless -c "lua if loadfile('lua/lsp.lua') then print('OK') else print('FAIL') end" -c q 2>&1 | grep -E '(OK|FAIL|Error)'`

Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add lua/lsp.lua
git commit -m "feat: create lua/lsp.lua with LSP and completion"
```

---

### Task 5: Create lua/format.lua

**Files:**
- Create: `lua/format.lua`

- [ ] **Step 1: Create format.lua with conform and nvim-lint**

```lua
-- Code formatting and linting

local function gh(repo)
  return 'https://github.com/' .. repo
end

-- Conform (formatting)
vim.pack.add { gh 'stevearc/conform.nvim' }

require('conform').setup {
  log_level = vim.log.levels.DEBUG,
  notify_on_error = true,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    nix = { 'alejandra' },
    javascript = { 'prettierd', 'prettier', 'biome', 'biome-organize-imports', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', 'biome', 'biome-organize-imports', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', 'biome', 'biome-organize-imports', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', 'biome', 'biome-organize-imports', stop_after_first = true },
    css = { 'prettierd', 'prettier', 'biome', 'biome-organize-imports', stop_after_first = true },
    html = { 'prettierd', 'prettier', 'biome', 'biome-organize-imports', stop_after_first = true },
    svelte = { 'prettierd', 'prettier', 'biome', 'biome-organize-imports', stop_after_first = true },
  },
  formatters = {
    biome = {
      require_cwd = true,
      cwd = require('conform.util').root_file { 'biome.json' },
    },
    ['biome-organize-imports'] = {
      require_cwd = true,
      cwd = require('conform.util').root_file { 'biome.json' },
    },
    prettierd = {
      require_cwd = true,
      cwd = require('conform.util').root_file { '.prettierrc' },
    },
    prettier = {
      require_cwd = true,
      cwd = require('conform.util').root_file { '.prettierrc' },
    },
  },
}

-- Format keymap
vim.keymap.set('', '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })

-- nvim-lint (linting)
vim.pack.add { gh 'mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {
  lua = { 'selene' },
  markdown = { 'markdownlint' },
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  svelte = { 'eslint_d' },
}

-- Lint autocommand
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('lint', { clear = true }),
  callback = function()
    if vim.opt_local.modifiable:get() then
      lint.try_lint()
    end
  end,
})
```

- [ ] **Step 2: Verify file is valid Lua**

Run: `nvim --headless -c "lua if loadfile('lua/format.lua') then print('OK') else print('FAIL') end" -c q 2>&1 | grep -E '(OK|FAIL|Error)'`

Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add lua/format.lua
git commit -m "feat: create lua/format.lua with conform and nvim-lint"
```

---

### Task 6: Create lua/debug.lua

**Files:**
- Create: `lua/debug.lua`

- [ ] **Step 1: Create debug.lua with DAP configuration**

```lua
-- Debugging with DAP

local function gh(repo)
  return 'https://github.com/' .. repo
end

-- Dependencies
vim.pack.add { gh 'nvim-neotest/nvim-nio' }
vim.pack.add { gh 'rcarriga/nvim-dap-ui' }
vim.pack.add { gh 'jay-babu/mason-nvim-dap.nvim' }
vim.pack.add { gh 'leoluz/nvim-dap-go' }
vim.pack.add { gh 'mfussenegger/nvim-dap' }

local dap = require 'dap'
local dapui = require 'dapui'

-- Keymaps
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

-- Mason DAP setup
require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = { 'delve' },
}

-- DAP UI setup
dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

-- Auto open/close DAP UI
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Go debugger
require('dap-go').setup {
  delve = {
    detached = vim.fn.has 'win32' == 0,
  },
}
```

- [ ] **Step 2: Verify file is valid Lua**

Run: `nvim --headless -c "lua if loadfile('lua/debug.lua') then print('OK') else print('FAIL') end" -c q 2>&1 | grep -E '(OK|FAIL|Error)'`

Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add lua/debug.lua
git commit -m "feat: create lua/debug.lua with DAP"
```

---

### Task 7: Rewrite init.lua

**Files:**
- Modify: `init.lua`

- [ ] **Step 1: Rewrite init.lua with options, keymaps, and require calls**

```lua
-- Neovim Configuration
-- https://github.com/dean/nvim

vim.loader.enable()

-- Leader key (must be set before plugins)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Globals
vim.g.have_nerd_font = true

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true

-- Clipboard (scheduled to avoid startup delay)
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Basic keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open [E]rror diagnostic float' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Load modules
require 'plugins'
require 'navigation'
require 'git'
require 'lsp'
require 'format'
require 'debug'
```

- [ ] **Step 2: Verify file is valid Lua**

Run: `nvim --headless -c "lua if loadfile('init.lua') then print('OK') else print('FAIL') end" -c q 2>&1 | grep -E '(OK|FAIL|Error)'`

Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add init.lua
git commit -m "refactor: rewrite init.lua with options and module requires"
```

---

### Task 8: Update README with plugins list

**Files:**
- Modify: `README.md` (create if not exists)

- [ ] **Step 1: Add or update README.md with plugins tried section**

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add README with structure and plugins tried"
```

---

### Task 9: Delete legacy directories

**Files:**
- Delete: `lua/kickstart/` (entire directory)
- Delete: `lua/custom/` (entire directory)

- [ ] **Step 1: Verify new config loads before deleting old files**

Run: `nvim --headless -c "echo 'Config loaded successfully'" -c q 2>&1`

Expected: No errors, just plugin installation messages (if any)

- [ ] **Step 2: Delete kickstart directory**

```bash
rm -rf lua/kickstart
```

- [ ] **Step 3: Delete custom directory**

```bash
rm -rf lua/custom
```

- [ ] **Step 4: Verify config still works**

Run: `nvim --headless -c "echo 'Config loaded successfully'" -c q 2>&1`

Expected: No errors

- [ ] **Step 5: Commit deletion**

```bash
git add -A
git commit -m "chore: remove legacy kickstart and custom directories"
```

---

### Task 10: Final verification

- [ ] **Step 1: Start Neovim and verify no errors**

Run: `nvim --headless -c "checkhealth" -c "q" 2>&1 | head -50`

Expected: No Lua errors on startup

- [ ] **Step 2: Test basic functionality**

Open Neovim interactively and verify:
- Colorscheme loads (catppuccin)
- `<leader>sf` opens Telescope file finder
- `\` opens Neo-tree
- LSP attaches to a Lua file (check with `:LspInfo`)
- `<leader>f` formats current buffer

- [ ] **Step 3: Final commit if any fixes needed**

```bash
git add -A
git commit -m "fix: any final adjustments" --allow-empty
```
