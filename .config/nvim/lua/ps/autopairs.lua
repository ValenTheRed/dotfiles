local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

npairs.setup { }

require('cmp').event:on(
  'confirm_done',
  require('nvim-autopairs.completion.cmp').on_confirm_done()
)

-- > Rule('<', '>', {'html'})
-- This will insert `>` immediately after typing `<`.
-- > :replace_endpair(function(opts) return "closing" end)
-- This will replace the inserted `>` by `closing`.
-- > :replace_endpair(function(opts) return "closing" end, true)
-- This will insert the ending pair (and the replaced pair), only if the
-- string immediately to the right is the ending string.
-- > :use_move(cond.done)
-- The cursor will always skip inserting the ending pair if ending pair is
-- typed and it already exists to the immediate right of the cursor.

-- NOTE(4fc96c8): the undocumented `opts` variable is defined as an object of
-- class `CondOpts` in the source files.

npairs.add_rules({
  -- BUG(4fc96c8): if the default closing pair is the empty string '' then,
  -- <BS> after/while completing the rule results in it deleting X (unknown
  -- as of writing) number of characters instead of just the previous
  -- character.

  -- BUG(4fc96c8):
  --      `:use_key('>'):use_regex(true)`
  -- and  `:use_regex(true, '>')`
  -- are not equivalent. But,
  --      `:use_regex(true):use_key('>')`
  -- and  `:use_regex(true, '>')`
  -- are equivalent. Order of invocation matters. This shouldn't be the case.

  Rule('<%s*([%a%d]+)', 'd', {'html', 'xml', 'xhtml', 'htm'})
  -- Trigger key `>` will also be inserted into the buffer.
    :use_regex(true, '>')
    :replace_endpair(function(opts)
      -- replace end pair `d` with...
      if opts.line:sub(opts.col - 1, opts.col) == "/" then
        return ""
      end
      return "</" .. opts.text:match(opts.rule.start_pair) .. ">"
    end),

  Rule('function%s*%(.-%)', 'end', {'lua'})
    :use_regex(true)
    :end_wise(cond.done),

  Rule('do', 'end', {'lua'}):end_wise(cond.done),

  Rule('then', 'end', {'lua'}):end_wise(function(opts)
    return string.find(opts.line, '^%s*if') ~= nil
  end),

  Rule('\\[', '\\]', {'tex'}),

  Rule("$", "$", {'tex'}):with_move(cond.done),

  --Ref: https://github.com/sriramkandukuri/devenv/blob/master/vim/lua/devenv/autopairs.lua
  Rule(' ', ' '):with_pair(function(opts)
    local pair = opts.line:sub(opts.col - 1, opts.col)
    return vim.tbl_contains({'()', '[]', '{}'}, pair)
  end),
})
