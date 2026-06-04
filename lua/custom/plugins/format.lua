-- Autoformat with conform.nvim

vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

-- Format keymap
vim.keymap.set('', '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })

-- This will provide type hinting with LuaLS
---@module "conform"
---@type conform.setupOpts
require('conform').setup {
  log_level = vim.log.levels.DEBUG,
  notify_on_error = true,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    nix = { 'alejandra' },
    -- You can use 'stop_after_first' to run the first available formatter from the list
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
