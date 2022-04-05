-- CONFIG
require'compe'.setup {
    source = {
        path = true;
        buffer = true;
        nvim_lsp = true;
        nvim_lua = true;
        luasnip = true;
        calc = false;
        vsnip = false;
        ultisnips = false;
    };

    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    resolve_timeout = 800;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = {
        -- the border option is the same as `|help nvim_open_win|`
        border = { '', '' ,'', ' ', '', '', '', ' ' },
        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        max_width = 80,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
    };
}

-- MAPPING
local opts = {expr = true, noremap = true, silent = true}
vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', opts)
vim.api.nvim_set_keymap('i', '<CR>', "compe#confirm({'keys':'<Plug>delimitMateCR', 'mode':''})", opts)
vim.api.nvim_set_keymap('i', '<C-e>', "compe#close('<C-e>')", opts)
vim.api.nvim_set_keymap('i', '<C-f>', "compe#scroll({'delta':+4})", opts)
vim.api.nvim_set_keymap('i', '<C-d>', "compe#scroll({'delta':-4})", opts)
