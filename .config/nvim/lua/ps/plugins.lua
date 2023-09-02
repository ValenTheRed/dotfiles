return {
  --{{{ psmdc.nvim
  {
    'ValenTheRed/psmdc.nvim',
    priority = 1000,
    config = function() vim.cmd.colorscheme("psmdc_dark") end,
    -- dir = "F:/Github/psmdc.nvim", dev = true,
  },
  --}}}

  --{{{ vim-plug
  -- {'junegunn/vim-plug'},
  --}}}

  --{{{ vimwiki
  -- {'vimwiki/vimwiki'},
  --}}}

  --{{{ vim-commentary: Comment stuff out
  {'tpope/vim-commentary'},
  --}}}

  --{{{ vim-fugitive: git interaction
  {'tpope/vim-fugitive'},
  --}}}

  --{{{ vim-surround
  {'tpope/vim-surround'},
  --}}}

  --{{{ vim-repeat
  {'tpope/vim-repeat'},
  --}}}

  --{{{ vim-dispatch
  {'tpope/vim-dispatch'},
  --}}}

  --{{{ rename.vim: Rename file currently working on
  {'danro/rename.vim'},
  --}}}

  --{{{ tabular: align along character
  {'godlygeek/tabular'},
  --}}}

  --{{{ vim-python-pep8-indent
  {'Vimjas/vim-python-pep8-indent'},
  --}}}

  --{{{ vim-racket
  {'wlangstroth/vim-racket'},
  --}}}

  --{{{ telescope.nvim
  {
    'nvim-telescope/telescope.nvim', 
    dependencies = {'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig'},
    config = function()

      local actions = require('telescope.actions')

      local defaults = {
        -- defaults doesn't support the key, defining it inside of a theme
        -- works.
        --results_title = false
        selection_caret = "▌",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.95,
          height = 0.85,
          prompt_position = "top",
          preview_width = function(_, cols, _)
            if cols > 200 then
              return math.floor(cols * 0.4)
            else
              return math.floor(cols * 0.6)
            end
          end,
        },

        border = true,

        vimgrep_arguments = {
          "rg", "--vimgrep", "--trim"
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      }

      require('telescope').setup({
        defaults = defaults,
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<DEL>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              }
            },
          },
        },
      })

      require('telescope').load_extension('fzf')


      -- KEYMAPS
      local builtin = require("telescope.builtin")
      local def_keymap_opts = { noremap = true, silent = true }
      local nmap = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, {
          noremap=true, silent=true , desc=desc,
        })
      end

      -- ff mnemonic for: nothing, ff is in a convenient position
      nmap("<leader>ff", function()
        builtin.buffers({
          previewer = false,
          shorten_path = false,
        })
      end, "Telescope lists open buffers in current neovim instance")

      nmap("<leader>fd", function()
        builtin.find_files({
          previewer = false,
        })
      end, "Telescope lists files in your current working directory, respects .gitignore")

      -- fg mnemonic for: file grep
      nmap("<leader>fg", builtin.live_grep,
      "Telescope search for string in CWD with live results; respects .gitignore")

      -- fm mnemonic for: file most recently used
      nmap("<leader>fm", function()
        builtin.oldfiles({
          previewer = false,
        })
      end, "Telescope lists previously open files")

      nmap("<leader>fc", function()
        builtin.colorscheme({
          enable_preview = true,
        })
      end, "Telescope lists and previews available colorschemes; applies them on <cr>")
    end},
  --}}}

  --{{{ telescope-fzf-native.nvim
  { 'nvim-telescope/telescope-fzf-native.nvim',  build = ':make' },
  --}}}

  --{{{ LuaSnip
  {'L3MON4D3/LuaSnip'},
  --}}}

  --{{{ nvim-cmp
  {
    'hrsh7th/nvim-cmp',
    dependencies = {'L3MON4D3/LuaSnip'},
    config = function()

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
          end},
  --}}}

  --{{{ cmp-path
  {'hrsh7th/cmp-path', dependencies = { 'hrsh7th/nvim-cmp' }},
  --}}}

  --{{{ cmp-buffer
  {'hrsh7th/cmp-buffer', dependencies = { 'hrsh7th/nvim-cmp' }},
  --}}}

  --{{{ cmp-cmdline
  {'hrsh7th/cmp-cmdline', dependencies = { 'hrsh7th/nvim-cmp' }},
  --}}}

  --{{{ cmp-nvim-lsp
  {
    'hrsh7th/cmp-nvim-lsp', 
    dependencies = { 'neovim/nvim-lspconfig', 'hrsh7th/nvim-cmp' },
  },
  --}}}

  --{{{ cmp_luasnip
  {'saadparwaiz1/cmp_luasnip', dependencies = { 'hrsh7th/nvim-cmp', 'L3MON4D3/LuaSnip' }},
  --}}}

  --{{{ cmp-dictionary
  -- {'uga-rosa/cmp-dictionary'},
  --}}}

  --{{{ nvim-treesitter
  {'nvim-treesitter/nvim-treesitter', config = function()
    require'nvim-treesitter.configs'.setup {
      highlight = {
        enable = true,
        disable = { "help" },
      },
      additional_vim_regex_highlighting = false,
    }
  end, build = ':TSUpdate'},
  --}}}

  --{{{ playground
  {
    'nvim-treesitter/playground', 
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require("nvim-treesitter.configs").setup {
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        }
      }
    end
  },
  --}}}

  --{{{ nvim-ts-autotag
  {
    'windwp/nvim-ts-autotag', 
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require("nvim-ts-autotag").setup {
        enable = true,
        enable_rename = true,
        enable_close = false,
        enable_close_on_slash = false,
      }
    end
  },
  --}}}

  --{{{ indent-blankline.nvim
  {'lukas-reineke/indent-blankline.nvim',
  config = function()
    require("indent_blankline").setup({
      char = "│",
      filetype_exclude = {"help", "markdown", "vimwiki"},
      buftype_exclude = {"terminal"},
    })
  end}, -- Indentation guide
  --}}}

  --{{{ nvim-colorizer.lua: RGB code colouring
  {'norcalli/nvim-colorizer.lua', config = function()
    require('colorizer').setup()
  end},
  --}}}

  --{{{ gitsigns.nvim: Git Gutter
  {'lewis6991/gitsigns.nvim', config = function()
    require('gitsigns').setup{
      signs = {
        add = {
          text = '+'
        }
      },
      on_attach = function(bufnr)
        local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
          vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
        map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

        -- Actions
        map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
        map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
        map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
        map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
        map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
        map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
        map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
        map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
        map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

        -- Text object
        map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    }
  end},
  --}}}

  --{{{ nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    config = function()

      local telescope_builtin = require('telescope.builtin')

      -- For nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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
    end
  },
  --}}}

  --{{{ lualine.nvim
  {'nvim-lualine/lualine.nvim', config = function()

    -- Definig the statusline.
    local statusline = {}

    -- set empty table to remove dafaults
    statusline.sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }

    -- set empty table to remove dafaults
    statusline.inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          -- Dummy component that centers the subsequent section.
          function() return "%=" end,
        },
        {
          'filename',
          icons_enabled = true,
          icon = "",
          path = 1,
        },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }

    -- Inserts component at lualine section {a, b, c, x, y, z}
    local function insert(section, component)
      table.insert(statusline.sections[string.format("lualine_%s", section)], component)
    end

    insert("a", {
      function() return " " end,
      padding = {},
    })

    insert("b", {
      'filename',
      icon = "",
      path = 1,
    })

    insert("c", {
      'filetype',
      icons_enabled = false,
      -- hide when width less than 70
      cond = function() return vim.fn.winwidth(0) > 80 end,
    })

    -- default component has too much space around it
    insert("c", {
      function ()
        return "%l:%c"
      end,
      icon = "",
    })

    insert("c", {
      'diagnostics',
      -- Having both nvim_diagnostic and nvim_lsp leads to the component
      -- reporting twice the number of errors.
      sources = { 'nvim_diagnostic', },
      coloured = true,
      symbols = require("ps.vim_diagnostic").icons,
    })

    insert("x", {
      function()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 1 then
          return string.sub(clients[1].name, 1, 1)
        end
        local names = vim.tbl_map(function(client)
          return client.name
        end, clients)
        return table.concat(names, ", ")
      end,
      icon = "",
      cond = function() return #vim.lsp.get_active_clients({ bufnr = 0 }) > 0 end,
    })

    insert("x", {
      'diff',
      colored = true,
      source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
          }
        end
      end,
    })

    insert("x", {
      'branch',
      icon = "",
    })

    insert("y", {
      'encoding',
      icons_enabled = false,
      cond = function()
        -- Bring more attention by only displaying when not utf-8
        return vim.opt.encoding:get() ~= "utf-8" and vim.fn.winwidth(0) > 75
      end,
    })

    insert("y", {
      'fileformat',
      icons_enabled = false,
      cond = function()
        -- Bring more attention by only displaying when not unix
        return vim.opt.fileformat:get() ~= "unix" and vim.fn.winwidth(0) > 70
      end,
    })

    insert("z", {
      function() return " " end,
      padding = {},
    })

    require("lualine").setup {
      options = {
        -- I assume the theme will configure lualine_c and x sections sensibly.
        theme = "auto",
        component_separators = "",
        section_separators = "",
      },
      sections = statusline.sections,
      inactive_sections = statusline.inactive_sections,
      tabline_section = {
        lualine_a = {
          'filename',
          path = 2,
        }
      }
    }
  end},
  --}}}

  --{{{ lsp_signature.nvim
  -- {'ray-x/lsp_signature.nvim'},
  --}}}

  --{{{ nvim-autopairs
  {
    'windwp/nvim-autopairs',
    config = function()
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
      -- The cursor will always skip inserting the ending pair if ending pair
      -- is typed and it already exists to the immediate right of the cursor.

      -- NOTE(4fc96c8): the undocumented `opts` variable is defined as an object of
      -- class `CondOpts` in the source files.

      npairs.add_rules({
        -- BUG(4fc96c8): if the default closing pair is the empty string ''
        -- then, <BS> after/while completing the rule results in it deleting X
        -- (unknown as of writing) number of characters instead of just the
        -- previous character. Even `with_del` doesn't help.

        -- BUG(4fc96c8):
        --      `:use_key('>'):use_regex(true)`
        -- and  `:use_regex(true, '>')`
        -- are not equivalent. But,
        --      `:use_regex(true):use_key('>')`
        -- and  `:use_regex(true, '>')`
        -- are equivalent. Order of invocation matters. This shouldn't be the
        -- case.

        -- Rule('<([%a%d]+)', '<', {
        --   "html", "xml", "xhtml", "javascriptreact", "typescriptreact",
        --   "typescript", "javascript"
        -- }):use_regex(true, '>') -- Trigger `>` will also be inserted into the buffer
        -- :with_del(cond.none)
        -- :replace_endpair(function(opts)
        --   if opts.line:sub(opts.col - 1, opts.col) == "/" then
        --     return ""
        --   end
        --   return "</" .. opts.text:match(opts.rule.start_pair) .. ">"
        -- end),

        -- matches `function name(<params>)`  `function name.a(<params>)`
        Rule('function [%a_%d.]+%([%a_, .]-%)', 'end', {'lua'})
        :use_regex(true)
        :end_wise(cond.done),

      -- matches `function(<params>)` `<params>` include `...`
        Rule('function ?%([%a_, .]-%)', 'end', {'lua'})
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
    end},
  --}}}

  --{{{ neorg
  -- {'nvim-neorg/neorg'},
  --}}}
}
-- vim: set fdm=marker:
