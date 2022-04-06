local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cmp_npairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')

npairs.setup({
    cmp.event:on('confirm_done', cmp_npairs.on_confirm_done({ map_char = { tex = '' }})),
})

npairs.add_rules({
    Rule('<', '>', {'html', 'xml', 'xhtml', 'htm'}),
    --Ref: https://github.com/sriramkandukuri/devenv/blob/master/vim/lua/devenv/autopairs.lua
    Rule('\\[', '\\]', {'latex'}),
    Rule(' ', ' ')
        :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({'()', '[]', '{}'}, pair)
        end),
})
