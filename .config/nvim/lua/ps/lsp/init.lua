-- For nvim-cmp
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
local telescope_mapper = require('ps.telescope.mappings')

-- global function
function toggle_document_highlight()
  -- NOTE: Ref: https://vi.stackexchange.com/questions/4120
  -- The `#CursorHold` is important. Performing a
  -- `augroup! lsp_document_highlight` gives warning `:h W19`, so we
  -- need to reset the augroup by deleting all the autocmds inside it
  -- and checking for the existence of those groups to determine if we
  -- need to populate the augroup.
  -- NOTE: all numbers are truth-y in lua, even 0; hence a negation.
  if vim.fn.exists("#lsp_document_highlight#CursorHold") ~= 0 then
    -- highlights do not disappear if toggling is performed while
    -- the symbols are highlighted.
    vim.lsp.buf.clear_references()
    -- reset it
    vim.cmd([[
      augroup lsp_document_highlight
        autocmd!
      augroup END
    ]])
  else -- create it
    vim.cmd([[
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }
  local function nmap(key, cmd)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', key, cmd, opts)
  end
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  telescope_mapper("gd", "lsp_definitions", nil, true)
  nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  telescope_mapper("gi", "lsp_implementations", nil, true)
  nmap('gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  telescope_mapper("gr", "lsp_references", nil, true)
  telescope_mapper("gdr", "lsp_document_symbols", nil, true)
  telescope_mapper("gwr", "lsp_workspace_symbols", nil, true)
  nmap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  nmap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  nmap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  telescope_mapper("<space>D", "lsp_type_definitions", nil, true)
  nmap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  telescope_mapper("<space>ca", "lsp_code_actions", nil, true)
  nmap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  nmap('<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  nmap('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  nmap(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')

  if client.resolved_capabilities.document_formatting or
    client.resolved_capabilities.document_range_formatting then
    nmap("<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
  end

  if client.resolved_capabilities.document_highlight then
    nmap("<space>dh", '<cmd>lua toggle_document_highlight()<CR>')
  end

end

-- Enable the following language servers
local servers = {'pyright', 'gopls'}
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    -- You will probably want to add a custom on_attach here to locally map
    -- keybinds to buffers with an active client
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local pid = vim.fn.getpid()
local omnisharp_bin = "C:/Software/omnisharp-win-x64/OmniSharp.exe"
require'lspconfig'.omnisharp.setup{
  cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Signs for the sign column
local icons = { error = " ", warn = " ", info = " ", hint = " " }
for type, icon in pairs(icons) do
  local title_case = string.upper(string.sub(type, 1, 1)) .. string.sub(type, 2)
  local hl = "DiagnosticSign" .. title_case
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
end
