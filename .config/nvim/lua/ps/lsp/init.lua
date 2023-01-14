local telescope_builtin = require('telescope.builtin')

-- For nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local toggle_document_highlight = (function()
  local id = vim.api.nvim_create_augroup("lsp_document_highlight", {
    clear = true
  })
  return function()
    -- [Reference](https://vi.stackexchange.com/questions/4120) for
    -- toggling autocmds.
    if vim.fn.exists("#lsp_document_highlight#CursorHold#<buffer>") ~= 0 then
      vim.notify("nohldocument")
      -- Clearing autocmds doesn't automatically clear the highlights.
      vim.lsp.buf.clear_references()
      -- Only clear the autocmds defined for the current buffer,
      -- otherwise highlights in other buffers will disappear.
      vim.api.nvim_clear_autocmds({ buffer = 0, group = id })
    else
      vim.notify("hldocument")
      vim.api.nvim_create_autocmd("CursorHold", {
        group = id, buffer = 0, callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = id, buffer = 0, callback = vim.lsp.buf.clear_references,
      })
    end
  end
end)()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local client_namespace = vim.lsp.diagnostic.get_namespace(client.id)
  local nmap = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, {
      noremap = true, silent = true, desc = desc,
    })
  end
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  nmap("gD", vim.lsp.buf.declaration, "lsp.declaration")
  nmap("gd", telescope_builtin.lsp_definitions, "Telescope list/goto definitions")
  nmap("K", vim.lsp.buf.hover, "floating lsp symbol info")
  -- Default mapping of gi is occasionally useful. Default gR seems pretty useless.
  nmap("gR", telescope_builtin.lsp_implementations, "Telescope list/goto implementations")
  nmap("gs", vim.lsp.buf.signature_help, "floating lsp function signature help")
  nmap("gr", telescope_builtin.lsp_references, "Telescope lists references")
  nmap("<space>dr", function()
    telescope_builtin.lsp_document_symbols({
      previewer = false,
    })
  end, "Telescope list doc symbols")
  nmap("<space>wr", telescope_builtin.lsp_workspace_symbols, "Telescope list lsp workspace symbols")
  nmap("<space>wa", vim.lsp.buf.add_workspace_folder)
  nmap("<space>wr", vim.lsp.buf.remove_workspace_folder)
  nmap("<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "print workspace folders in :messages section")
  nmap("<space>D", telescope_builtin.lsp_type_definitions, "Telescope list/goto type definitions")
  nmap("<space>rn", vim.lsp.buf.rename, "lsp rename identifier under cursor")
  nmap("<space>ca", function()
    telescope_builtin.lsp_code_actions({
      previewer = false,
    })
  end, "Telescope list code actions")
  nmap("<space>e", function()
    vim.diagnostic.open_float({
      namespace = client_namespace, scope = "line", source = true,
    })
  end, "floating current line diagnostics")
  nmap("<space>q", vim.diagnostic.setloclist, "vim.lsp.diagnostic.set_loclist")
  nmap("[d", vim.diagnostic.goto_prev, "jump to previous diagnostic in buffer")
  nmap("]d", vim.diagnostic.goto_next, "jump to next diagnostic in buffer")

  if client.server_capabilities.documentFormattingProvider or
    client.server_capabilities.document_range_formatting then
    nmap("<space>f", vim.lsp.buf.format, "vim.lsp.buf.format")
  end

  if client.server_capabilities.documentHighlightProvider then
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
