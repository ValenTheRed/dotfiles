local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

npairs.setup {}

require('cmp').event:on(
  'confirm_done',
  require('nvim-autopairs.completion.cmp').on_confirm_done()
)

npairs.add_rules({
  Rule('<', '>', {'html', 'xml', 'xhtml', 'htm'}),
  --Ref: https://github.com/sriramkandukuri/devenv/blob/master/vim/lua/devenv/autopairs.lua
  Rule('\\[', '\\]', {'tex'}),
  Rule("$", "$", {'tex'}),
  Rule(' ', ' ')
  :with_pair(function(opts)
    local pair = opts.line:sub(opts.col - 1, opts.col)
    return vim.tbl_contains({'()', '[]', '{}'}, pair)
  end),
})
