local telescope_builtin = require('telescope.builtin')

-- For nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local function toggle_document_highlight()
  -- NOTE: Ref: https://vi.stackexchange.com/questions/4120
  -- The `#CursorHold` is important. Performing a
  -- `augroup! lsp_document_highlight` gives warning `:h W19`, so we
  -- need to reset the augroup by deleting all the autocmds inside it
  -- and checking for the existence of those groups to determine if we
  -- need to populate the augroup.
  -- NOTE: all numbers are truth-y in lua, even 0; hence a negation.
  if vim.fn.exists("#lsp_document_highlight#CursorHold#<buffer>") ~= 0 then
    -- highlights do not disappear if toggling is performed while
    -- the symbols are highlighted.
    vim.lsp.buf.clear_references()
    -- reset it
    -- `autocmd! * <buffer>` is crucial since we don't want highlight of
    -- other buffers disappearing.
    print("nohldocument")
    vim.cmd([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
      augroup END
    ]])
  else -- create it
    print("hldocument")
    vim.cmd([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local nmap = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, {
      noremap = true, silent = true, desc = desc,
    })
  end
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  nmap('gD', vim.lsp.buf.declaration, "lsp.declaration")
  nmap("gd", telescope_builtin.lsp_definitions, "Telescope list definitions")
  nmap('K', vim.lsp.buf.hover, "hover lsp symbol info")
  nmap("gi", telescope_builtin.lsp_implementations, "Telescope list implementations")
  nmap('gs', vim.lsp.buf.signature_help, "hover lsp function signature help")
  nmap("gr", telescope_builtin.lsp_references, "Telescope lists references")
  nmap("gdr", function()
    telescope_builtin.lsp_document_symbols({
      previewer = false,
    })
  end, "Telescope list doc symbols")
  nmap("gwr", telescope_builtin.lsp_workspace_symbols, "Telescope list lsp workspace symbols")
  nmap('<space>wa', vim.lsp.buf.add_workspace_folder)
  nmap('<space>wr', vim.lsp.buf.remove_workspace_folder)
  nmap('<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "print workspace folders in :messages section")
  nmap("<space>D", telescope_builtin.lsp_type_definitions, "Telescope list type definitions")
  nmap('<space>rn', vim.lsp.buf.rename, "lsp rename identifier under cursor")
  nmap("<space>ca", function()
    telescope_builtin.lsp_code_actions({
      previewer = false,
    })
  end, "Telescope list code actions")
  nmap('<space>e', vim.lsp.diagnostic.show_line_diagnostics, "hover all line diagnostics")
  nmap('<space>q', vim.lsp.diagnostic.set_loclist, "vim.lsp.diagnostic.set_loclist")
  nmap('[d', vim.lsp.diagnostic.goto_prev, "jump to previous diagnostic in buffer")
  nmap(']d', vim.lsp.diagnostic.goto_next, "jump to next diagnostic in buffer")

  if client.resolved_capabilities.document_formatting or
    client.resolved_capabilities.document_range_formatting then
    nmap("<space>f", vim.lsp.buf.formatting, "vim.lsp.buf.formatting")
  end

  if client.resolved_capabilities.document_highlight then
    nmap("<space>dh", toggle_document_highlight, "toggle ide-like symbol under cursor highlight")
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
local icons = { error = " ", warn = " ", info = " ", hint = " " }
for type, icon in pairs(icons) do
  local title_case = string.upper(string.sub(type, 1, 1)) .. string.sub(type, 2)
  local hl = "DiagnosticSign" .. title_case
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
end
