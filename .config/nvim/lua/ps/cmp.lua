local cmp = require('cmp')

local snippet = {
  expand = function(args)
    require('luasnip').lsp_expand(args.body)
  end
}

local mapping = {
  -- NOTE: Figure out what this mapping is supposed to do.
  -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
  ['<CR>'] = cmp.mapping.confirm({ select = false }),
  ['<C-e>'] = cmp.mapping({
    i = cmp.mapping.abort(),
    c = cmp.mapping.close(),
  }),
  ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
  ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
  ['<C-n>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, {'i', 'c'}),
  ['<C-p>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, {'i', 'c'}),
}

local kind_icons = {
  Text = "",
  Method = "󰅲",
  Function = "󰡱",
  Constructor = "",
  Field = "󰇽",
  Variable = "𝓧",
  Class = "",
  Interface = "",
  Module = " ",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "󱞩",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰌹",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "󰊄"
}

cmp.setup({
  snippet = snippet,
  mapping = mapping,
  window = {
    completion = {
      col_offset = -2,
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(_, vim_item)
      -- For now, no displaying of item source
      vim_item.menu = vim_item.kind
      vim_item.kind = kind_icons[vim_item.kind]
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = vim.api.nvim_list_bufs,
      },
    },
    { name = 'path' },
  }),
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' },
  }
})

-- cmp.setup.cmdline(':', {
--   completion = {
--     autocomplete = false
--   },
--   sources = cmp.config.sources({
--     { name = 'cmdline' },
--     { name = 'buffer' },
--     { names = 'path' },
--   })
-- })

vim.keymap.set("i", "<C-n>", require("cmp").complete, {silent = true, noremap = true})
