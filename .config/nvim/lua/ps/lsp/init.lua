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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    local function n_buf_set_keymap(key, cmd)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', key, cmd, opts)
    end
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    n_buf_set_keymap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    n_buf_set_keymap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    n_buf_set_keymap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    n_buf_set_keymap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    n_buf_set_keymap('gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    n_buf_set_keymap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    n_buf_set_keymap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
    n_buf_set_keymap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
    n_buf_set_keymap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
    n_buf_set_keymap('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    n_buf_set_keymap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    n_buf_set_keymap('<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    n_buf_set_keymap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    n_buf_set_keymap("<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
    n_buf_set_keymap('<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
    n_buf_set_keymap('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    n_buf_set_keymap(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
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

