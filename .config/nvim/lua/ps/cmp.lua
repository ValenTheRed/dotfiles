local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    mapping = {
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        {
            name = 'buffer',
            option = {
                -- get_bufnrs can be tweaked to not work on large files.
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            }
        },
        { name = 'cmdline' },
        { name = 'path' },
    }),
})

cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' },
    }
})

-- cmp.setup.cmdline(':', {
--     completion = {
--         autocomplete = false
--     },
--     sources = cmp.config.sources({
--         { name = 'cmdline' },
--         { name = 'buffer' },
--         { names = 'path' },
--     })
-- })

_G.vimrc = _G.vimrc or {}
_G.vimrc.cmp = _G.vimrc.cmp or {}
_G.vimrc.cmp.on_ctrl_n = cmp.complete
vim.api.nvim_set_keymap('c', '<C-n>', "<cmd>call v:lua.vimrc.cmp.on_ctrl_n()<CR>", {
    silent = true,
    noremap = true,
})
