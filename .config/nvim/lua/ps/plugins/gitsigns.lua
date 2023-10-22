local function map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
end

local nmap = function(...)
  return map('n', ...)
end

local function on_attach(bufnr)
  -- Navigation
  nmap(']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
  nmap('[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

  -- Actions
  nmap('<leader>hs', ':Gitsigns stage_hunk<CR>')
  map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
  nmap('<leader>hr', ':Gitsigns reset_hunk<CR>')
  map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
  nmap('<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
  nmap('<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
  nmap('<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
  nmap('<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
  nmap('<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
  nmap('<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
  nmap('<leader>hd', '<cmd>Gitsigns diffthis<CR>')
  nmap('<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
  nmap('<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

  -- Text object
  map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
end

local setup = {
  signs = {
    add = {
      text = '+'
    }
  },
  current_line_blame_opts = {
    delay = 200,
  },
  on_attach = on_attach,
}

return {{
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup(setup)
  end
}}
