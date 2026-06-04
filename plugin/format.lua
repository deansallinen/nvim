-- Code formatting and linting

vim.pack.add {
  gh 'stevearc/conform.nvim',
  gh 'mfussenegger/nvim-lint',
}

-- Conform (formatting)
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
